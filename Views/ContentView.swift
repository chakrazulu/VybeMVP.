import SwiftUI

struct ContentView: View {
    @StateObject var focusNumberManager = FocusNumberManager()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Current Focus Number Display
                VStack {
                    Text("Current Focus Number")
                        .font(.headline)
                    Text("\(focusNumberManager.currentFocusNumber)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.purple)
                        .frame(width: 120, height: 120)
                        .background(Circle().fill(Color.purple.opacity(0.2)))
                        .shadow(radius: 5)
                }
                
                // Auto-Update Toggle
                Toggle("Auto Update", isOn: $focusNumberManager.isAutoUpdateEnabled)
                    .onChange(of: focusNumberManager.isAutoUpdateEnabled) { oldValue, newValue in
                        if newValue {
                            focusNumberManager.startUpdates()
                        } else {
                            focusNumberManager.stopUpdates()
                        }
                    }
                    .padding(.horizontal)
                
                #if DEBUG
                    Button(action: {
                        focusNumberManager.testLocationPermissions()
                    }) {
                        HStack {
                            Image(systemName: "location.circle.fill")
                            Text("Test Location")
                        }
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(10)
                    }
                #endif
                
                // Navigation Links
                NavigationLink(
                    destination: FocusNumberPicker()
                ) {
                    Text("Choose Your Focus Number")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Match Logs Section
                if !focusNumberManager.matchLogs.isEmpty {
                    Section(header: Text("Recent Matches")) {
                        List(focusNumberManager.matchLogs, id: \.self) { log in
                            Text(log)
                        }
                    }
                }
            }
            .navigationTitle("Focus Number")
            .padding()
        }
        .environmentObject(focusNumberManager)
    }
}
