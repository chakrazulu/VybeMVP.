import SwiftUI

struct FocusNumberContent: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @State private var showingPicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Current Focus Number Display
                VStack {
                    Text("Your Focus Number")
                        .font(.title)
                        .padding()
                    
                    Text("\(focusNumberManager.selectedFocusNumber)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.purple)
                        .frame(width: 120, height: 120)
                        .background(Circle().fill(Color.purple.opacity(0.2)))
                        .shadow(radius: 5)
                }
                
                // Auto-Update Toggle
                Toggle("Auto Update", isOn: $focusNumberManager.isAutoUpdateEnabled)
                    .padding()
                    .onChange(of: focusNumberManager.isAutoUpdateEnabled) { _, newValue in
                        if newValue {
                            focusNumberManager.startUpdates()
                        } else {
                            focusNumberManager.stopUpdates()
                        }
                    }
                
                // Match Logs Section
                if !focusNumberManager.matchLogs.isEmpty {
                    Section(header: Text("Recent Matches")) {
                        List(focusNumberManager.matchLogs, id: \.timestamp) { match in
                            VStack(alignment: .leading) {
                                Text("Match! Number \(match.matchedNumber)")
                                    .font(.headline)
                                Text(match.timestamp, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Vybe")
            .toolbar {
                Button("Change Number") {
                    showingPicker = true
                }
            }
            .sheet(isPresented: $showingPicker) {
                FocusNumberPicker()
            }
        }
    }
} 