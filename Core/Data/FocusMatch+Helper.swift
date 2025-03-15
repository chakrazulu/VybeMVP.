/**
 * Filename: FocusMatch+Helper.swift
 * 
 * Purpose: Provides helper methods and computed properties for the FocusMatch entity.
 *
 * This file extends the FocusMatch class with convenience methods for creating new
 * instances and accessing formatted data. These helpers simplify working with
 * FocusMatch objects throughout the application.
 *
 * Design pattern: Extension-based helpers for Core Data entity
 * Dependencies: Foundation, CoreData, CoreLocation
 */

import Foundation
import CoreData
import CoreLocation

/**
 * Extension providing helper methods and computed properties for FocusMatch
 */
extension FocusMatch {
    /**
     * Creates a new FocusMatch instance with the provided data
     *
     * This factory method ensures that:
     * - The timestamp is set to the current date and time
     * - The chosen and matched numbers are constrained to valid values (1-9)
     * - Location data is properly stored
     *
     * @param context The managed object context to create the match in
     * @param chosenNumber The user's selected focus number
     * @param matchedNumber The realm number that matched
     * @param latitude The geographical latitude where the match occurred
     * @param longitude The geographical longitude where the match occurred
     * @return A new FocusMatch instance
     */
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
    
    /**
     * Returns a formatted string representation of the match timestamp
     *
     * The date is formatted with medium date style and short time style
     * (e.g., "Jan 1, 2023 at 12:30 PM")
     */
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    /**
     * Returns the match location as a CLLocationCoordinate2D
     *
     * This computed property simplifies using the match location with
     * MapKit and other location-based APIs.
     */
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
    }
} 
