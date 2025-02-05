import SwiftUI
import HealthKit

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