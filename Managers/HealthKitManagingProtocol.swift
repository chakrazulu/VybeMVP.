/**
 * Filename: HealthKitManagingProtocol.swift
 *
 * Purpose: Defines the interface for HealthKit interactions, enabling
 * dependency injection and testability for heart rate monitoring.
 *
 * Key responsibilities:
 * - Define the contract for HealthKit operations
 * - Enable mocking for unit tests
 * - Provide a consistent interface for heart rate data access
 * - Support authorization and monitoring operations
 *
 * This protocol is implemented by both the real HealthKitManager and
 * mock implementations used in testing, ensuring consistent behavior
 * across production and test environments.
 */

import Foundation
import Combine
import HealthKit
import SwiftUI

/**
 * Protocol defining the interface for HealthKit management.
 *
 * This protocol abstracts the HealthKit interactions, allowing for:
 * - Dependency injection in components that need heart rate data
 * - Mocking in unit tests to avoid actual HealthKit dependencies
 * - Consistent access to heart rate information across the app
 *
 * Conforming types must handle authorization, monitoring, and data
 * retrieval from HealthKit or provide suitable test alternatives.
 */
public protocol HealthKitManaging: ObservableObject {
    /// The current heart rate value in beats per minute (BPM)
    var currentHeartRate: Int { get }

    /// The most recent valid (non-zero) heart rate reading in BPM
    var lastValidBPM: Int { get }

    /// Current authorization status for HealthKit heart rate access
    var authorizationStatus: HKAuthorizationStatus { get }

    /// Indicates whether the user needs to manually enable HealthKit in Settings
    var needsSettingsAccess: Bool { get }

    /**
     * Requests authorization to access heart rate data from HealthKit.
     *
     * This asynchronous method should:
     * 1. Request user permission via system dialog
     * 2. Update the authorization status based on user's choice
     * 3. Throw an error if authorization fails
     */
    func requestAuthorization() async throws

    /**
     * Begins monitoring heart rate data from HealthKit.
     *
     * This method should set up the necessary observers and queries
     * to continuously monitor heart rate changes.
     */
    func startHeartRateMonitoring()

    /**
     * Explicitly requests an immediate heart rate update.
     *
     * This method should trigger a manual fetch of the latest
     * heart rate data outside of the regular update cycle.
     */
    func forceHeartRateUpdate() async

    /**
     * Retrieves the initial heart rate reading when monitoring begins.
     *
     * This method should fetch the most recent heart rate data
     * to establish a baseline when the app starts.
     */
    func fetchInitialHeartRate() async

    /**
     * Stops monitoring heart rate data from HealthKit.
     *
     * This method should clean up any active observers or queries
     * to prevent unnecessary background activity.
     */
    func stopHeartRateMonitoring()
}
