import SwiftUI

struct FocusNumberPicker: View {
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    @Environment(\.dismiss) var dismiss
    
    private let spacing: CGFloat = 16
    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 16)
    ]
    private let numbers = FocusNumberManager.validFocusNumbers
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(numbers, id: \.self) { number in
                        NumberButton(
                            number: number,
                            isSelected: number == focusNumberManager.selectedFocusNumber
                        ) {
                            focusNumberManager.userDidPickFocusNumber(number)
                            dismiss()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Focus Number")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// Separate component for better layout control
private struct NumberButton: View {
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Spacer(minLength: 0)
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.2))
                    
                    Text("\(number)")
                        .font(.title2.bold())
                        .foregroundColor(isSelected ? .white : .primary)
                        .minimumScaleFactor(0.5)
                }
                Spacer(minLength: 0)
            }
            .frame(idealWidth: 80, idealHeight: 80)
            .frame(minWidth: 44, minHeight: 44)
        }
        .accessibilityLabel("Focus number \(number)")
    }
}

// Preview provider for testing
struct NumberButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            NumberButton(number: 1, isSelected: true) {}
            NumberButton(number: 2, isSelected: false) {}
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

struct FocusNumberPicker_Previews: PreviewProvider {
    static var previews: some View {
        FocusNumberPicker()
            .environmentObject(FocusNumberManager.shared)
    }
}
