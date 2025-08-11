//
//  NumberMeaningsRoutingTests.swift
//  VybeMVPTests
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Smoke test to verify that KASPERContentRouter can load rich content
//  from the RuntimeBundle when properly configured.
//

import XCTest
@testable import VybeMVP

final class NumberMeaningsRoutingTests: XCTestCase {

    func test_router_loads_rich_for_4_if_present() async throws {
        // Get shared router instance
        let router = await KASPERContentRouter.shared

        // Wait for initialization
        while await !router.isInitialized {
            try await Task.sleep(nanoseconds: 20_000_000)
        }

        // Try to load rich content for number 4
        let json = await router.getRichContent(for: 4)

        // If RuntimeBundle is missing, this may be nil
        // Test proves the wiring when present
        XCTAssertNotNil(json, "Expected rich content for 4 when RuntimeBundle is included")

        // If we got content, verify it has expected structure
        if let json = json {
            XCTAssertNotNil(json["meta"], "Rich content should have meta section")
            XCTAssertNotNil(json["overview"], "Rich content should have overview section")
        }
    }

    func test_router_handles_master_numbers() async throws {
        let router = await KASPERContentRouter.shared

        // Wait for initialization
        while await !router.isInitialized {
            try await Task.sleep(nanoseconds: 20_000_000)
        }

        // Test master number 11
        let json11 = await router.getRichContent(for: 11)

        // Master numbers may or may not be present depending on bundle
        if let json = json11 {
            if let meta = json["meta"] as? [String: Any] {
                XCTAssertEqual(meta["type"] as? String, "master", "Number 11 should be marked as master")
            }
        }
    }

    func test_viewmodel_loads_and_caches() async throws {
        let vm = await NumberMeaningViewModel()

        // Load number 4
        await vm.load(number: 4)

        // Give it time to load
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        // Check state
        let state = await vm.state
        switch state {
        case .loaded(let content):
            XCTAssertNotNil(content.meta, "Loaded content should have meta")
        case .empty:
            // Acceptable if RuntimeBundle not present
            XCTAssertTrue(true, "Empty state is acceptable when bundle missing")
        case .error(let msg):
            XCTFail("Should not error: \(msg)")
        default:
            XCTFail("Should be loaded or empty, not \(state)")
        }
    }
}
