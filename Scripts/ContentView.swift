import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var focusManager = FocusNumberManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Current Focus Number: \(focusManager.currentFocusNumber)")
                .font(.title)
            
            Text("Selected Focus Number: \(focusManager.selectedFocusNumber)")
                .font(.title2)
            
            // Location Test Button
            Button(action: {
                focusManager.testLocationPermissions()
            }) {
                Text("Test Location")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Start/Stop Updates Button
            Button(action: {
                if focusManager.isAutoUpdateEnabled {
                    focusManager.stopUpdates()
                } else {
                    focusManager.startUpdates()
                }
            }) {
                Text(focusManager.isAutoUpdateEnabled ? "Stop Updates" : "Start Updates")
                    .padding()
                    .background(focusManager.isAutoUpdateEnabled ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Show location status if available
            if let location = focusManager.lastKnownLocation {
                Text("Last Location:")
                Text("Lat: \(location.coordinate.latitude)")
                Text("Long: \(location.coordinate.longitude)")
            } else {
                Text("No Location Available")
                    .foregroundColor(.red)
            }
            
            // Show any match logs
            ScrollView {
                ForEach(focusManager.matchLogs, id: \.self) { log in
                    Text(log)
                        .padding(.vertical, 2)
                }
            }
        }
        .padding()
    }
} 