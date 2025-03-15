/**
 * Filename: FocusNumberPicker.swift
 * 
 * Purpose: Provides a grid-based interface for users to select their focus number.
 * This view is typically presented as a modal sheet when the user wants to change
 * their currently selected focus number.
 *
 * Design pattern: Composable SwiftUI view with reusable button component
 * Dependencies: FocusNumberManager for data management
 */

import SwiftUI

/**
 * A grid-based picker interface allowing users to select a focus number (1-9).
 *
 * This view presents a grid of selectable numbers and handles the user interaction
 * by updating the FocusNumberManager when a new selection is made.
 *
 * Key features:
 * 1. Displays numbers 1-9 in a responsive grid layout
 * 2. Visually indicates the currently selected number
 * 3. Updates the FocusNumberManager when a new selection is made
 * 4. Provides a "Done" button to dismiss the modal
 */
struct FocusNumberPicker: View {
    /// Access to the focus number manager for reading/updating the selected number
    @EnvironmentObject var focusNumberManager: FocusNumberManager
    
    /// Environment property to dismiss the sheet when selection is complete
    @Environment(\.dismiss) var dismiss
    
    /// Spacing between grid items
    private let spacing: CGFloat = 16
    
    /// Grid layout configuration
    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 16)
    ]
    
    /// Valid focus numbers (1-9) retrieved from the FocusNumberManager
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

/**
 * A reusable button component for displaying selectable focus numbers.
 *
 * This component is responsible for:
 * 1. Rendering an individual number in the picker grid
 * 2. Indicating the selected state through visual styling
 * 3. Triggering the provided action when tapped
 * 4. Maintaining accessibility support
 */
private struct NumberButton: View {
    /// The number value to display
    let number: Int
    
    /// Whether this number is currently selected
    let isSelected: Bool
    
    /// Closure to execute when the button is tapped
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
