import SwiftUI

struct MainView: View {
    @EnvironmentObject var focusManager: FocusNumberManager

    var body: some View {
        VStack {
            Text("Main Focus Number: \(focusManager.selectedFocusNumber)")
                .font(.largeTitle)
                .padding()

            // REMOVE: Button is no longer needed as FocusNumberManager updates reactively.
            /*
            Button("Restart Timer") {
                focusManager.startUpdates()
                print("🟢 Timer restarted")
            }
            .padding()
            */
        }
    }
}
