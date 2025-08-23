/**
 * Filename: NumberMeaningViewModel.swift
 *
 * Purpose: ViewModel for NumberMeaningsView that handles async loading of rich numerological content
 * from KASPERContentRouter with proper Swift 6 concurrency patterns and memory management.
 *
 * Key Responsibilities:
 * • Async loading of rich numerological content for numbers 1-9
 * • Smart caching system for improved performance
 * • State management for loading, success, empty, and error states
 * • Swift 6 compliant concurrency with @MainActor and weak self patterns
 * • Fallback mechanisms for content loading (direct bundle → router → live templates)
 *
 * Architecture Notes:
 * • @MainActor class ensuring all UI updates occur on main thread
 * • Uses KASPERContentRouter.shared for content access
 * • Implements comprehensive error handling and logging
 * • Memory-efficient caching with clearCache() method
 *
 * Usage:
 * • Primary ViewModel for NumberMeaningsView
 * • Call load(number:) to fetch content for specific numbers
 * • Observe @Published state property for UI updates
 *
 * Dependencies:
 * • KASPERContentRouter for content loading
 * • NumberRichContent model for structured data
 * • Logger for debugging and performance tracking
 */

import Foundation
import os.log

@MainActor
final class NumberMeaningViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded(NumberRichContent)
        case empty
        case error(String)
    }

    @Published private(set) var state: State = .idle

    // Use shared router instance to avoid multiple initializations
    private let router = KASPERContentRouter.shared
    private let log = Logger(subsystem: "com.vybe.kasper", category: "NumberMeanings")

    // Simple in-memory cache per app launch
    private var cache: [Int: NumberRichContent] = [:]

    func load(number: Int) {
        // Avoid double-load flicker
        if case .loading = state { return }

        // Check cache first
        if let hit = cache[number] {
            state = .loaded(hit)
            return
        }

        state = .loading
        self.log.info("🔍 Starting to load content for number \(number)")

        // Use weak self in Task blocks per CLAUDE.md memory rules
        Task { [weak self] in
            guard let self else { return }

            // DEBUG: Check if RuntimeBundle files are accessible directly
            if let bundleURL = Bundle.main.url(forResource: "\(number)_rich", withExtension: "json", subdirectory: "KASPERMLXRuntimeBundle/RichNumberMeanings") {
                self.log.info("🎯 Found direct bundle file for \(number): \(bundleURL.path)")

                do {
                    let data = try Data(contentsOf: bundleURL)
                    let decoded = try JSONDecoder().decode(NumberRichContent.self, from: data)
                    self.cache[number] = decoded
                    self.state = .loaded(decoded)
                    self.log.info("✅ Loaded rich content directly for number \(number)")
                    return
                } catch {
                    self.log.error("❌ Direct load failed: \(error.localizedDescription)")
                }
            } else {
                self.log.warning("❌ No direct bundle file found for \(number)_rich.json")
            }

            // Wait for router initialization if needed
            while !self.router.isInitialized {
                try? await Task.sleep(nanoseconds: 30_000_000)
            }

            self.log.info("🔄 Router initialized, trying router path...")

            guard let raw = await self.router.getRichContent(for: number) else {
                self.log.warning("❌ Router returned nil for number \(number) → falling back to live templates")
                self.state = .empty
                return
            }

            do {
                let data = try JSONSerialization.data(withJSONObject: raw)
                let decoded = try JSONDecoder().decode(NumberRichContent.self, from: data)
                self.cache[number] = decoded
                self.state = .loaded(decoded)
                self.log.info("✅ Loaded rich content via router for number \(number)")
            } catch {
                self.log.error("❌ Router decode failed: \(error.localizedDescription)")
                self.state = .error("Couldn't decode rich content")
            }
        }
    }

    // Clear cache if needed for memory management
    func clearCache() {
        cache.removeAll()
        log.info("Cache cleared")
    }
}
