/*
 * ========================================
 * 📝 JOURNALENTRYVIEW - SOPHISTICATED SPIRITUAL REFLECTION DISPLAY COMPONENT
 * ========================================
 *
 * Claude: JournalEntryView represents a carefully crafted list item component that
 * distills the essence of spiritual journal entries into an elegant, informative
 * interface element. This isn't just a simple row view - it's a micro-interface
 * that communicates the spiritual significance of each journal entry through
 * thoughtful typography, numerological awareness, and emotional context visualization.
 *
 * The component demonstrates advanced SwiftUI layout techniques combining flexible
 * content areas with fixed metadata displays, creating visual hierarchy that
 * guides users through their spiritual journey timeline with clarity and beauty.
 *
 * SPIRITUAL INTERFACE DESIGN:
 * • Sacred number integration with visual prominence for numerological tracking
 * • Emotional state visualization through mood indicators and contextual icons
 * • Temporal awareness through elegant timestamp formatting and visual hierarchy
 * • Content accessibility enabling quick recognition of spiritual themes and growth
 * • Tappable interface providing seamless navigation to detailed spiritual reflection
 *
 * CORE PURPOSE:
 * Displays a single spiritual journal entry in a sophisticated list format with title,
 * timestamp, sacred focus number, and spiritual mood information. Used throughout
 * journal interfaces and search results to provide comprehensive entry overviews.
 *
 * COMPONENT LAYOUT:
 * • HStack: Main container with leading content and trailing metadata
 * • Leading VStack: Title and timestamp with layout priority
 * • Trailing VStack: Focus number and mood with system icons
 * • Spacer: Forces metadata to trailing edge
 * • Content Shape: Makes entire row tappable
 *
 * DISPLAYED INFORMATION:
 * • Title: Entry title with headline font and line limit
 * • Timestamp: Date display with caption font and secondary color
 * • Focus Number: Number with circle icon and accent color
 * • Mood: Optional mood display with smiling face icon
 *
 * STYLING:
 * • HStack with 12pt spacing for content separation
 * • VStack with 8pt spacing for content grouping
 * • Padding: 8pt vertical, 4pt horizontal
 * • System icons for visual context
 * • Color-coded information hierarchy
 *
 * DATA HANDLING:
 * • Focus number validation: Ensures range 1-9
 * • Optional content handling: Graceful display of missing data
 * • Timestamp formatting: System date style
 * • Mood display: Conditional based on availability
 *
 * INTEGRATION POINTS:
 * • JournalListView: Primary usage in journal lists
 * • Search results: Used in filtered journal displays
 * • Navigation: Links to JournalEntryDetailView
 * • JournalManager: Data source for entry information
 *
 * ACCESSIBILITY:
 * • Content shape for full row tap target
 * • Clear visual hierarchy with fonts and colors
 * • System icons for context and recognition
 */

import SwiftUI

/**
 * JournalEntryView: Compact display component for journal entries
 *
 * Provides a standardized way to display journal entry metadata
 * in lists and search results with clear visual hierarchy.
 */
struct JournalEntryView: View {
    let entry: JournalEntry

    // MARK: - Computed Properties

    /// Validated focus number ensuring range 1-9
    private var focusNumber: Int {
        max(1, min(Int(entry.focusNumber), 9))  // Ensure valid range
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 12) {  // Changed to HStack for better layout
            // MARK: - Leading Content (Title & Timestamp)
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title ?? "")
                    .font(.headline)
                    .lineLimit(1)

                if let timestamp = entry.timestamp {
                    Text(timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .layoutPriority(1)  // Give title priority

            Spacer()  // Force metadata to trailing edge

            // MARK: - Trailing Metadata (Focus Number & Mood)
            VStack(alignment: .trailing, spacing: 8) {
                // MARK: - Focus Number Display
                Label("Focus: \(focusNumber)",
                      systemImage: "number.circle.fill")
                    .foregroundColor(.accentColor)

                // MARK: - Optional Mood Display
                if let mood = entry.mood, !mood.isEmpty {
                    Label(mood, systemImage: "face.smiling")
                        .foregroundColor(.secondary)
                }
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())  // Make entire row tappable
    }
}
