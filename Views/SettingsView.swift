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
    @State private var showHealthKitError = false
    @State private var errorMessage = ""
    @Environment(\.openURL) var openURL
    
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
                if let heartRate = healthKitManager.currentHeartRate {
                    Text("Current Heart Rate: \(Int(round(heartRate))) BPM")
                        .foregroundColor(.secondary)
                }
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

