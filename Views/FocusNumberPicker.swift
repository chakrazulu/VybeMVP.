/**
 * Filename: FocusNumberPicker.swift
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === MODAL PRESENTATION ===
 * • Sheet style: Standard iOS modal (full screen on compact devices)
 * • Navigation bar: Inline title display mode
 * • Title: "Choose Focus Number" - standard navigation font
 * • Done button: Navigation bar trailing, system blue
 *
 * === GRID LAYOUT ===
 * • Grid type: LazyVGrid with adaptive columns
 * • Column minimum: 80pt width
 * • Grid spacing: 16pts between items (horizontal and vertical)
 * • Container padding: Standard system padding (~20pts)
 * • Scroll behavior: Vertical ScrollView
 *
 * === NUMBER BUTTONS (via NumberButton component) ===
 * • Button size: Minimum 80×80pt (adaptive to screen)
 * • Number font: See NumberButton.swift for specifications
 * • Selected state: Visual indicator (color/border change)
 * • Tap target: Full button area (80×80pt minimum)
 * • Animation: Selection state change animation
 *
 * === INTERACTION FLOW ===
 * 1. User taps number → Immediate selection
 * 2. FocusNumberManager updated
 * 3. Sheet auto-dismisses
 * 4. Alternative: "Done" button dismisses without change
 *
 * === RESPONSIVE BEHAVIOR ===
 * • iPhone SE: 3 columns (106pt each)
 * • iPhone 14: 4 columns (90pt each)
 * • iPhone 14 Pro Max: 4 columns (95pt each)
 * • iPad: 6+ columns based on width
 *
 * === COLOR SYSTEM ===
 * • Background: System background (adaptive)
 * • Selected number: Accent color or custom highlight
 * • Unselected: Secondary system color
 * • Done button: System blue (default)
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
    
    /// 🎯 GRID SPACING: 16pts between all items (horizontal and vertical)
    private let spacing: CGFloat = 16
    
    /// 📐 GRID CONFIGURATION: Adaptive columns with 80pt minimum width
    private let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 16) // Creates 3-4 columns on iPhone
    ]
    
    /// 🔢 NUMBER SET: Always 1-9 from FocusNumberManager
    private let numbers = FocusNumberManager.validFocusNumbers
    
    var body: some View {
        NavigationView { // 📱 MODAL WRAPPER: Required for navigation bar
            ScrollView { // 📜 SCROLLABLE CONTAINER: Vertical scrolling if needed
                LazyVGrid(columns: columns, spacing: spacing) { // 🎯 RESPONSIVE GRID: 80pt min cells
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
