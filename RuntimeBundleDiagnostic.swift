//
//  RuntimeBundleDiagnostic.swift
//  VybeMVP
//
//  Quick diagnostic to check what Bundle.main can see
//

import Foundation

struct RuntimeBundleDiagnostic {

    static func diagnose() {
        print("🔍 === RUNTIME BUNDLE DIAGNOSTIC ===")

        // Check what's in the main bundle
        if let bundlePath = Bundle.main.path(forResource: "KASPERMLXRuntimeBundle", ofType: nil) {
            print("✅ Found KASPERMLXRuntimeBundle at: \(bundlePath)")

            // List contents
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: bundlePath)
                print("📁 Contents: \(contents)")

                // Check for manifest specifically
                let manifestPath = bundlePath + "/manifest.json"
                if FileManager.default.fileExists(atPath: manifestPath) {
                    print("✅ Found manifest.json at: \(manifestPath)")
                } else {
                    print("❌ No manifest.json found")
                }

            } catch {
                print("❌ Error reading bundle contents: \(error)")
            }
        } else {
            print("❌ KASPERMLXRuntimeBundle not found in main bundle")
        }

        // Alternative check using URL method (what KASPERContentRouter uses)
        if let manifestURL = Bundle.main.url(forResource: "manifest", withExtension: "json", subdirectory: "KASPERMLXRuntimeBundle") {
            print("✅ Bundle.main.url found manifest at: \(manifestURL)")
        } else {
            print("❌ Bundle.main.url could not find manifest in KASPERMLXRuntimeBundle")
        }

        print("🔍 === END DIAGNOSTIC ===")
    }
}
