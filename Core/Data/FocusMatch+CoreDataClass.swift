import Foundation
import CoreData

@objc(FocusMatch)
public class FocusMatch: NSManagedObject, Hashable {
    public static func == (lhs: FocusMatch, rhs: FocusMatch) -> Bool {
        lhs.timestamp == rhs.timestamp &&
        lhs.chosenNumber == rhs.chosenNumber &&
        lhs.matchedNumber == rhs.matchedNumber &&
        lhs.locationLatitude == rhs.locationLatitude &&
        lhs.locationLongitude == rhs.locationLongitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
        hasher.combine(chosenNumber)
        hasher.combine(matchedNumber)
        hasher.combine(locationLatitude)
        hasher.combine(locationLongitude)
    }
} 