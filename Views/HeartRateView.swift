import SwiftUI
import HealthKit

struct HeartRateView: View {
    // Keep track of retry attempts to avoid infinite refresh
    @State private var retryCount = 0
    private let maxRetryCount = 3
    @State private var showingNoDataAlert = false
    
    // Use concrete type with dependency injection for testability
    @ObservedObject private var healthKitManager: HealthKitManager
    
    // Initialize with dependency injection
    init(healthKitManager: HealthKitManager = HealthKitManager.shared) {
        self.healthKitManager = healthKitManager
    }
    
    // Timer for periodic refresh
    @State private var timer: Timer? = nil
    
    // Computed property to check if we have valid heart rate data
    private var hasValidHeartRate: Bool {
        return healthKitManager.lastValidBPM > 0
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                heartRateDisplay
                
                if !hasValidHeartRate && retryCount >= maxRetryCount {
                    // Show "No Data Available" button
                    noDataView
                } else if healthKitManager.authorizationStatus != .sharingAuthorized || healthKitManager.needsSettingsAccess {
                    // Show authorization button
                    authorizationView
                } else if !hasValidHeartRate {
                    // Show loading indicator
                    loadingView
                }
                
                // Always show refresh button
                refreshButton
            }
            .padding()
        }
        .onAppear {
            setupHeartRateRefresh()
        }
        .onDisappear {
            // Clean up timer when view disappears
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - Component Views
    
    private var heartRateDisplay: some View {
        VStack(spacing: 5) {
            Text("Current Heart Rate")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("\(hasValidHeartRate ? "\(healthKitManager.lastValidBPM)" : "--")")
                .font(.system(size: 70, weight: .bold))
                .foregroundColor(hasValidHeartRate ? .primary : .secondary)
            
            Text("BPM")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
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
            Alert(
                title: Text("No Heart Rate Data"),
                message: Text("Make sure your Apple Watch is properly worn and connected. You might need to open the Health app on your watch to refresh data."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private var authorizationView: some View {
        VStack(spacing: 10) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 30))
                .foregroundColor(.blue)
            
            Text(healthKitManager.needsSettingsAccess ? "Health Access Required" : "Health Permission Required")
                .font(.headline)
            
            Text(healthKitManager.needsSettingsAccess ? 
                "Please enable heart rate access in Settings > Privacy > Health" : 
                "Please grant access to your heart rate data")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                if healthKitManager.needsSettingsAccess {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } else {
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
    
    private var refreshButton: some View {
        Button(action: refreshHeartRate) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                Text("Refresh")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color(UIColor.tertiarySystemBackground))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Functions
    
    private func setupHeartRateRefresh() {
        // Initial refresh
        refreshHeartRate()
        
        // Set up timer for periodic refresh (every 30 seconds)
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            if retryCount < maxRetryCount || hasValidHeartRate {
                refreshHeartRate()
            }
        }
    }
    
    private func refreshHeartRate() {
        // Only allow refresh if we haven't reached max retries
        if retryCount < maxRetryCount || hasValidHeartRate {
            Task {
                if healthKitManager.authorizationStatus == .sharingAuthorized {
                    // If we're authorized, try to get heart rate data
                    if !hasValidHeartRate {
                        retryCount += 1
                        print("Refreshing heart rate (attempt \(retryCount))")
                    }
                    
                    await healthKitManager.forceHeartRateUpdate()
                    
                    // If we still don't have data after max retries, show alert
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
}

#Preview {
    HeartRateView()
} 