import SwiftUI

struct FocusNumberPicker: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Text("Pick Your Focus Number")
                    .font(.title)

                Picker("Focus Number", selection: $focusNumberManager.selectedFocusNumber) {
                    ForEach(1...9, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()

                Text("Selected Number: \(focusNumberManager.selectedFocusNumber)")
                    .font(.headline)

                Button(action: {
                    print("🔢 Saving number: \(focusNumberManager.selectedFocusNumber)")
                    focusNumberManager.userDidPickFocusNumber(focusNumberManager.selectedFocusNumber)
                    dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") { dismiss() })
        }
    }
}
