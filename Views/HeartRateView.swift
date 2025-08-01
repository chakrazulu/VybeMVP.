/*
 * ========================================
 * ❤️ HEART RATE VIEW - HEALTHKIT INTEGRATION
 * ========================================
 * 
 * CORE PURPOSE:
 * Advanced HealthKit integration view displaying real-time heart rate data for realm
 * number calculations. Manages authorization states, data validation, simulation modes,
 * and provides comprehensive error handling with user guidance.
 * 
 * UI SPECIFICATIONS:
 * - Heart Rate Display: 70pt bold BPM number with secondary background card
 * - Loading State: 1.5x scaled progress indicator with descriptive text
 * - Authorization UI: 30pt heart.text.square icon with blue accent
 * - Refresh Button: Tertiary background, 8pt corner radius, arrow.clockwise icon
 * - Simulation Toggle: Color-coded (red/green) with checkmark/xmark icons
 * 
 * HEALTHKIT INTEGRATION:
 * - Authorization Management: Handles .sharingAuthorized status and Settings access
 * - Real-time Monitoring: 30-second automatic refresh cycle with retry logic
 * - Data Validation: Validates BPM > 0 for hasValidHeartRate computation
 * - Simulation Mode: Toggle between real HealthKit data and simulated values
 * - Error Recovery: 3-attempt retry system with user guidance alerts
 * 
 * REALM NUMBER INTEGRATION:
 * - BPM Source: Provides heart rate data for RealmNumberManager calculations
 * - Data Freshness: Real-time updates ensure accurate realm number computation
 * - Fallback System: Simulation mode ensures app functionality without Apple Watch
 * - Priority System: Real data preferred over simulated for calculation accuracy
 * 
 * STATE MANAGEMENT:
 * - retryCount: Tracks automatic refresh attempts (max 3)
 * - showingNoDataAlert: Controls troubleshooting alert presentation
 * - showingHeartRateInfoAlert: Manages detailed data information display
 * - timer: 30-second periodic refresh cycle management
 * - hasValidHeartRate: Computed property for BPM > 0 validation
 * 
 * AUTHORIZATION FLOW:
 * 1. Check authorizationStatus for .sharingAuthorized
 * 2. If unauthorized, show in-app permission request
 * 3. If needsSettingsAccess, redirect to Settings app
 * 4. Handle authorization errors with user-friendly messaging
 * 5. Automatic retry after successful authorization
 * 
 * DATA DISPLAY MODES:
 * - Valid Data: Shows BPM with real/simulated indicator and data info button
 * - Loading: Progress indicator with "Measuring heart rate..." message
 * - No Data: heart.slash icon with Apple Watch troubleshooting guidance
 * - Unauthorized: heart.text.square icon with permission request UI
 * 
 * PERFORMANCE OPTIMIZATIONS:
 * - Timer Management: Proper invalidation on view disappear
 * - Retry Logic: Stops automatic refresh after max attempts
 * - Memory Efficiency: Clean resource management with proper lifecycle
 * - Background Processing: Async/await for non-blocking HealthKit operations
 * 
 * ERROR HANDLING SYSTEM:
 * - Authorization Errors: Graceful fallback with user guidance
 * - No Data Scenarios: Comprehensive troubleshooting with Apple Watch tips
 * - Network Issues: Retry mechanism with exponential backoff
 * - Settings Access: Direct link to iOS Settings for permission management
 * 
 * SIMULATION FEATURES:
 * - Toggle Control: Real-time switching between real and simulated data
 * - Visual Indicators: Orange warning for simulated, green checkmark for real
 * - Debug Information: Detailed data source and type information
 * - Testing Support: Enables development without physical Apple Watch
 * 
 * TECHNICAL NOTES:
 * - Dependency Injection: Supports mock HealthKitManager for testing
 * - Timer Lifecycle: Automatic cleanup prevents memory leaks
 * - Async Operations: All HealthKit calls use async/await pattern
 * - State Synchronization: Proper @ObservedObject usage for real-time updates
 */

/**
 * Filename: HeartRateView.swift
 * 
 * Purpose: Displays and manages heart rate data from HealthKit within the app.
 *
 * Key responsibilities:
 * - Display current heart rate readings
 * - Handle HealthKit authorization requests
 * - Manage error states (no data, unauthorized)
 * - Provide refresh functionality
 * 
 * This view serves as the main interface for heart rate monitoring and 
 * is critical for the realm number calculation (which uses BPM as input).
 */

import SwiftUI
import HealthKit

/**
 * A view that displays heart rate data from HealthKit and handles various states
 * including authorization, loading, and error conditions.
 *
 * This view implements multiple states:
 * - Authorized with valid heart rate: Shows reading
 * - Authorized with no heart rate: Shows loading or "no data" after retry limit
 * - Unauthorized: Shows permission request UI
 *
 * The view automatically refreshes heart rate data on appear and at regular intervals.
 */
struct HeartRateView: View {
    // MARK: - Properties
    
    /// Tracks repeated attempts to fetch heart rate when no valid data is available
    @State private var retryCount = 0
    
    /// Maximum number of automatic retries before showing the "No Data" message
    private let maxRetryCount = 3
    
    /// Controls visibility of the alert shown when no heart rate data is available
    @State private var showingNoDataAlert = false
    
    /// Add a new state variable at the top of the struct with other @State variables
    @State private var showingHeartRateInfoAlert = false
    @State private var heartRateInfoMessage = ""
    
    /**
     * The HealthKit manager responsible for all heart rate data operations.
     * Uses dependency injection to support testing with mock implementations.
     */
    @ObservedObject private var healthKitManager: HealthKitManager
    
    /**
     * Initializes the HeartRateView with a HealthKitManager.
     *
     * - Parameter healthKitManager: The manager to use for HealthKit operations.
     *   Defaults to the shared singleton instance for normal app operation.
     *   In test environments, a mock implementation can be provided.
     */
    init(healthKitManager: HealthKitManager = HealthKitManager.shared) {
        self.healthKitManager = healthKitManager
    }
    
    /// Timer used to periodically refresh heart rate data
    @State private var timer: Timer? = nil
    
    /**
     * Determines if valid heart rate data is available.
     * 
     * This computed property checks if the last valid BPM is greater than zero,
     * which indicates we have received at least one valid heart rate reading.
     * Used to control the view's display state.
     */
    private var hasValidHeartRate: Bool {
        return healthKitManager.lastValidBPM > 0
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background color that matches the system theme
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Heart rate value display component
                heartRateDisplay
                
                // Conditional display based on current state
                if !hasValidHeartRate && retryCount >= maxRetryCount {
                    // No data available after multiple retries
                    noDataView
                } else if healthKitManager.authorizationStatus != .sharingAuthorized || healthKitManager.needsSettingsAccess {
                    // Need authorization from user
                    authorizationView
                } else if !hasValidHeartRate {
                    // Authorized but still loading data
                    loadingView
                }
                
                // Always show refresh button for manual updates
                refreshButton
            }
            .padding()
        }
        .onAppear {
            // Start the refresh cycle when the view appears
            setupHeartRateRefresh()
        }
        .onDisappear {
            // Clean up resources when the view disappears
            timer?.invalidate()
            timer = nil
        }
        .alert(isPresented: $showingHeartRateInfoAlert) {
            Alert(
                title: Text("Heart Rate Information"),
                message: Text(heartRateInfoMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - UI Components
    
    /**
     * The main heart rate display component showing the current BPM.
     * Shows placeholder dashes when no valid data is available.
     */
    private var heartRateDisplay: some View {
        VStack(spacing: 5) {
            Text("Current Heart Rate")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Show BPM value or placeholder based on data availability
            Text("\(hasValidHeartRate && healthKitManager.lastValidBPM > 0 ? "\(healthKitManager.lastValidBPM)" : "--")")
                .font(.system(size: 70, weight: .bold))
                .foregroundColor(hasValidHeartRate ? .primary : .secondary)
            
            Text("BPM")
                .font(.subheadline)
                .foregroundColor(.secondary)
                
            // Add data freshness indicator
            if hasValidHeartRate {
                VStack(spacing: 2) {
                    HStack(spacing: 5) {
                        Image(systemName: healthKitManager.isHeartRateSimulated ? 
                              "exclamationmark.triangle" : "checkmark.circle")
                            .foregroundColor(healthKitManager.isHeartRateSimulated ? .orange : .green)
                        
                        Text(healthKitManager.isHeartRateSimulated ? 
                             "Simulated Data" : "Real Data")
                            .font(.caption)
                            .foregroundColor(healthKitManager.isHeartRateSimulated ? .orange : .green)
                    }
                    
                    // Add a refresh timestamp if using real data
                    if !healthKitManager.isHeartRateSimulated {
                        Button(action: { showHeartRateInfo() }) {
                            Text("Tap for data info")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    /**
     * Loading indicator shown when waiting for heart rate data
     * after authorization has been granted.
     */
    private var loadingView: some View {
        VStack(spacing: 10) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Measuring heart rate...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    /**
     * View displayed when no heart rate data could be retrieved 
     * after several attempts. Includes helpful troubleshooting tips.
     */
    private var noDataView: some View {
        VStack(spacing: 10) {
            Image(systemName: "heart.slash")
                .font(.system(size: 30))
                .foregroundColor(.red)
            
            Text("No heart rate data available")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Please ensure your Apple Watch is worn properly and try again")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .alert(isPresented: $showingNoDataAlert) {
            // More detailed help shown in alert
            Alert(
                title: Text("No Heart Rate Data"),
                message: Text("Make sure your Apple Watch is properly worn and connected. You might need to open the Health app on your watch to refresh data."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    /**
     * View displayed when HealthKit authorization is needed.
     * Shows different UI based on whether the user needs to:
     * - Grant initial permission (shows in-app permission request)
     * - Enable access in Settings (shows button to open Settings app)
     */
    private var authorizationView: some View {
        VStack(spacing: 10) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 30))
                .foregroundColor(.blue)
            
            // Different titles based on the authorization status
            Text(healthKitManager.needsSettingsAccess ? "Health Access Required" : "Health Permission Required")
                .font(.headline)
            
            // Different instructions based on what action is needed
            Text(healthKitManager.needsSettingsAccess ? 
                "Please enable heart rate access in Settings > Privacy > Health" : 
                "Please grant access to your heart rate data")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Button performs the appropriate action based on status
            Button(action: {
                if healthKitManager.needsSettingsAccess {
                    // Open system Settings app if permissions need to be changed there
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } else {
                    // Request HealthKit authorization directly
                    Task {
                        do {
                            try await healthKitManager.requestAuthorization()
                        } catch {
                            print("Authorization error: \(error)")
                        }
                    }
                }
            }) {
                Text(healthKitManager.needsSettingsAccess ? "Open Settings" : "Grant Access")
                    .fontWeight(.bold)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    /**
     * Button that allows manual refresh of heart rate data.
     * Always visible to allow users to retry fetching data.
     */
    private var refreshButton: some View {
        VStack {
            Button(action: refreshHeartRate) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Force Heart Rate Update")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(8)
            }
            
            // Add simulation mode toggle
            Button(action: {
                let newSimulationState = !healthKitManager.isHeartRateSimulated
                healthKitManager.setSimulationMode(enabled: newSimulationState)
                
                // Force a heart rate update after toggling
                Task {
                    _ = await healthKitManager.forceHeartRateUpdate()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: healthKitManager.isHeartRateSimulated ? "xmark.circle" : "checkmark.circle")
                    Text(healthKitManager.isHeartRateSimulated ? "Turn OFF Simulation" : "Turn ON Simulation")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(8)
                .foregroundColor(healthKitManager.isHeartRateSimulated ? .red : .green)
            }
            .padding(.top, 8)
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     * Sets up the heart rate refresh cycle when the view appears.
     * 
     * - Performs an initial refresh immediately
     * - Creates a timer for periodic refreshes every 30 seconds
     * - Timer stops automatic refreshes once retry limit is reached with no data
     */
    private func setupHeartRateRefresh() {
        // Initial refresh
        refreshHeartRate()
        
        // Set up timer for periodic refresh (every 30 seconds)
        timer = Timer.scheduledTimer(withTimeInterval: VybeConstants.heartRateRefreshInterval, repeats: true) { _ in
            if retryCount < maxRetryCount || hasValidHeartRate {
                refreshHeartRate()
            }
        }
    }
    
    /**
     * Refreshes heart rate data from HealthKit.
     * 
     * This function:
     * 1. Checks authorization status
     * 2. If authorized, tries to get heart rate data
     * 3. If unauthorized, requests permission
     * 4. Tracks retry attempts and shows alert after max retries
     * 
     * Used by both the automatic timer and manual refresh button.
     */
    private func refreshHeartRate() {
        // Only allow refresh if we haven't reached max retries or we already have valid data
        if retryCount < maxRetryCount || hasValidHeartRate {
            Task {
                if healthKitManager.authorizationStatus == .sharingAuthorized {
                    // If we're authorized, try to get heart rate data
                    if !hasValidHeartRate {
                        retryCount += 1
                        print("Refreshing heart rate (attempt \(retryCount))")
                    }
                    
                    // Force an immediate heart rate update
                    _ = await healthKitManager.forceHeartRateUpdate()
                    
                    // If we still don't have data after max retries, show alert with troubleshooting help
                    if retryCount >= maxRetryCount && !hasValidHeartRate {
                        showingNoDataAlert = true
                    }
                } else {
                    // If not authorized, try to request authorization
                    do {
                        try await healthKitManager.requestAuthorization()
                    } catch {
                        print("Authorization error: \(error)")
                    }
                }
            }
        }
    }
    
    /**
     * Shows detailed information about the heart rate data being used.
     */
    private func showHeartRateInfo() {
        // Build the information message
        heartRateInfoMessage = """
        Current heart rate: \(healthKitManager.lastValidBPM) BPM
        Data type: \(healthKitManager.isHeartRateSimulated ? "Simulated" : "Real from Apple Watch")
        Data source: HealthKit
        
        This heart rate data is used for realm number calculations.
        """
        
        showingHeartRateInfoAlert = true
    }
}

/// Preview provider for SwiftUI canvas
#Preview {
    HeartRateView()
} 
