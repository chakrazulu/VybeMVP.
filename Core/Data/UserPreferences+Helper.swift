import Foundation
import CoreData

extension UserPreferences {
    static func fetch(in context: NSManagedObjectContext) -> UserPreferences {
        let request: NSFetchRequest<UserPreferences> = UserPreferences.fetchRequest()
        
        print("🔍 Fetching preferences...")
        // Try to fetch existing preferences
        if let existing = try? context.fetch(request).first {
            print("✅ Found existing preferences: Number=\(existing.lastSelectedNumber)")
            return existing
        }
        
        print("📝 Creating new preferences...")
        // Create new preferences if none exist
        let preferences = UserPreferences(context: context)
        preferences.lastSelectedNumber = 0
        preferences.isAutoUpdateEnabled = false
        
        do {
            try context.save()
            print("✅ Created new preferences")
        } catch {
            print("❌ Failed to create preferences: \(error)")
        }
        return preferences
    }
    
    static func save(in context: NSManagedObjectContext,
                    lastSelectedNumber: Int16,
                    isAutoUpdateEnabled: Bool) {
        print("💾 Attempting to save preferences: Number=\(lastSelectedNumber)")
        let preferences = fetch(in: context)
        preferences.lastSelectedNumber = lastSelectedNumber
        preferences.isAutoUpdateEnabled = isAutoUpdateEnabled
        
        do {
            try context.save()
            print("✅ Preferences saved successfully: Number=\(lastSelectedNumber)")
            // Verify the save worked
            let verify = fetch(in: context)
            print("🔍 Verifying save - Stored number: \(verify.lastSelectedNumber)")
        } catch {
            print("❌ Failed to save preferences: \(error)")
        }
    }
} 
