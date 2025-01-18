import SwiftUI
import AuthenticationServices

struct ContentView: View {
    @StateObject private var focusManager = FocusNumberManager()
    @State private var isSignedIn = false
    @State private var showPicker = false
    
    var body: some View {
        NavigationView {
            if isSignedIn {
                VStack {
                    Text("Welcome to Vybe!")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Your Focus Number: \(focusManager.userFocusNumber)")
                        .font(.title2)
                        .padding()
                    
                    Button(action: {
                        showPicker = true
                    }) {
                        Text("Choose Your Focus Number")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showPicker) {
                        FocusNumberPicker(selectedFocusNumber: .init(
                            get: { focusManager.userFocusNumber },
                            set: { focusManager.userDidPickFocusNumber($0) }
                        ))
                    }
                }
                .navigationTitle("Vybe")
                .onAppear {
                    focusManager.enableAutoFocusNumber()
                }
            } else {
                SignInView(isSignedIn: $isSignedIn)
            }
        }
    }
}
