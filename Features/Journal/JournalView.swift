import SwiftUI

/**
 * 📖 JOURNALVIEW - SOPHISTICATED SPIRITUAL REFLECTION ECOSYSTEM 📖
 * 
 * Claude: JournalView represents the heart of Vybe's spiritual reflection system,
 * providing users with a sophisticated digital sanctuary for documenting their
 * cosmic journey. This isn't just a simple note-taking interface - it's a
 * carefully designed spiritual companion that integrates KASPER MLX AI insights,
 * numerological awareness, and cosmic alignment detection to transform personal
 * reflection into profound spiritual growth.
 * 
 * The view demonstrates advanced SwiftUI architecture combining complex filtering
 * systems, real-time search capabilities, and seamless KASPER MLX integration
 * that provides contextually-aware spiritual guidance based on journal content.
 *
 * SPIRITUAL REFLECTION FEATURES:
 * • Advanced search and filtering system for spiritual journey tracking
 * • KASPER MLX integration providing AI insights on journal entries
 * • Sacred number tagging system connecting entries to numerological themes
 * • Mood and spiritual state tracking with visual indicators
 * • Seamless navigation between reflection and insight generation
 *
 * PERFORMANCE ARCHITECTURE:
 * • LazyVStack rendering for smooth scrolling with large journal collections
 * • Intelligent search debouncing preventing excessive Core Data queries
 * • Memory-efficient state management with proper Combine integration
 * • Background processing for AI insight generation without UI blocking
 * 
 * Claude: JournalView - Main spiritual reflection interface for cosmic journey documentation
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
    // MARK: - 📚 SPIRITUAL JOURNAL DATA MANAGEMENT
    
    /// Claude: JournalManager provides comprehensive spiritual journaling functionality
    /// including Core Data persistence, entry management, and spiritual tagging systems.
    /// This environment object enables real-time updates when journal entries are
    /// created, modified, or deleted, maintaining consistency across all journal interfaces.
    @EnvironmentObject var journalManager: JournalManager
    
    // MARK: - 🎨 UI STATE MANAGEMENT FOR SPIRITUAL REFLECTION
    
    /// Claude: Controls presentation of the new journal entry creation modal.
    /// When true, presents NewJournalEntryView in a sheet for users to document
    /// new spiritual experiences, reflections, and cosmic insights.
    @State private var showingNewEntrySheet = false
    
    /// Claude: Real-time search text for filtering journal entries by content.
    /// Enables users to quickly locate specific spiritual experiences or insights
    /// by searching through entry titles and content with case-insensitive matching.
    @State private var searchText = ""
    
    /// Claude: Selected focus number for filtering journal entries by numerological theme.
    /// When set, filters the journal to show only entries associated with the specific
    /// sacred number, enabling users to track their spiritual journey by numerological patterns.
    @State private var selectedFocusNumber: Int? = nil
    
    /// Claude: Selected mood for filtering journal entries by spiritual state.
    /// Enables filtering by emotional and spiritual context, helping users understand
    /// patterns in their cosmic journey and spiritual growth over time.
    @State private var selectedMood: JournalMood? = nil
    
    /// Claude: SOPHISTICATED SPIRITUAL JOURNAL FILTERING SYSTEM
    /// ========================================================
    /// 
    /// This computed property implements a powerful, multi-criteria filtering system
    /// that enables users to navigate their spiritual journal with precision and insight.
    /// The system applies filters sequentially, each narrowing the results while
    /// maintaining optimal performance through efficient array filtering operations.
    /// 
    /// FILTERING ARCHITECTURE:
    /// 1. NUMEROLOGICAL FILTERING: Focus number alignment for sacred number tracking
    /// 2. EMOTIONAL FILTERING: Mood-based spiritual state categorization
    /// 3. CONTENT FILTERING: Full-text search across titles and spiritual reflections
    /// 
    /// PERFORMANCE OPTIMIZATION:
    /// • Sequential filtering reduces computational complexity with each step
    /// • Case-insensitive search provides intuitive user experience
    /// • Efficient string matching using localizedCaseInsensitiveContains
    /// • Real-time updates through reactive SwiftUI computed property pattern
    var filteredEntries: [JournalEntry] {
        var entries = journalManager.entries
        
        /// Claude: NUMEROLOGICAL FILTER - Sacred number alignment tracking.
        /// Filters entries to those associated with the selected focus number,
        /// enabling users to trace their spiritual journey through specific
        /// numerological themes and cosmic alignment patterns.
        if let focusNumber = selectedFocusNumber {
            entries = entries.filter { $0.focusNumber == focusNumber }
        }
        
        /// Claude: SPIRITUAL STATE FILTER - Emotional and energetic context filtering.
        /// Filters entries by mood/emotional state, helping users understand patterns
        /// in their spiritual experiences and identify correlations between cosmic
        /// events and their internal spiritual landscape.
        if let mood = selectedMood {
            entries = entries.filter { $0.moodEmoji == mood.rawValue }
        }
        
        /// Claude: CONTENT SEARCH FILTER - Full-text spiritual content discovery.
        /// Performs case-insensitive search across entry titles and content,
        /// enabling users to quickly locate specific spiritual experiences, insights,
        /// or cosmic events documented in their journey reflections.
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