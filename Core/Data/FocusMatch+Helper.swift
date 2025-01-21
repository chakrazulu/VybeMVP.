import Foundation
import CoreData
import CoreLocation

extension FocusMatch {
    static func create(
        in context: NSManagedObjectContext,
        chosenNumber: Int16,
        matchedNumber: Int16,
        latitude: Double,
        longitude: Double
    ) -> FocusMatch {
        let match = FocusMatch(context: context)
        match.timestamp = Date()
        match.chosenNumber = max(1, min(chosenNumber, 9))
        match.matchedNumber = max(1, min(matchedNumber, 9))
        match.locationLatitude = latitude
        match.locationLongitude = longitude
        return match
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
    }
} 
