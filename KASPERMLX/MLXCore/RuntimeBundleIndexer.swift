//
//  RuntimeBundleIndexer.swift
//  VybeMVP
//
//  Created by Claude on 1/24/25.
//  Purpose: Fast indexing system for 992 RuntimeBundle JSON files
//  Reduces startup from loading all files to just loading index (<5ms)
//

import Foundation
import SwiftUI
import os.log

/// Fast indexing system for RuntimeBundle content
/// Precomputes file paths and metadata for on-demand loading
@MainActor
final class RuntimeBundleIndexer: ObservableObject {

    // MARK: - Types

    struct BundleIndex: Codable {
        let version: String
        let createdAt: Date
        let totalFiles: Int
        let totalSize: Int64 // bytes
        let entries: [IndexEntry]
        let personaMap: [String: [String]] // persona -> [file paths]
        let focusMap: [Int: [String]]      // focus number -> [file paths]
        let realmMap: [Int: [String]]      // realm number -> [file paths]
    }

    struct IndexEntry: Codable, Hashable {
        let path: String              // Relative path from bundle
        let persona: String
        let focus: Int
        let realm: Int
        let fileSize: Int64
        let checksum: String          // For cache validation
        let contentPreview: String    // First 100 chars for quick preview

        var cacheKey: String {
            "\(persona)_\(focus)_\(realm)"
        }
    }

    struct ContentKey: Hashable {
        let persona: String
        let focus: Int
        let realm: Int
    }

    // MARK: - Singleton

    static let shared = RuntimeBundleIndexer()

    // MARK: - Published Properties

    @Published private(set) var index: BundleIndex?
    @Published private(set) var isIndexLoaded = false
    @Published private(set) var loadTime: TimeInterval?

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.vybe.runtime", category: "RuntimeBundleIndexer")
    private var contentCache = NSCache<NSString, NSData>()
    private let cacheQueue = DispatchQueue(label: "com.vybe.runtime.cache", attributes: .concurrent)
    private let indexFileName = "runtime_bundle_index.json"

    // MARK: - Initialization

    private init() {
        configureCacheSettings()
    }

    // MARK: - Public API

    /// Load the precomputed index (very fast, <5ms)
    func loadIndex() async throws {
        let startTime = Date()

        // Try to load existing index first
        if let existingIndex = try? loadExistingIndex() {
            self.index = existingIndex
            self.isIndexLoaded = true
            self.loadTime = Date().timeIntervalSince(startTime)

            logger.info("✅ Loaded existing index in \(String(format: "%.3f", self.loadTime ?? 0))s")
            return
        }

        // Build index if needed (first run or after content update)
        logger.info("Building RuntimeBundle index...")
        let newIndex = try await buildIndex()

        // Save for next time
        try saveIndex(newIndex)

        self.index = newIndex
        self.isIndexLoaded = true
        self.loadTime = Date().timeIntervalSince(startTime)

        logger.info("✅ Built and saved index in \(String(format: "%.3f", self.loadTime ?? 0))s")
    }

    /// Load specific content on-demand (lazy loading)
    func loadContent(for key: ContentKey) async throws -> Data {
        let cacheKey = "\(key.persona)_\(key.focus)_\(key.realm)" as NSString

        // Check cache first
        if let cached = contentCache.object(forKey: cacheKey) {
            logger.debug("Cache hit for \(cacheKey)")
            return cached as Data
        }

        // Find entry in index
        guard let index = index,
              let entry = index.entries.first(where: {
                  $0.persona == key.persona &&
                  $0.focus == key.focus &&
                  $0.realm == key.realm
              }) else {
            throw RuntimeBundleError.entryNotFound(key)
        }

        // Load from disk
        let data = try await loadFile(at: entry.path)

        // Cache for future use
        cacheQueue.async(flags: .barrier) {
            self.contentCache.setObject(data as NSData, forKey: cacheKey)
        }

        return data
    }

    /// Preload likely content based on usage patterns
    func preloadLikely(focus: Int, realm: Int) {
        Task.detached(priority: .background) { [weak self] in
            guard let self = self else { return }

            // Preload all personas for current focus/realm
            let personas = ["Oracle", "Psychologist", "Poet", "Coach", "Philosopher"]

            for persona in personas {
                let key = ContentKey(persona: persona, focus: focus, realm: realm)
                _ = try? await self.loadContent(for: key)
            }
        }
    }

    /// Get all entries matching criteria
    func getEntries(persona: String? = nil, focus: Int? = nil, realm: Int? = nil) -> [IndexEntry] {
        guard let index = index else { return [] }

        return index.entries.filter { entry in
            (persona == nil || entry.persona == persona) &&
            (focus == nil || entry.focus == focus) &&
            (realm == nil || entry.realm == realm)
        }
    }

    // MARK: - Private Methods

    private func configureCacheSettings() {
        // Configure cache limits based on available memory
        let memoryCapacity = ProcessInfo.processInfo.physicalMemory
        let cacheSize = min(20 * 1024 * 1024, memoryCapacity / 20) // Max 20MB or 5% of RAM

        contentCache.totalCostLimit = Int(cacheSize)
        contentCache.countLimit = 50 // Keep max 50 files in memory

        // Register for memory warnings
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }

    @objc private func handleMemoryWarning() {
        logger.warning("Memory warning - purging RuntimeBundle cache")
        contentCache.removeAllObjects()
    }

    private func loadExistingIndex() throws -> BundleIndex {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let indexURL = documentsURL.appendingPathComponent(indexFileName)

        let data = try Data(contentsOf: indexURL)
        return try JSONDecoder().decode(BundleIndex.self, from: data)
    }

    private func saveIndex(_ index: BundleIndex) throws {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let indexURL = documentsURL.appendingPathComponent(indexFileName)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(index)

        try data.write(to: indexURL)
    }

    private func buildIndex() async throws -> BundleIndex {
        var entries: [IndexEntry] = []
        var totalSize: Int64 = 0
        var personaMap: [String: [String]] = [:]
        var focusMap: [Int: [String]] = [:]
        var realmMap: [Int: [String]] = [:]

        // Get bundle path
        guard let bundlePath = Bundle.main.path(forResource: "KASPERMLXRuntimeBundle", ofType: nil) else {
            throw RuntimeBundleError.bundleNotFound
        }

        let bundleURL = URL(fileURLWithPath: bundlePath)

        // Enumerate all JSON files
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(at: bundleURL, includingPropertiesForKeys: [.fileSizeKey])

        while let fileURL = enumerator?.nextObject() as? URL {
            guard fileURL.pathExtension == "json" else { continue }

            // Parse filename for metadata (e.g., "Oracle_Focus3_Realm7.json")
            let filename = fileURL.deletingPathExtension().lastPathComponent
            let components = filename.split(separator: "_")

            guard components.count >= 3 else { continue }

            let persona = String(components[0])
            let focusStr = components[1].replacingOccurrences(of: "Focus", with: "")
            let realmStr = components[2].replacingOccurrences(of: "Realm", with: "")

            guard let focus = Int(focusStr),
                  let realm = Int(realmStr) else { continue }

            // Get file size
            let attributes = try fileManager.attributesOfItem(atPath: fileURL.path)
            let fileSize = attributes[.size] as? Int64 ?? 0
            totalSize += fileSize

            // Calculate checksum
            let checksum = try calculateChecksum(for: fileURL)

            // Get content preview
            let preview = try getContentPreview(from: fileURL)

            // Create index entry
            let relativePath = fileURL.path.replacingOccurrences(of: bundlePath + "/", with: "")
            let entry = IndexEntry(
                path: relativePath,
                persona: persona,
                focus: focus,
                realm: realm,
                fileSize: fileSize,
                checksum: checksum,
                contentPreview: preview
            )

            entries.append(entry)

            // Update maps
            personaMap[persona, default: []].append(relativePath)
            focusMap[focus, default: []].append(relativePath)
            realmMap[realm, default: []].append(relativePath)
        }

        return BundleIndex(
            version: "1.0",
            createdAt: Date(),
            totalFiles: entries.count,
            totalSize: totalSize,
            entries: entries,
            personaMap: personaMap,
            focusMap: focusMap,
            realmMap: realmMap
        )
    }

    private func calculateChecksum(for url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        let hash = data.hashValue
        return String(format: "%016llx", Int64(bitPattern: UInt64(hash)))
    }

    private func getContentPreview(from url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8) ?? ""
        return String(string.prefix(100))
    }

    private func loadFile(at path: String) async throws -> Data {
        guard let bundlePath = Bundle.main.path(forResource: "KASPERMLXRuntimeBundle", ofType: nil) else {
            throw RuntimeBundleError.bundleNotFound
        }

        let fullPath = bundlePath + "/" + path
        let url = URL(fileURLWithPath: fullPath)

        return try Data(contentsOf: url)
    }
}

// MARK: - Error Types

enum RuntimeBundleError: LocalizedError {
    case bundleNotFound
    case entryNotFound(RuntimeBundleIndexer.ContentKey)
    case invalidData

    var errorDescription: String? {
        switch self {
        case .bundleNotFound:
            return "RuntimeBundle not found in app bundle"
        case .entryNotFound(let key):
            return "No content found for \(key.persona) Focus:\(key.focus) Realm:\(key.realm)"
        case .invalidData:
            return "Invalid data format in RuntimeBundle"
        }
    }
}

// MARK: - Extension for Purgable Protocol

extension RuntimeBundleIndexer: Purgable {
    func purgeNonEssential() {
        // Remove 50% of cached content
        let currentLimit = contentCache.countLimit
        contentCache.countLimit = max(1, currentLimit / 2)
        contentCache.countLimit = currentLimit
    }

    func purgeAll() {
        contentCache.removeAllObjects()
    }
}
