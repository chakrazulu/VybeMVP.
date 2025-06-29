import SwiftUI

/**
 * JournalView: Main journal interface for spiritual reflection and documentation
 * 
 * 🎯 PIXEL-PERFECT UI REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 * 
 * === CORE PURPOSE ===
 * Primary journaling interface where users document their spiritual journey.
 * Combines personal reflection with numerological tracking and cosmic insights.
 * 
 * === SCREEN LAYOUT (iPhone 14 Pro Max: 430×932 points) ===
 * • NavigationView: Standard iOS navigation
 * • Title: "Journal" - navigation title style
 * • Background: Full screen CosmicBackgroundView
 * • List: Scrollable journal entries
 * • Search: Built-in searchable interface
 * 
 * === TOOLBAR COMPONENTS ===
 * • New Entry button: Top-right, text style
 * • Filter menu: Top-left, SF Symbol line.3.horizontal.decrease.circle
 * • Both buttons use standard iOS toolbar styling
 * 
 * === FILTERING SYSTEM ===
 * • Search text: Title and content full-text search
 * • Focus number: Filter by specific number (1-9)
 * • Mood filter: Filter by emoji mood selection
 * • Combined filters: Multiple criteria supported
 * 
 * === JOURNAL ENTRY ROW ===
 * • Layout: VStack with 4pt spacing
 * • Title: Headline font, "Untitled" if empty
 * • Focus number: Subheadline font
 * • Timestamp: Caption font, gray color, date style
 * • Navigation: Links to JournalEntryDetailView
 * 
 * === LIST STYLING ===
 * • Background: Clear (shows cosmic background)
 * • Row background: Clear/transparent
 * • Scroll content background: Hidden
 * • Delete gesture: Swipe to delete entries
 * 
 * === FILTER MENU STRUCTURE ===
 * Menu "Filter" {
 *   - "All Entries" (clears filters)
 *   - "By Focus Number" submenu (1-9)
 *   - "By Mood" submenu (emoji moods)
 * }
 * 
 * === FOCUS NUMBER SUBMENU ===
 * • Range: 1-9 (FocusNumberManager.validFocusNumbers)
 * • Selection: Single number filter
 * • Checkmark: Shows current selection
 * • Clears mood filter when selected
 * 
 * === MOOD SUBMENU ===
 * • Options: All JournalMood.allCases
 * • Display: Emoji + description text
 * • Selection: Single mood filter
 * • Checkmark: Shows current selection
 * • Clears focus number filter when selected
 * 
 * === STATE MANAGEMENT ===
 * • journalManager: JournalManager environment object
 * • showingNewEntrySheet: Boolean for modal presentation
 * • searchText: String for search functionality
 * • selectedFocusNumber: Optional Int for filtering
 * • selectedMood: Optional JournalMood for filtering
 * 
 * === SHEET PRESENTATIONS ===
 * • New Entry: NewJournalEntryView modal
 * • Entry Detail: NavigationLink to JournalEntryDetailView
 * 
 * === FILTERING LOGIC ===
 * 1. Start with all journalManager.entries
 * 2. Apply focus number filter if selected
 * 3. Apply mood filter if selected
 * 4. Apply search text filter (case insensitive)
 * 5. Return filtered array
 * 
 * === DATA REFRESH ===
 * • onAppear: Calls journalManager.loadEntries()
 * • Ensures fresh data when view appears
 * • Handles Core Data updates automatically
 * 
 * === DELETION HANDLING ===
 * • Swipe gesture: iOS standard delete behavior
 * • Calls: journalManager.deleteEntry() for each
 * • Immediate UI update via environment object
 * 
 * === SEARCH FUNCTIONALITY ===
 * • Prompt: "Search journals..."
 * • Searches: Entry title and content fields
 * • Case insensitive matching
 * • Real-time filtering as user types
 * 
 * === CRITICAL NOTES ===
 * • Clear backgrounds show cosmic animation
 * • All filtering is non-destructive
 * • Multiple filter types are exclusive
 * • Environment object ensures data consistency
 */
struct JournalView: View {
    @EnvironmentObject var journalManager: JournalManager
    @State private var showingNewEntrySheet = false
    @State private var searchText = ""
    @State private var selectedFocusNumber: Int? = nil
    @State private var selectedMood: JournalMood? = nil
    
    var filteredEntries: [JournalEntry] {
        var entries = journalManager.entries
        
        // Apply focus number filter
        if let focusNumber = selectedFocusNumber {
            entries = entries.filter { $0.focusNumber == focusNumber }
        }
        
        // Apply mood filter
        if let mood = selectedMood {
            entries = entries.filter { $0.moodEmoji == mood.rawValue }
        }
        
        // Apply search text filter
        if !searchText.isEmpty {
            entries = entries.filter { entry in
                (entry.title ?? "").localizedCaseInsensitiveContains(searchText) ||
                (entry.content ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return entries
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                CosmicBackgroundView()
                    .ignoresSafeArea()
                
                journalListView
            }
        }
    }
    
    @ViewBuilder
    private var journalListView: some View {
        List {
            ForEach(filteredEntries, id: \.id) { entry in
                journalEntryRow(for: entry)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    journalManager.deleteEntry(filteredEntries[index])
                }
            }
            .listRowBackground(Color.clear)
        }
        .searchable(text: $searchText, prompt: "Search journals...")
        .navigationTitle("Journal")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("New Entry") {
                    showingNewEntrySheet = true
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                filterMenu
            }
        }
        .sheet(isPresented: $showingNewEntrySheet) {
            NewJournalEntryView()
        }
        .background(Color.clear)
        .scrollContentBackground(.hidden)
        .onAppear {
            // Refresh entries when the view appears
            journalManager.loadEntries()
        }
    }
    
    @ViewBuilder
    private func journalEntryRow(for entry: JournalEntry) -> some View {
        NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title ?? "Untitled")
                    .font(.headline)
                
                Text("Focus Number: \(entry.focusNumber)")
                    .font(.subheadline)
                
                if let timestamp = entry.timestamp {
                    Text(timestamp, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    var filterMenu: some View {
        Menu {
            Button("All Entries") {
                selectedFocusNumber = nil
                selectedMood = nil
            }
            
            focusNumberMenu
            
            moodMenu
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
    
    @ViewBuilder
    private var focusNumberMenu: some View {
        Menu("By Focus Number") {
            ForEach(FocusNumberManager.validFocusNumbers, id: \.self) { number in
                Button(action: {
                    selectedFocusNumber = number
                    selectedMood = nil
                }) {
                    HStack {
                        Text("\(number)")
                        if selectedFocusNumber == number {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var moodMenu: some View {
        Menu("By Mood") {
            ForEach(JournalMood.allCases, id: \.self) { mood in
                Button(action: {
                    selectedMood = mood
                    selectedFocusNumber = nil
                }) {
                    HStack {
                        Text(mood.rawValue)
                        Text(mood.description)
                            .foregroundColor(.secondary)
                        if selectedMood == mood {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
} 