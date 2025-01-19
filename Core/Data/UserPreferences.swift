import CoreData

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
