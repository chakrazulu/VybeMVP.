//
//  KASPERRuntimeBundleDebug.swift
//  VybeMVP
//
//  Created by Claude on 2025-08-10.
//  Debug utilities for verifying RuntimeBundle integration
//

import Foundation
import os.log

/// Debug utilities for RuntimeBundle verification
class KASPERRuntimeBundleDebug {

    private static let logger = Logger(subsystem: "com.vybe.kasper", category: "RuntimeBundleDebug")

    /// Verify that the RuntimeBundle is accessible from the main bundle
    static func debugRuntimeBundle() {
        logger.info("🔍 KASPER RuntimeBundle Debug Check")

        // Check manifest accessibility
        if let manifestURL = Bundle.main.url(forResource: "manifest", withExtension: "json", subdirectory: "KASPERMLXRuntimeBundle") {
            logger.info("✅ Found manifest at: \(manifestURL.lastPathComponent)")

            // Try to load manifest content
            do {
                let data = try Data(contentsOf: manifestURL)
                let manifest = try JSONDecoder().decode(RuntimeManifest.self, from: data)
                logger.info("   Version: \(manifest.version)")
                logger.info("   Behavioral files: \(manifest.statistics.behavioralFiles)")
                logger.info("   Rich files: \(manifest.statistics.richFiles)")
            } catch {
                logger.error("❌ Failed to parse manifest: \(error.localizedDescription)")
            }
        } else {
            logger.error("❌ Couldn't find manifest in KASPERMLXRuntimeBundle")
        }

        // Check sample rich content
        if let richURL = Bundle.main.url(forResource: "1_rich", withExtension: "json", subdirectory: "KASPERMLXRuntimeBundle/NumberMeanings") {
            logger.info("✅ Found rich content for 1 at: \(richURL.lastPathComponent)")
        } else {
            logger.error("❌ Missing NumberMeanings/1_rich.json")
        }

        // Check sample behavioral content
        if let behavioralURL = Bundle.main.url(forResource: "lifePath_01_v2.0_converted", withExtension: "json", subdirectory: "KASPERMLXRuntimeBundle/Behavioral") {
            logger.info("✅ Found behavioral content for lifePath 1 at: \(behavioralURL.lastPathComponent)")
        } else {
            logger.error("❌ Missing Behavioral/lifePath_01_v2.0_converted.json")
        }

        // Check persona content
        if let personaURL = Bundle.main.url(forResource: "grok_oracle_01_converted", withExtension: "json", subdirectory: "KASPERMLXRuntimeBundle/Behavioral/oracle") {
            logger.info("✅ Found persona content for oracle 1 at: \(personaURL.lastPathComponent)")
        } else {
            logger.error("❌ Missing Behavioral/oracle/grok_oracle_01_converted.json")
        }

        logger.info("🔍 RuntimeBundle Debug Check Complete")
    }

    /// Test the KASPERContentRouter after initialization
    static func debugContentRouter() async {
        logger.info("🔍 KASPER ContentRouter Debug Check")

        let router = await MainActor.run { KASPERContentRouter.shared }

        // Give router time to initialize
        try? await Task.sleep(nanoseconds: 300_000_000) // 300ms

        let diagnostics = await MainActor.run { router.getDiagnostics() }
        logger.info("🔎 Router diagnostics: \(diagnostics)")

        // Test rich content access
        if let richContent = await router.getRichContent(for: 1) {
            logger.info("✅ Successfully loaded rich content for number 1")
            logger.info("   Keys: \(Array(richContent.keys).sorted())")
        } else {
            logger.error("❌ Failed to load rich content for number 1")
        }

        // Test behavioral content access
        if let behavioralContent = await router.getBehavioralInsights(context: "lifePath", number: 1) {
            logger.info("✅ Successfully loaded behavioral content for lifePath 1")
            logger.info("   Keys: \(Array(behavioralContent.keys).sorted())")
        } else {
            logger.error("❌ Failed to load behavioral content for lifePath 1")
        }

        // Test persona content access
        if let personaContent = await router.getBehavioralInsights(context: "lifePath", number: 1, persona: "oracle") {
            logger.info("✅ Successfully loaded persona content for oracle 1")
            logger.info("   Keys: \(Array(personaContent.keys).sorted())")
        } else {
            logger.error("❌ Failed to load persona content for oracle 1")
        }

        logger.info("🔍 ContentRouter Debug Check Complete")
    }

    /// Comprehensive RuntimeBundle validation
    static func validateRuntimeBundle() async {
        logger.info("🧪 KASPER RuntimeBundle Comprehensive Validation")

        debugRuntimeBundle()
        await debugContentRouter()

        logger.info("🎯 Validation Summary:")
        logger.info("   If you see ✅ for manifest, rich content, and behavioral content above,")
        logger.info("   your RuntimeBundle is properly integrated and KASPER v2.1.2 is ready!")
        logger.info("   If you see ❌ errors, check that KASPERMLXRuntimeBundle is added to")
        logger.info("   your Xcode project's Copy Bundle Resources build phase.")
    }
}
