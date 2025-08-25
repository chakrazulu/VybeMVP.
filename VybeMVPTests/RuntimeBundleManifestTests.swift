// Tests/RuntimeBundleManifestTests.swift
import XCTest
@testable import VybeMVP

final class RuntimeBundleManifestTests: XCTestCase {
    func testManifestDecode() throws {
        let manifest = try ManifestLoader.load()
        XCTAssertGreaterThan(manifest.essential.count, 0)
        XCTAssertEqual(manifest.version, 1)
    }

    func testPickerDedup() throws {
        let m = RuntimeBundleManifest(version: 1, essential: ["A.json"], near_term: [], on_demand: [])
        let files = EssentialPicker.files(for: m, user: RuntimeUserProfile(lifePathNumber: 7, soulUrgeNumber: 3, focusNumber: 1))
        XCTAssertEqual(Set(files).count, files.count) // No duplicates
        XCTAssertGreaterThan(files.count, 1) // Should have base + user files
    }
}
