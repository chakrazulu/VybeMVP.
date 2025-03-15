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
     *   - moodEmoji: Optional emoji representing the user's mood
     *
     * - Returns: The newly created journal entry
     */
    func createEntry(title: String, content: String, focusNumber: Int, moodEmoji: String?) -> JournalEntry {
        let entry = JournalEntry(context: viewContext)
        entry.id = UUID()
        entry.title = title
        entry.content = content
        entry.focusNumber = Int16(focusNumber)
        entry.moodEmoji = moodEmoji
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
        
        do {
            try viewContext.save()
            print("✅ Context saved successfully")
        } catch {
            logger.error("Failed to save context: \(error.localizedDescription)")
        }
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
