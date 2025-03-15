import Foundation
import CoreData

extension FocusMatch {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FocusMatch> {
        return NSFetchRequest<FocusMatch>(entityName: "FocusMatch")
    }

    @NSManaged public var chosenNumber: Int16
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double
    @NSManaged public var matchedNumber: Int16
    @NSManaged public var timestamp: Date?
} 