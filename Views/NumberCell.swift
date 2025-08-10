/*
 * ========================================
 * 🔢 NUMBER CELL - FOCUS NUMBER SELECTION COMPONENT
 * ========================================
 *
 * CORE PURPOSE:
 * Reusable cell component for displaying and selecting focus numbers (0-9).
 * Used in number pickers and selection interfaces throughout the app.
 * Provides visual feedback for selection state and optional descriptions.
 *
 * COMPONENT LAYOUT:
 * • Container: 80×80pt frame for consistent spacing
 * • Circle: 60×60pt circular background with selection styling
 * • Content: VStack with number and optional description
 * • Number: Title2 font, bold, with selection color adaptation
 * • Description: Caption font, secondary color, optional display
 *
 * VISUAL STATES:
 * • Selected: Blue background, white text, white description
 * • Unselected: Gray background (20% opacity), primary text, secondary description
 * • Description: Optional subtitle text below the number
 *
 * STYLING:
 * • Circle background with selection-based color
 * • Fixed size constraints for consistent layout
 * • Color adaptation based on selection state
 * • Proper text sizing and spacing
 *
 * USAGE PATTERNS:
 * • Focus number selection interfaces
 * • Number picker grids and lists
 * • Selection state visualization
 * • Consistent number display across app
 *
 * INTEGRATION POINTS:
 * • FocusNumberPicker: Primary usage for number selection
 * • Number selection grids: Grid layouts for multiple numbers
 * • Selection interfaces: Any view requiring number selection
 * • Consistent styling: Maintains app-wide number cell appearance
 */

import SwiftUI

/**
 * NumberCell: Reusable component for focus number display and selection
 *
 * Provides a consistent, visually appealing way to display numbers
 * with selection state feedback and optional descriptive text.
 */
struct NumberCell: View {
    let number: Int
    let isSelected: Bool
    var description: String?

    var body: some View {
        VStack {
            // MARK: - Main Circle Container
            ZStack {
                Circle()
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)

                // MARK: - Content Stack
                VStack(spacing: 4) {
                    // MARK: - Number Display
                    Text("\(number)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(isSelected ? .white : .primary)
                        .fixedSize(horizontal: true, vertical: true)

                    // MARK: - Optional Description
                    if let description = description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(isSelected ? .white : .secondary)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
            }
            .frame(width: 60, height: 60)
        }
        .frame(width: 80, height: 80)
    }
}

#Preview {
    HStack {
        NumberCell(number: 0, isSelected: true, description: "Void")
        NumberCell(number: 1, isSelected: false)
        NumberCell(number: 2, isSelected: true)
    }
    .padding()
}
