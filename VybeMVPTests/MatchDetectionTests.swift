import XCTest
@testable import VybeMVP
import CoreData

final class MatchDetectionTests: XCTestCase {
    var focusNumberManager: FocusNumberManager!
    var realmNumberManager: RealmNumberManager!
    var backgroundManager: BackgroundManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Clear existing data
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MatchLog")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error clearing test data: \(error)")
        }
        
        focusNumberManager = FocusNumberManager.shared
        // Reset singleton state
        focusNumberManager.selectedFocusNumber = 1
        focusNumberManager.matchLogs = []
        focusNumberManager.isAutoUpdateEnabled = false
        
        realmNumberManager = RealmNumberManager()
        backgroundManager = BackgroundManager.shared
        backgroundManager.setManagers(realm: realmNumberManager, focus: focusNumberManager)
    }
    
    override func tearDownWithError() throws {
        // Reset singleton state instead of setting to nil
        focusNumberManager.selectedFocusNumber = 1
        focusNumberManager.matchLogs = []
        focusNumberManager.isAutoUpdateEnabled = false
        
        realmNumberManager = nil
        backgroundManager = nil
        try super.tearDownWithError()
    }
    
    func testMatchDetection() {
        // Set user's focus number to 7
        focusNumberManager.selectedFocusNumber = 7
        XCTAssertEqual(focusNumberManager.selectedFocusNumber, 7, "Focus number should be 7")
        
        // Initially no matches
        XCTAssertEqual(focusNumberManager.matchLogs.count, 0, "Should start with no matches")
        
        // Update realm number to something different (no match)
        focusNumberManager.realmNumber = 5
        XCTAssertEqual(focusNumberManager.matchLogs.count, 0, "Should not create match for different numbers")
        
        // Update realm number to match focus number
        focusNumberManager.realmNumber = 7
        XCTAssertEqual(focusNumberManager.matchLogs.count, 1, "Should create match when numbers are equal")
        
        // Verify match details
        let match = focusNumberManager.matchLogs.first
        XCTAssertNotNil(match, "Match should exist")
        XCTAssertEqual(match?.chosenNumber, 7, "Chosen number should be 7")
        XCTAssertEqual(match?.matchedNumber, 7, "Matched number should be 7")
    }
    
    func testNoFalseMatches() {
        // Set user's focus number
        focusNumberManager.selectedFocusNumber = 4
        
        // Update realm number to a different number
        focusNumberManager.realmNumber = 5
        
        // Should not create a match since it doesn't match selected number
        XCTAssertEqual(focusNumberManager.matchLogs.count, 0, "Should not create match for different number")
    }
    
    func testMultipleMatches() {
        // Set user's focus number
        focusNumberManager.selectedFocusNumber = 3
        
        // Create multiple matches
        focusNumberManager.realmNumber = 3 // First match
        XCTAssertEqual(focusNumberManager.matchLogs.count, 1, "Should create first match")
        
        // Update to different number
        focusNumberManager.realmNumber = 5
        XCTAssertEqual(focusNumberManager.matchLogs.count, 1, "Should not create match for different number")
        
        // Match again
        focusNumberManager.realmNumber = 3
        XCTAssertEqual(focusNumberManager.matchLogs.count, 2, "Should create second match")
    }
} 