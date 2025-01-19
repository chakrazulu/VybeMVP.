import Foundation
import CoreData

extension FocusMatch {
    static func create(in context: NSManagedObjectContext,
                      chosenNumber: Int16,
                      matchedNumber: Int16,
                      latitude: Double,
                      longitude: Double) -> FocusMatch {
        let match = FocusMatch(context: context)
        match.timestamp = Date()
        match.chosenNumber = chosenNumber
        match.matchedNumber = matchedNumber
        match.locationLatitude = latitude
        match.locationLongitude = longitude
        return match
    }
} 