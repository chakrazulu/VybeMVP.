import SwiftUI

struct HeartRateView: View {
    @ObservedObject private var healthKitManager = HealthKitManager.shared
    @State private var isLoading = true
    @State private var showingNoDataAlert = false
    
    private let gradientColors = [
        Color.blue.opacity(0.5),
        Color.purple.opacity(0.7),
        Color.red.opacity(0.8)
    ]
    
    var body: some View {
        VStack(spacing: 25) {
            // Heart Rate Display
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 8
                    )
                    .frame(width: 150, height: 150)
                
                VStack(spacing: 5) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else {
                        Text("\(Int(healthKitManager.currentHeartRate ?? 0))")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("BPM")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: healthKitManager.currentHeartRate)
            
            // Status and Controls
            if healthKitManager.authorizationStatus == .sharingAuthorized {
                VStack(spacing: 15) {
                    // Status Indicator
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.green)
                        Text(isLoading ? "Fetching..." : "Monitoring")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Refresh Button
                    Button(action: {
                        isLoading = true
                        Task {
                            await healthKitManager.fetchInitialHeartRate()
                            // Reset loading state after 3 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isLoading = false
                                if healthKitManager.currentHeartRate == nil {
                                    showingNoDataAlert = true
                                }
                            }
                        }
                    }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 5)
                }
                .padding(.bottom, 20)
            } else {
                // Not Authorized State
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "heart.slash.fill")
                            .foregroundColor(.red)
                        Text(statusText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if healthKitManager.needsSettingsAccess {
                        Button(action: {
                            healthKitManager.openHealthAppSettings()
                        }) {
                            Text("Open Health Settings")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            Spacer(minLength: 40)  // Add more space before time picker
        }
        .padding()
        .alert("No Heart Rate Data", isPresented: $showingNoDataAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Make sure your Apple Watch is connected and measuring heart rate.")
        }
        .onAppear {
            Task {
                await healthKitManager.fetchInitialHeartRate()
                // Reset loading state after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoading = false
                    if healthKitManager.currentHeartRate == nil {
                        showingNoDataAlert = true
                    }
                }
            }
        }
        // Add timer to update heart rate every minute
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            Task {
                await healthKitManager.fetchInitialHeartRate()
            }
        }
    }
    
    private var statusText: String {
        switch healthKitManager.authorizationStatus {
        case .sharingAuthorized:
            return "Monitoring"
        case .sharingDenied:
            return "Access Denied"
        case .notDetermined:
            return "Not Authorized"
        @unknown default:
            return "Unknown Status"
        }
    }
}

#Preview {
    HeartRateView()
} 