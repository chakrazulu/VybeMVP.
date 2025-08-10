/*
 * ========================================
 * ❤️ HEALTHKIT PERMISSION VIEW - HEALTH DATA ACCESS
 * ========================================
 *
 * CORE PURPOSE:
 * Manages HealthKit permission requests and provides user guidance for
 * enabling heart rate access. Handles both initial permission requests
 * and settings access when permissions are denied.
 *
 * SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points):
 * • VStack: Main content container with 20pt spacing
 * • Conditional Views: SettingsAccessView or RequestPermissionView
 * • Alert System: Error handling and settings navigation
 * • Task-based Authorization: Automatic permission requests
 *
 * UI COMPONENTS:
 * • SettingsAccessView: Detailed instructions for Health app access
 * • RequestPermissionView: Initial permission request interface
 * • Alert System: Error handling with multiple action options
 * • System Icons: Heart rate related SF Symbols
 *
 * PERMISSION FLOW:
 * 1. Initial Request: Attempts automatic HealthKit authorization
 * 2. Success: Proceeds to main app functionality
 * 3. Failure: Shows settings access view with detailed instructions
 * 4. Error Handling: Alert with options to open Health app or Settings
 *
 * INTEGRATION POINTS:
 * • HealthKitManager: Primary HealthKit interaction and authorization
 * • Health app: External app for permission management
 * • Settings app: System settings for app permissions
 * • Main app flow: Blocks progression until permissions granted
 *
 * ERROR HANDLING:
 * • HealthKitError: Specific error types and descriptions
 * • Settings Alert: Multiple action options for resolution
 * • Graceful Degradation: Clear instructions for manual setup
 *
 * PRIVACY & SECURITY:
 * • Clear explanation of data usage
 * • Privacy assurance messaging
 * • Secure HealthKit integration
 * • User control over data access
 */

import SwiftUI
import HealthKit

/**
 * HealthKitPermissionView: Manages HealthKit permission requests and user guidance
 *
 * Provides a comprehensive interface for requesting and managing HealthKit
 * permissions, with detailed instructions for manual setup when needed.
 */
struct HealthKitPermissionView: View {
    @StateObject private var healthKitManager = HealthKitManager.shared
    @State private var showingSettingsAlert = false
    @State private var currentError: HealthKitError?

    var body: some View {
        VStack(spacing: 20) {
            if healthKitManager.needsSettingsAccess {
                SettingsAccessView()
            } else {
                RequestPermissionView()
            }
        }
        .alert("HealthKit Access Required", isPresented: $showingSettingsAlert, presenting: currentError) { error in
            Button("Open Health App") {
                healthKitManager.openHealthAppSettings()
            }
            Button("Open Settings") {
                healthKitManager.openAppSettings()
            }
            Button("Cancel", role: .cancel) {}
        } message: { error in
            Text(error.localizedDescription)
        }
        .task {
            do {
                try await healthKitManager.requestAuthorization()
            } catch let error as HealthKitError {
                currentError = error
                showingSettingsAlert = true
            } catch {
                print("Unexpected error: \(error.localizedDescription)")
            }
        }
    }
}

/**
 * SettingsAccessView: Detailed instructions for manual Health app access
 *
 * Displays comprehensive step-by-step instructions for enabling
 * heart rate access through the Health app when automatic
 * permission requests fail.
 */
struct SettingsAccessView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)

            Text("Heart Rate Access Required")
                .font(.title2)
                .fontWeight(.bold)

            Text("Please enable heart rate access in the Health app settings to use all features of VybeMVP.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                Text("To enable access:")
                    .fontWeight(.medium)

                VStack(alignment: .leading, spacing: 4) {
                    Text("1. Open the Health app")
                    Text("2. Tap 'Browse' at the bottom")
                    Text("3. Search for 'Heart Rate'")
                    Text("4. Scroll to 'Data Sources & Access'")
                    Text("5. Find and tap VybeMVP")
                    Text("6. Enable all heart rate permissions")
                }
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)

            Button(action: {
                HealthKitManager.shared.openHealthAppSettings()
            }) {
                Text("Open Health App")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

/**
 * RequestPermissionView: Initial HealthKit permission request interface
 *
 * Displays the initial permission request with explanation of
 * data usage and privacy assurances for heart rate access.
 */
struct RequestPermissionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)

            Text("Heart Rate Access")
                .font(.title2)
                .fontWeight(.bold)

            Text("VybeMVP needs access to your heart rate data to provide real-time monitoring and insights for your focus and well-being.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Text("Your data is kept private and secure.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    HealthKitPermissionView()
}
