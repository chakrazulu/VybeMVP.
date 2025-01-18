import SwiftUI

struct MainView: View {
    @StateObject private var focusManager = FocusNumberManager()
    @State private var isPickerPresented = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Your Focus Number")
                .font(.headline)
            
            // Auto-Updating Focus Number
            VStack {
                Text("\(focusManager.currentFocusNumber)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                Text(Date(), style: .time)
                    .font(.caption)
            }
            .foregroundColor(.purple)
            .padding()
            .background(Circle().fill(Color.purple.opacity(0.2)))
            .shadow(radius: 10)
            .onChange(of: focusManager.currentFocusNumber) { oldValue, newValue in
                print("\n🔄 UI UPDATE")
                print("----------------------------------------")
                print("Focus Number Changed in UI: \(oldValue) → \(newValue)")
                print("----------------------------------------\n")
            }

            // Buttons
            HStack(spacing: 20) {
                Button(action: {
                    focusManager.enableAutoFocusNumber()
                }) {
                    Text("Restart Timer")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isPickerPresented = true
                }) {
                    Text("Choose Number")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            // Debug Logs
            List(focusManager.matchLogs, id: \.self) { log in
                Text(log)
            }
            .frame(height: 150)
        }
        .padding()
        .sheet(isPresented: $isPickerPresented) {
            FocusNumberPicker(selectedFocusNumber: .init(
                get: { focusManager.userFocusNumber },
                set: { focusManager.userDidPickFocusNumber($0) }
            ))
        }
        .onAppear {
            print("\n📱 MAIN VIEW APPEARED")
            print("----------------------------------------")
            focusManager.checkTimerStatus()
            focusManager.startUpdates()
            print("View setup complete")
            print("----------------------------------------\n")
        }
        .onDisappear {
            focusManager.stopUpdates()
        }
    }
}
