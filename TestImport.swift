import Foundation
import Combine
import HealthKit
import SwiftUI

// Directly import the file
#if canImport(HealthKitManaging)
import HealthKitManaging
#endif

// Test file to check if we can import the HealthKitManaging protocol
func testImport() {
    #if canImport(HealthKitManaging)
    let _: HealthKitManaging? = nil
    print("Successfully imported HealthKitManaging")
    #else
    print("Cannot import HealthKitManaging")
    #endif
} 