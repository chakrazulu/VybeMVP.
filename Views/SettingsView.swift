//
//  SettingsView.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//
import SwiftUI
import HealthKit
import SafariServices

struct SettingsView: View {
    @EnvironmentObject private var healthKitManager: HealthKitManager
    @EnvironmentObject private var realmNumberManager: RealmNumberManager
    @State private var showHealthKitError = false
    @State private var errorMessage = ""
    @Environment(\.openURL) var openURL
    
    // Add these state variables for feedback
    @State private var showSilentUpdateConfirmation = false
    @State private var showManualCalculationConfirmation = false
    @State private var lastRealmNumber = 0
    
    var body: some View {
        List {
            // HealthKit Section
            Section(header: Text("HEALTH DATA")) {
                // Status Row
                HStack {
                    Text("Heart Rate Access")
                    Spacer()
                    authorizationStatusView
                }
                
                // Detailed Status
                let sortedTypes = Array(healthKitManager.authorizationStatuses.keys)
                    .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
                
                ForEach(sortedTypes, id: \.self) { type in
                    if let status = healthKitManager.authorizationStatuses[type] {
                        HStack {
                            Text(type.components(separatedBy: "HKQuantityTypeIdentifier").last ?? type)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                            statusIcon(for: status)
                        }
                    }
                }
                
                // Request Access Button Row
                if healthKitManager.authorizationStatus != .sharingAuthorized {
                    Button {
                        Task {
                            await requestHealthKitAccess()
                        }
                    } label: {
                        Text(healthKitManager.authorizationStatus == .notDetermined ? "Request Access" : "Try Again")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Settings Button Row
                if healthKitManager.authorizationStatus == .sharingDenied {
                    Button {
                        openSettings()
                    } label: {
                        Text("Open Health Settings")
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Heart Rate Display Row
                Text("Current Heart Rate: \(healthKitManager.currentHeartRate) BPM")
                    .foregroundColor(.secondary)
            }
            
            // Testing Section
            Section(header: Text("TESTING")) {
                NavigationLink(destination: TestingView()) {
                    Label("Match Testing", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            
            // App Info Section
            Section(header: Text("APP INFO")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundColor(.secondary)
                }
            }
            
            // Background Updates Testing Section
            backgroundTestingSection
            
            // Developer options section (only available in DEBUG builds)
            #if DEBUG
            Section(header: Text("Developer Tools")) {
                NavigationLink(destination: NumerologyNotificationTestView()) {
                    HStack {
                        Image(systemName: "bell.badge")
                            .foregroundColor(.blue)
                        Text("Numerology Notification Tester")
                    }
                }
            }
            #endif
        }
        .navigationTitle("Settings")
        .alert("HealthKit Error", isPresented: $showHealthKitError) {
            if healthKitManager.authorizationStatus == .sharingDenied {
                Button("Open Settings") {
                    openSettings()
                }
            }
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func openSettings() {
        // Try to open Health app settings directly
        if let healthURL = URL(string: "x-apple-health://") {
            openURL(healthURL) { success in
                // If opening Health app fails, fall back to app settings
                if !success {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        openURL(settingsURL)
                    }
                }
            }
        }
    }
    
    private var authorizationStatusView: some View {
        Group {
            switch healthKitManager.authorizationStatus {
            case .sharingAuthorized:
                Label("Connected", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
            case .sharingDenied:
                Label("Access Denied", systemImage: "xmark.circle.fill")
                    .foregroundColor(.red)
            case .notDetermined:
                Label("Not Set Up", systemImage: "exclamationmark.circle.fill")
                    .foregroundColor(.orange)
            @unknown default:
                Label("Unknown", systemImage: "questionmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private func requestHealthKitAccess() async {
        do {
            try await HealthKitManager.shared.requestAuthorization()
        } catch {
            let errorMessage: String
            if let healthError = error as? HealthKitError {
                errorMessage = healthError.errorDescription ?? "Unknown error"
            } else {
                errorMessage = "To use heart rate features, please allow access to Health data when prompted.\n\nIf you accidentally denied access, you can:\n1. Try requesting access again\n2. Or enable access in Settings → Health"
            }
            
            await MainActor.run {
                self.showHealthKitError = true
                self.errorMessage = errorMessage
            }
        }
    }
    
    private func statusIcon(for status: HKAuthorizationStatus) -> some View {
        switch status {
        case .sharingAuthorized:
            return Label("Authorized", systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .sharingDenied:
            return Label("Denied", systemImage: "xmark.circle.fill")
                .foregroundColor(.red)
        case .notDetermined:
            return Label("Not Set", systemImage: "questionmark.circle.fill")
                .foregroundColor(.orange)
        @unknown default:
            return Label("Unknown", systemImage: "exclamationmark.circle.fill")
                .foregroundColor(.gray)
        }
    }
    
    // Background Updates Testing Section
    private var backgroundTestingSection: some View {
        Section(header: Text("Background Updates Testing")) {
            Toggle("Use Simulated Heart Rate", isOn: Binding(
                get: { healthKitManager.isHeartRateSimulated },
                set: { healthKitManager.setSimulationMode(enabled: $0) }
            ))
            .foregroundColor(.blue)
            
            Button("Schedule Silent Background Update") {
                NotificationManager.shared.scheduleSilentBackgroundUpdate()
                showSilentUpdateConfirmation = true
            }
            .foregroundColor(.blue)
            
            Button("Perform Manual Realm Calculation") {
                // Store current realm number to show change
                lastRealmNumber = realmNumberManager.currentRealmNumber
                // Force an immediate calculation
                realmNumberManager.calculateRealmNumber()
                showManualCalculationConfirmation = true
            }
            .foregroundColor(.blue)
            
            Button("Force Heart Rate Update") {
                Task {
                    await healthKitManager.forceHeartRateUpdate()
                }
            }
            .foregroundColor(.blue)
            
            Button("Generate Simulated Heart Rate") {
                // Use the public method instead of reflection
                healthKitManager.simulateHeartRateForDevelopment()
            }
            .foregroundColor(.blue)
            
            if realmNumberManager.currentRealmNumber > 0 {
                Text("Current Realm Number: \(realmNumberManager.currentRealmNumber)")
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            
            if healthKitManager.currentHeartRate > 0 {
                Text("Current Heart Rate: \(healthKitManager.currentHeartRate) BPM")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
                
                if healthKitManager.isHeartRateSimulated {
                    Text("(Simulated Heart Rate)")
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text("(Real Heart Rate from HealthKit)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Text("Use these options to test background calculations. Toggle simulation mode to switch between real and simulated heart rate data. The silent update simulates a push notification that would wake the app to perform calculations in the background.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .alert("Silent Update Scheduled", isPresented: $showSilentUpdateConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("A silent background update has been scheduled. The app will perform calculations in the background shortly.")
        }
        .alert("Realm Calculation Performed", isPresented: $showManualCalculationConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            let message = lastRealmNumber != realmNumberManager.currentRealmNumber ? 
                "Realm number changed from \(lastRealmNumber) to \(realmNumberManager.currentRealmNumber)" :
                "Realm number calculation completed (stayed at \(realmNumberManager.currentRealmNumber))"
            return Text(message)
        }
    }
}

// Helper view for opening URLs in a sheet
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(HealthKitManager.shared)
            .environmentObject(FocusNumberManager.shared)
            .environmentObject(RealmNumberManager())
    }
}

