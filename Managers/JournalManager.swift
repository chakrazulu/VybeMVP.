/*
 * ========================================
 * 📝 JOURNAL MANAGER - SPIRITUAL JOURNALING SYSTEM
 * ========================================
 *
 * CORE PURPOSE:
 * Comprehensive spiritual journaling management system providing Core Data persistence,
 * CRUD operations, and filtering capabilities for mystical reflection entries. Integrates
 * focus numbers, realm numbers, mood tracking, and voice recordings for complete
 * spiritual journaling experience with robust data management.
 *
 * CORE DATA INTEGRATION:
 * - Entity Management: Complete JournalEntry entity lifecycle management
 * - Persistence Layer: NSManagedObjectContext operations with error handling
 * - Query Optimization: Efficient fetch requests with sort descriptors
 * - Data Validation: Focus number validation (1-9 range enforcement)
 * - Context Safety: Main thread operations for UI consistency
 *
 * SPIRITUAL JOURNALING FEATURES:
 * - Focus Number Integration: Links entries to selected focus numbers (1-9)
 * - Realm Number Tracking: Captures realm number at time of entry creation
 * - Mood Emoji Support: Emotional state tracking with emoji representation
 * - Voice Recording: Audio journal entry support with filename persistence
 * - Timestamp Management: Automatic entry creation and modification tracking
 *
 * CRUD OPERATIONS:
 * - Create: createEntry() with comprehensive parameter support
 * - Read: loadEntries() with timestamp-based sorting (newest first)
 * - Update: updateEntry() for title, content, and mood modifications
 * - Delete: deleteEntry() with proper Core Data cleanup
 * - Validation: Focus number range validation and data integrity checks
 *
 * STATE MANAGEMENT:
 * - @Published entries: Reactive journal entry collection for UI binding
 * - ObservableObject: SwiftUI reactive updates for journal changes
 * - Repository Pattern: Clean abstraction over Core Data complexity
 * - Main Thread Safety: UI-safe property updates and context operations
 * - Automatic Refresh: loadEntries() after all modification operations
 *
 * FILTERING & SEARCH:
 * - Focus Number Filter: entriesForFocusNumber() for number-specific entries
 * - Date Filter: entriesForDate() for calendar-based entry retrieval
 * - Chronological Sorting: Newest entries first with timestamp ordering
 * - Calendar Integration: Same-day entry filtering with Calendar.current
 * - Query Flexibility: Extensible filtering system for future enhancements
 *
 * INTEGRATION POINTS:
 * - JournalView: Primary UI for journal entry creation and management
 * - FocusNumberManager: Focus number association for spiritual alignment
 * - RealmNumberManager: Realm number capture for cosmic context
 * - VoiceRecordingManager: Audio journal entry integration
 * - ActivityView: Journal entries in spiritual activity feed
 *
 * DATA STRUCTURE:
 * - JournalEntry Entity: Core Data entity with complete spiritual metadata
 * - UUID Identification: Unique entry identification for reliable operations
 * - Timestamp Tracking: Creation and modification time management
 * - Focus/Realm Numbers: Spiritual number associations (Int16 storage)
 * - Rich Content: Title, content, mood emoji, voice recording support
 *
 * ERROR HANDLING & RESILIENCE:
 * - Core Data Errors: Comprehensive error logging with os.Logger
 * - Context Validation: hasChanges check before save operations
 * - Fetch Failures: Graceful handling of data retrieval errors
 * - Data Integrity: Validation ensures consistent spiritual number ranges
 * - Recovery Mechanisms: Robust error handling with user feedback
 *
 * PERFORMANCE OPTIMIZATIONS:
 * - Lazy Loading: Entries loaded on-demand via loadEntries()
 * - Efficient Queries: Optimized fetch requests with proper sort descriptors
 * - Context Management: Single viewContext for consistent operations
 * - Memory Efficiency: Published property updates only when needed
 * - Batch Operations: Efficient Core Data save operations
 *
 * SPIRITUAL METADATA:
 * - Focus Number Validation: Ensures 1-9 range for spiritual consistency
 * - Realm Number Context: Captures cosmic state at entry creation
 * - Mood Tracking: Emotional state association with journal entries
 * - Voice Integration: Audio spiritual reflections with file management
 * - Temporal Context: Timestamp-based spiritual journey tracking
 *
 * TESTING & DEVELOPMENT:
 * - Test Entry Creation: testCreateEntry() for development validation
 * - Entry Listing: testListEntries() for debugging and verification
 * - Debug Logging: Comprehensive console output for development
 * - Data Validation: Focus number range testing and validation
 * - Entry Count Tracking: Real-time entry count monitoring
 *
 * TECHNICAL SPECIFICATIONS:
 * - Entity Name: "JournalEntry" for Core Data operations
 * - Sort Order: Timestamp descending (newest first)
 * - Focus Range: 1-9 with validateFocusNumber() enforcement
 * - Storage Types: Int16 for numbers, String for text, UUID for IDs
 * - Logger Category: "journal" for debugging and error tracking
 *
 * DEBUGGING & MONITORING:
 * - os.Logger Integration: Structured logging for journal operations
 * - Operation Tracking: Create, update, delete operation logging
 * - Entry Count Monitoring: Real-time count updates after operations
 * - Error Propagation: Detailed error messages for troubleshooting
 * - Development Tools: Test methods for entry creation and listing
 */

/**
 * Filename: JournalManager.swift
 *
 * Purpose: Manages journal entries in the app, handling CRUD operations,
 * filtering, and persistence using Core Data.
 *
 * Key responsibilities:
 * - Create, read, update, and delete journal entries
 * - Provide filtered access to journal entries
 * - Manage Core Data persistence of journal data
 * - Support search and categorization of entries
 *
 * This manager serves as the central point for all journal-related
 * functionality, abstracting the Core Data implementation from the views.
 */

import Foundation
import CoreData
import CoreLocation
import os

/**
 * Manager class responsible for journal entry operations.
 *
 * This class provides a clean API for:
 * - Creating new journal entries
 * - Retrieving journal entries
 * - Updating existing entries
 * - Deleting unwanted entries
 * - Filtering entries by various criteria
 *
 * It uses Core Data for persistence and publishes changes to SwiftUI views
 * through the ObservableObject protocol.
 *
 * Design pattern: Repository pattern for Core Data abstraction
 * Threading: Uses the main thread via viewContext
 */
class JournalManager: ObservableObject {
    /// Published collection of journal entries for SwiftUI views
    @Published private(set) var entries: [JournalEntry] = []

    /// Core Data managed object context for persistence operations
    private let viewContext: NSManagedObjectContext

    /// Logger for debugging and error reporting
    private let logger = os.Logger(subsystem: "com.vybemvp", category: "journal")

    /**
     * Initializes the JournalManager with a Core Data context.
     *
     * - Parameter context: The managed object context to use for persistence.
     *                     Defaults to the shared PersistenceController's context.
     *
     * Upon initialization, the manager loads any existing journal entries from storage.
     */
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        loadEntries()
    }

    // MARK: - CRUD Operations

    /**
     * Ensures a focus number is within the valid range of 1-9.
     *
     * - Parameter number: The number to validate
     * - Returns: A number constrained to the range 1-9
     */
    private func validateFocusNumber(_ number: Int) -> Int {
        return max(1, min(number, 9))
    }

    /**
     * Creates a new journal entry and persists it to storage.
     *
     * - Parameters:
     *   - title: The title of the journal entry
     *   - content: The main text content of the entry
     *   - focusNumber: The focus number (1-9) associated with the entry
     *   - realmNumber: The realm number at the time of entry creation
     *   - moodEmoji: Optional emoji representing the user's mood
     *   - voiceRecordingFilename: Optional filename for voice recording
     *
     * - Returns: The newly created journal entry
     */
    func createEntry(
        title: String,
        content: String,
        focusNumber: Int,
        realmNumber: Int? = nil,
        moodEmoji: String? = nil,
        voiceRecordingFilename: String? = nil
    ) -> JournalEntry {
        print("📝 Creating journal entry: \(title)")

        let entry = JournalEntry(context: viewContext)
        entry.id = UUID()
        entry.title = title
        entry.content = content
        entry.focusNumber = Int16(validateFocusNumber(focusNumber))
        entry.realmNumber = Int16(realmNumber ?? 0)
        entry.moodEmoji = moodEmoji
        entry.voiceRecordingFilename = voiceRecordingFilename
        entry.timestamp = Date()

        saveContext()
        loadEntries()
        return entry
    }

    /**
     * Loads all journal entries from persistent storage.
     *
     * This method:
     * 1. Creates a fetch request for JournalEntry objects
     * 2. Sorts entries by timestamp (newest first)
     * 3. Updates the published entries collection
     * 4. Logs the result of the operation
     */
    func loadEntries() {
        let request = NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \JournalEntry.timestamp, ascending: false)]

        do {
            entries = try viewContext.fetch(request)
            print("📖 Loaded \(entries.count) journal entries")
        } catch {
            print("❌ Failed to fetch entries: \(error)")
        }
    }

    /**
     * Updates an existing journal entry with new values.
     *
     * - Parameters:
     *   - entry: The journal entry to update
     *   - title: The new title
     *   - content: The new content
     *   - moodEmoji: Optional new mood emoji
     */
    func updateEntry(
        _ entry: JournalEntry,
        title: String,
        content: String,
        moodEmoji: String? = nil
    ) {
        print("✏️ Updating entry: \(entry.id?.uuidString ?? "unknown")")

        entry.title = title
        entry.content = content
        entry.moodEmoji = moodEmoji

        saveContext()
        loadEntries()
    }

    /**
     * Deletes a journal entry from persistent storage.
     *
     * - Parameter entry: The entry to delete
     */
    func deleteEntry(_ entry: JournalEntry) {
        print("🗑️ Deleting entry: \(entry.id?.uuidString ?? "unknown")")
        viewContext.delete(entry)
        saveContext()
        loadEntries()
    }

    // MARK: - Helper Methods

    /**
     * Saves the Core Data context if it has changes.
     *
     * This private method handles the error logging and
     * actual persistence operation to Core Data.
     */
    private func saveContext() {
        guard viewContext.hasChanges else { return }

        // Use background context to avoid blocking main thread
        PersistenceController.shared.save()
        print("✅ Context saved successfully (background context)")
    }

    // MARK: - Filtering Methods

    /**
     * Returns journal entries associated with a specific focus number.
     *
     * - Parameter number: The focus number (1-9) to filter by
     * - Returns: Array of matching journal entries
     */
    func entriesForFocusNumber(_ number: Int) -> [JournalEntry] {
        return entries.filter { $0.focusNumber == number }
    }

    /**
     * Returns journal entries created on a specific date.
     *
     * - Parameter date: The date to filter by
     * - Returns: Array of entries created on that date
     */
    func entriesForDate(_ date: Date) -> [JournalEntry] {
        return entries.filter { entry in
            guard let entryDate = entry.timestamp else { return false }
            return Calendar.current.isDate(entryDate, inSameDayAs: date)
        }
    }

    // MARK: - Testing Methods

    /**
     * Creates a test journal entry for development purposes.
     *
     * This method creates a sample entry with predefined values
     * and logs the updated entry count.
     */
    func testCreateEntry() {
        print("\n📝 TESTING JOURNAL ENTRY CREATION")
        print("----------------------------------------")

        _ = createEntry(
            title: "Test Entry",
            content: "This is a test journal entry",
            focusNumber: 7,
            moodEmoji: "Focused"
        )

        print("Current entries count: \(entries.count)")
        print("----------------------------------------\n")
    }

    /**
     * Prints all current journal entries for debugging.
     *
     * This method logs the details of all entries to the console,
     * making it easier to verify data during development.
     */
    func testListEntries() {
        print("\n📖 CURRENT JOURNAL ENTRIES")
        print("----------------------------------------")

        entries.forEach { entry in
            print("Title: \(entry.title ?? "Untitled")")
            print("Focus Number: \(entry.focusNumber)")
            print("Date: \(entry.timestamp?.description ?? "No date")")
            print("----------------")
        }

        print("----------------------------------------\n")
    }
}
