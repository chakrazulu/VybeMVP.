// IMPORTANT: This file must be included in both the main app target and test target
// Target Membership: VybeMVP, VybeMVPTests

import Foundation
import Combine
import HealthKit
import SwiftUI

/// Protocol defining the interface for health kit management
public protocol HealthKitManaging: ObservableObject {
    /// The current heart rate value
    var currentHeartRate: Int { get }
    
    /// The last valid heart rate measured
    var lastValidBPM: Int { get }
    
    /// The authorization status for HealthKit
    var authorizationStatus: HKAuthorizationStatus { get }
    
    /// Indicates whether the user needs to enable settings access
    var needsSettingsAccess: Bool { get }
    
    /// Requests authorization from HealthKit
    func requestAuthorization() async throws
    
    /// Starts monitoring heart rate data
    func startHeartRateMonitoring()
    
    /// Forces an update of heart rate data
    /// Returns: A Boolean indicating whether the heart rate update was successful
    func forceHeartRateUpdate() async -> Bool
    
    /// Fetches the initial heart rate data
    /// Returns: A Boolean indicating whether the initial heart rate retrieval was successful
    func fetchInitialHeartRate() async -> Bool
    
    /// Stops monitoring heart rate data
    func stopHeartRateMonitoring()
} 