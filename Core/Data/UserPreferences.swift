import CoreData

/**
 * UserPreferences: Core Data entity for user settings and preferences
 *
 * 🎯 CORE DATA MODEL REFERENCE GUIDE FOR FUTURE AI ASSISTANTS 🎯
 *
 * === CORE PURPOSE ===
 * Persistent storage for user's app preferences and settings.
 * Automatically synced across app launches via Core Data.
 *
 * === ENTITY PROPERTIES ===
 * • lastSelectedNumber: Int16 - User's last chosen focus number (1-9)
 * • isAutoUpdateEnabled: Bool - Whether automatic updates are enabled
 *
 * === DATA PERSISTENCE ===
 * • Stored in: Core Data persistent store
 * • Entity name: "UserPreferences"
 * • Managed by: PersistenceController.shared
 * • Thread safety: Main context operations
 *
 * === USAGE PATTERNS ===
 * • Typically one instance per user
 * • Loaded on app launch
 * • Updated when user changes settings
 * • Automatically persisted to disk
 *
 * === INTEGRATION POINTS ===
 * • FocusNumberManager: Reads lastSelectedNumber
 * • Settings views: Updates preferences
 * • Onboarding: Initial preference setup
 *
 * === FETCH REQUEST ===
 * Standard Core Data fetch using:
 * NSFetchRequest<UserPreferences>(entityName: "UserPreferences")
 *
 * === CRITICAL NOTES ===
 * • @objc annotation required for Core Data
 * • NSManagedObject subclass
 * • Int16 used for number storage (Core Data compatibility)
 * • Bool directly supported by Core Data
 */
@objc(UserPreferences)
public class UserPreferences: NSManagedObject {
    @NSManaged public var lastSelectedNumber: Int16
    @NSManaged public var isAutoUpdateEnabled: Bool
}

extension UserPreferences {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserPreferences> {
        return NSFetchRequest<UserPreferences>(entityName: "UserPreferences")
    }
}
