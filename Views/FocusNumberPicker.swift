import SwiftUI

struct FocusNumberPicker: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager

    var body: some View {
        VStack {
            Text("Pick Your Focus Number")
                .font(.title)

            Picker("Focus Number", selection: $focusNumberManager.selectedFocusNumber) {
                ForEach(0...9, id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Text("Selected Number: \(focusNumberManager.selectedFocusNumber)")
                .font(.headline)
        }
        .padding()
    }
}
