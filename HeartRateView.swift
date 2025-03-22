import SwiftUI

struct HeartRateView: View {
    @StateObject private var healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            heartRateDisplay
            refreshButton
        }
    }

    private var heartRateDisplay: some View {
        VStack(spacing: 5) {
            Text("Current Heart Rate")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Show BPM value or placeholder based on data availability
            Text("\(hasValidHeartRate ? "\(healthKitManager.lastValidBPM)" : "--")")
                .font(.system(size: 70, weight: .bold))
                .foregroundColor(hasValidHeartRate ? .primary : .secondary)
            
            Text("BPM")
                .font(.subheadline)
                .foregroundColor(.secondary)
                
            // Add data freshness indicator
            if hasValidHeartRate {
                HStack(spacing: 5) {
                    Image(systemName: healthKitManager.isHeartRateSimulated ? 
                          "exclamationmark.triangle" : "checkmark.circle")
                        .foregroundColor(healthKitManager.isHeartRateSimulated ? .orange : .green)
                    
                    Text(healthKitManager.isHeartRateSimulated ? 
                         "Simulated Data" : "Real Data")
                        .font(.caption)
                        .foregroundColor(healthKitManager.isHeartRateSimulated ? .orange : .green)
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }

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

    private func refreshHeartRate() {
        // Implementation of refreshHeartRate function
    }

    private var hasValidHeartRate: Bool {
        // Implementation of hasValidHeartRate function
        return false
    }
}

struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
} 