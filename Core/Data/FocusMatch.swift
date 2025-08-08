/**
 * Filename: FocusMatch.swift
 * 
 * Purpose: Defines the Core Data model for focus number matches in the application.
 *
 * This file contains the FocusMatch class which represents instances when a user's
 * chosen focus number matches with a realm number. These matches are significant events
 * in the app's experience and are stored for historical tracking and analytics.
 *
 * Design pattern: Core Data NSManagedObject subclass with extensions
 * Dependencies: CoreData
 */

import CoreData

/**
 * Core Data entity representing a match between a focus number and realm number
 *
 * This class defines the structure for storing focus number matches. A match occurs
 * when the user's selected focus number aligns with the calculated realm number.
 * Each match record includes the numbers involved, timestamp, and location data.
 *
 * These records are used for:
 * - Displaying match history to the user
 * - Generating analytics and patterns
 * - Providing insights into the frequency and context of matches
 */
@objc(FocusMatch)
public class FocusMatch: NSManagedObject {
    /// Date and time when the match occurred
    @NSManaged public var timestamp: Date
    
    /// The focus number chosen by the user (1-9)
    @NSManaged public var chosenNumber: Int16
    
    /// The realm number that matched with the user's focus number (1-9)
    @NSManaged public var matchedNumber: Int16
    
    /// REALM NUMBER ANALYTICS ENHANCEMENT: The realm number (1-9) active when this match occurred
    /// Enables analytics of which spiritual states correlate with synchronicity events
    @NSManaged public var realmNumber: Int16
    
    /// Geographical latitude where the match occurred
    @NSManaged public var locationLatitude: Double
    
    /// Geographical longitude where the match occurred
    @NSManaged public var locationLongitude: Double
}

/**
 * Extension providing additional functionality for FocusMatch
 */
extension FocusMatch {
    /**
     * Creates a fetch request for FocusMatch entities
     *
     * @return NSFetchRequest configured for FocusMatch
     */
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FocusMatch> {
        return NSFetchRequest<FocusMatch>(entityName: "FocusMatch")
    }
} 