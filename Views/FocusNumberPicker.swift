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

// Preview provider for testing
struct FocusNumberPicker_Previews: PreviewProvider {
    static var previews: some View {
        FocusNumberPicker()
            .environmentObject(FocusNumberManager.shared)
    }
}
