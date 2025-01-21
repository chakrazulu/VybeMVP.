import Foundation
import CoreData
import CoreLocation
import os

class JournalManager: ObservableObject {
    @Published private(set) var entries: [JournalEntry] = []
    private let viewContext: NSManagedObjectContext
    private let logger = os.Logger(subsystem: "com.vybemvp", category: "journal")
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        loadEntries()
    }
    
    // MARK: - CRUD Operations
    
    private func validateFocusNumber(_ number: Int) -> Int {
        return max(1, min(number, 9))
    }
    
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
    
    func deleteEntry(_ entry: JournalEntry) {
        print("🗑️ Deleting entry: \(entry.id?.uuidString ?? "unknown")")
        viewContext.delete(entry)
        saveContext()
        loadEntries()
    }
    
    // MARK: - Helper Methods
    
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
    
    func entriesForFocusNumber(_ number: Int) -> [JournalEntry] {
        return entries.filter { $0.focusNumber == number }
    }
    
    func entriesForDate(_ date: Date) -> [JournalEntry] {
        return entries.filter { entry in
            guard let entryDate = entry.timestamp else { return false }
            return Calendar.current.isDate(entryDate, inSameDayAs: date)
        }
    }
    
    // Add these test functions
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
