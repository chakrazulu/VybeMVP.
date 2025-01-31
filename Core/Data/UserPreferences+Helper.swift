import Foundation
import CoreData

extension UserPreferences {
    // Add static cache
    private static var cachedPreferences: UserPreferences?
    
    static func fetch(in context: NSManagedObjectContext) -> UserPreferences {
        // Return cached preferences if available
        if let cached = cachedPreferences {
            return cached
        }
        
        let request: NSFetchRequest<UserPreferences> = UserPreferences.fetchRequest()
        
        print("🔍 Fetching preferences...")
        // Try to fetch existing preferences
        if let existing = try? context.fetch(request).first {
            print("✅ Found existing preferences: Number=\(existing.lastSelectedNumber)")
            cachedPreferences = existing
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
            cachedPreferences = preferences
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
            // Update cache after successful save
            cachedPreferences = preferences
            print("✅ Preferences saved successfully: Number=\(lastSelectedNumber)")
        } catch {
            print("❌ Failed to save preferences: \(error)")
            // Clear cache on error
            cachedPreferences = nil
        }
    }
    
    // Add method to clear cache if needed
    static func clearCache() {
        cachedPreferences = nil
        print("🧹 Preferences cache cleared")
    }
} 
