import Foundation
import os.log

// typealias SystemLogger = OSLog.Logger // Commented out

/**
 * Extends Logger to provide predefined logger instances for different
 * subsystems or categories within the VybeMVP application.
 *
 * This helps in organizing log messages and allows for easier filtering and
 * analysis during development and debugging.
 *
 * Usage:
 * Logger.app.info("Application has launched.")
 * Logger.network.error("Failed to fetch data: \(error.localizedDescription)")
 * Logger.ui.debug("User tapped the settings button.")
 */
extension Logger {
    /// The subsystem identifier for all logs originating from VybeMVP.
    /// Uses the app's bundle identifier for uniqueness.
    private static let loggerSubsystem: String = Bundle.main.bundleIdentifier ?? "com.infinitiesinn.VybeMVP" // Fallback

    /// Logger for general application-level events and lifecycle.
    static let app = Logger(subsystem: loggerSubsystem, category: "ApplicationLifecycle")

    /// Logger for network requests, responses, and related errors (e.g., Firestore operations).
    static let network = Logger(subsystem: loggerSubsystem, category: "NetworkOperations")

    /// Logger for UI interactions, view lifecycle events, and user interface state changes.
    static let ui = Logger(subsystem: loggerSubsystem, category: "UserInterface")

    /// Logger for data management operations, including local caching, CoreData, and data transformations.
    static let data = Logger(subsystem: loggerSubsystem, category: "DataManagement")

    /// Logger for numerology specific calculations, data loading, and services.
    static let numerology = Logger(subsystem: loggerSubsystem, category: "Numerology")

    /// Logger for AI Insight generation, template matching, and related processes.
    static let ai = Logger(subsystem: loggerSubsystem, category: "AIInsightEngine")

    /// Logger for general service-level operations not covered by more specific categories.
    static let services = Logger(subsystem: loggerSubsystem, category: "AppServices")

    /// Logger for focus number operations, matching, and related processes.
    static let focus = Logger(subsystem: loggerSubsystem, category: "FocusNumber")

    /// Logger for location-based operations and geofencing.
    static let location = Logger(subsystem: loggerSubsystem, category: "LocationServices")

    // You can add more specific categories as needed, for example:
    // static let healthKit = Logger(subsystem: loggerSubsystem, category: "HealthKit")
    // static let onboarding = Logger(subsystem: loggerSubsystem, category: "Onboarding")
}
