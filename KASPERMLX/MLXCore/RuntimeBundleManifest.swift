// KASPERMLX/MLXCore/RuntimeBundleManifest.swift
import Foundation

public struct RuntimeBundleManifest: Decodable, Sendable {
    public let version: Int
    public let essential: [String]
    public let near_term: [String]
    public let on_demand: [String]
}

public enum ManifestLoader {
    public static func load(from url: URL? = nil) throws -> RuntimeBundleManifest {
        let manifestURL: URL

        if let url = url {
            manifestURL = url
        } else {
            // iOS apps have a flat bundle structure, not Contents/Resources
            // Try directly in bundle first
            let bundleURL = Bundle.main.bundleURL
                .appendingPathComponent("KASPERMLXRuntimeBundle", isDirectory: true)
                .appendingPathComponent("RuntimeBundleManifest.json")

            print("🚀 Phase 2A: Checking iOS bundle path: \(bundleURL.path)")

            if FileManager.default.fileExists(atPath: bundleURL.path) {
                print("🚀 Phase 2A: Found in bundle")
                manifestURL = bundleURL
            } else if let mainBundleURL = Bundle.main.url(forResource: "KASPERMLXRuntimeBundle/RuntimeBundleManifest", withExtension: "json") {
                // Fallback: Try main bundle resources
                print("🚀 Phase 2A: Found in main bundle resources")
                manifestURL = mainBundleURL
            } else if let directURL = Bundle.main.url(forResource: "RuntimeBundleManifest", withExtension: "json") {
                // Try without subdirectory
                print("🚀 Phase 2A: Found directly in bundle")
                manifestURL = directURL
            } else {
                // Development fallback: Direct path (works in simulator)
                print("🚀 Phase 2A: Main bundle not found, checking dev path")
                let devPath = "/Users/Maniac_Magee/Documents/XcodeProjects/VybeMVP/KASPERMLXRuntimeBundle/RuntimeBundleManifest.json"
                if FileManager.default.fileExists(atPath: devPath) {
                    print("🚀 Phase 2A: Using dev path: \(devPath)")
                    manifestURL = URL(fileURLWithPath: devPath)
                } else {
                    print("❌ Phase 2A: No manifest found in any location")
                    throw ManifestError.missingFile(path: "Checked bundle, resources, and dev path")
                }
            }
        }

        guard FileManager.default.fileExists(atPath: manifestURL.path) else {
            throw ManifestError.missingFile(path: manifestURL.path)
        }

        let data = try Data(contentsOf: manifestURL)
        return try JSONDecoder().decode(RuntimeBundleManifest.self, from: data)
    }

    public enum ManifestError: Error {
        case missingFile(path: String)

        var localizedDescription: String {
            switch self {
            case .missingFile(let path):
                return "RuntimeBundleManifest.json not found at: \(path)"
            }
        }
    }
}
