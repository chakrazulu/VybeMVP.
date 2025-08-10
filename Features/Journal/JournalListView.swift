/*
 * ========================================
 * 📚 JOURNAL LIST VIEW - JOURNAL ENTRIES LIST
 * ========================================
 *
 * CORE PURPOSE:
 * Displays a list of all journal entries with navigation to detail views
 * and creation of new entries. Provides the main journal browsing interface
 * with search, filtering, and entry management capabilities.
 *
 * SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points):
 * • NavigationView: Standard iOS navigation with "Journal" title
 * • List: InsetGrouped style for journal entries
 * • NavigationLink: Each entry links to detail view
 * • Toolbar: "New Entry" button with pencil icon
 * • Sheet: Modal presentation for new entry creation
 *
 * UI COMPONENTS:
 * • List: Scrollable list of journal entries
 * • JournalEntryView: Individual entry display component
 * • NavigationLink: Navigation to entry detail
 * • Toolbar Button: New entry creation trigger
 * • Modal Sheet: NewJournalEntryView presentation
 *
 * DATA FLOW:
 * • JournalManager: Environment object for data access
 * • JournalEntryView: Displays individual entry metadata
 * • JournalEntryDetailView: Destination for entry details
 * • NewJournalEntryView: Modal for entry creation
 *
 * INTERACTIONS:
 * • Tap entry: Navigate to detail view
 * • Tap "+" button: Open new entry modal
 * • Swipe actions: Delete entries (handled by JournalManager)
 * • Search: Built-in list search functionality
 *
 * INTEGRATION POINTS:
 * • JournalManager: Primary data source and state management
 * • JournalEntryView: Entry display component
 * • JournalEntryDetailView: Entry detail interface
 * • NewJournalEntryView: Entry creation interface
 * • Navigation system: Standard iOS navigation patterns
 */

import SwiftUI

/**
 * JournalListView: Main journal browsing and management interface
 *
 * Provides a comprehensive list view of journal entries with
 * navigation, creation, and management capabilities.
 */
struct JournalListView: View {
    @EnvironmentObject var journalManager: JournalManager
    @State private var showingNewEntry = false

    var body: some View {
        // MARK: - Journal Entries List
        List {
            ForEach(journalManager.entries) { entry in
                NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
                    JournalEntryView(entry: entry)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Journal")
        .toolbar {
            // MARK: - New Entry Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingNewEntry = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        // MARK: - New Entry Modal
        .sheet(isPresented: $showingNewEntry) {
            NavigationView {
                NewJournalEntryView()
            }
        }
    }
}
