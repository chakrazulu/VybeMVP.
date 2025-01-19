import CoreData

@objc(FocusMatch)
public class FocusMatch: NSManagedObject {
    @NSManaged public var timestamp: Date
    @NSManaged public var chosenNumber: Int16
    @NSManaged public var matchedNumber: Int16
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double
}

extension FocusMatch {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FocusMatch> {
        return NSFetchRequest<FocusMatch>(entityName: "FocusMatch")
    }
} 