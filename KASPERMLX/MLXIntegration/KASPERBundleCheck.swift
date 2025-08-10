//
//  KASPERBundleCheck.swift
//  VybeMVP
//
//  Quick diagnostic for RuntimeBundle build integration
//

import Foundation

class KASPERBundleCheck {

    static func quickDiagnostic() {
        print("🔍 KASPER Bundle Quick Diagnostic")
        print("==========================================")

        // Check if bundle directory exists
        if let bundlePath = Bundle.main.path(forResource: "KASPERMLXRuntimeBundle", ofType: nil) {
            print("✅ Bundle directory found at: \(bundlePath)")

            // Check specific files
            let manifestPath = bundlePath + "/manifest.json"
            let richContentPath = bundlePath + "/NumberMeanings/1_rich.json"
            let behavioralPath = bundlePath + "/Behavioral/lifePath_01_v2.0_converted.json"

            if FileManager.default.fileExists(atPath: manifestPath) {
                print("✅ manifest.json exists and accessible")

                // Try to read manifest
                if let data = try? Data(contentsOf: URL(fileURLWithPath: manifestPath)),
                   let manifest = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("✅ manifest.json is valid JSON")
                    if let version = manifest["version"] as? String {
                        print("   Version: \(version)")
                    }
                } else {
                    print("❌ manifest.json exists but cannot be parsed")
                }
            } else {
                print("❌ manifest.json not found at expected path")
            }

            if FileManager.default.fileExists(atPath: richContentPath) {
                print("✅ Rich content accessible")
            } else {
                print("❌ Rich content not accessible")
            }

            if FileManager.default.fileExists(atPath: behavioralPath) {
                print("✅ Behavioral content accessible")
            } else {
                print("❌ Behavioral content not accessible")
            }

        } else {
            print("❌ KASPERMLXRuntimeBundle not found in app bundle")
            print("   This means the folder is not in Copy Bundle Resources")
            print("   Add KASPERMLXRuntimeBundle to Build Phases > Copy Bundle Resources")
        }

        print("==========================================")
    }
}
