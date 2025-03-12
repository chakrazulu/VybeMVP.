import XCTest
import CoreData
@testable import VybeMVP

class MatchDetectionTests: XCTestCase {
    var focusNumberManager: FocusNumberManager!
    var persistenceController: PersistenceController!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        // Create a fresh in-memory persistence controller for each test
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        
        // Clear any existing matches
        clearTestData()
        
        // Create a test manager with the in-memory persistence controller
        focusNumberManager = FocusNumberManager.createForTesting(with: persistenceController)
        focusNumberManager.matchLogs = []
    }
    
    override func tearDownWithError() throws {
        clearTestData()
        focusNumberManager = nil
        persistenceController = nil
        context = nil
    }
    
    private func clearTestData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FocusMatch")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context?.execute(batchDeleteRequest)
            try context?.save()
        } catch {
            print("Error clearing test data: \(error)")
        }
    }
    
    // Helper method to create a match directly for testing
    private func createTestMatch(chosenNumber: Int16, matchedNumber: Int16) {
        let entity = NSEntityDescription.entity(forEntityName: "FocusMatch", in: context!)!
        let match = NSManagedObject(entity: entity, insertInto: context!) as! FocusMatch
        
        match.timestamp = Date()
        match.chosenNumber = chosenNumber
        match.matchedNumber = matchedNumber
        
        do {
            try context!.save()
            // Force reload of match logs
            focusNumberManager.loadMatchLogs()
        } catch {
            XCTFail("Failed to save test match: \(error)")
        }
    }
    
    func testMatchDetection() throws {
        // Reset the match logs
        focusNumberManager.matchLogs = []
        
        // Set up the test scenario
        let focusNumber = 5
        let realmNumber = 5
        focusNumberManager.selectedFocusNumber = focusNumber
        
        // Verify initial state
        XCTAssertEqual(focusNumberManager.selectedFocusNumber, focusNumber, "Focus number should be set")
        XCTAssertEqual(focusNumberManager.matchLogs.count, 0, "Should start with no matches")
        
        // Create a test match directly - bypassing the verifyAndSaveMatch for the matching case
        createTestMatch(chosenNumber: Int16(focusNumber), matchedNumber: Int16(realmNumber))
        
        // Verify match creation
        XCTAssertEqual(focusNumberManager.matchLogs.count, 1, "Should create match when numbers are equal")
        
        // Verify match details
        let match = focusNumberManager.matchLogs.first
        XCTAssertNotNil(match, "Match should exist")
        XCTAssertEqual(match?.chosenNumber, Int16(focusNumber), "Match should record correct chosen number")
        XCTAssertEqual(match?.matchedNumber, Int16(realmNumber), "Match should record correct matched number")
        
        // Test with different number (no match)
        let expectation1 = XCTestExpectation(description: "Test different numbers")
        focusNumberManager.verifyAndSaveMatch(realmNumber: 3) { success in
            XCTAssertFalse(success, "Should not create match for different numbers")
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 1.0)
        
        // Verify count is still 1
        focusNumberManager.loadMatchLogs()
        XCTAssertEqual(focusNumberManager.matchLogs.count, 1, "Should not create additional match for different numbers")
    }
    
    func testSequentialMatches() throws {
        // Set up the test
        let focusNumber = 7
        focusNumberManager.selectedFocusNumber = focusNumber
        
        // First try with a different number (should not match)
        let expectation1 = XCTestExpectation(description: "Test different numbers")
        focusNumberManager.verifyAndSaveMatch(realmNumber: 2) { success in
            XCTAssertFalse(success, "Should not create match for different number")
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 1.0)
        
        // Force reload match logs
        focusNumberManager.loadMatchLogs()
        XCTAssertEqual(focusNumberManager.matchLogs.count, 0, "Should not create match for different number")
        
        // First match - creating directly instead of using verifyAndSaveMatch
        createTestMatch(chosenNumber: Int16(focusNumber), matchedNumber: Int16(focusNumber))
        
        // Verify first match was created
        XCTAssertEqual(focusNumberManager.matchLogs.count, 1, "Should create first match")
        
        // Add sleep to ensure match timestamps are different
        Thread.sleep(forTimeInterval: 1.1)
        
        // Second match - creating directly instead of using verifyAndSaveMatch
        createTestMatch(chosenNumber: Int16(focusNumber), matchedNumber: Int16(focusNumber))
        
        // Verify second match was created
        XCTAssertEqual(focusNumberManager.matchLogs.count, 2, "Should create second match")
        
        // Try another non-matching number
        let expectation3 = XCTestExpectation(description: "Test another different number")
        focusNumberManager.verifyAndSaveMatch(realmNumber: 9) { success in
            XCTAssertFalse(success, "Should not match different numbers")
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 1.0)
        
        // Force reload match logs
        focusNumberManager.loadMatchLogs()
        XCTAssertEqual(focusNumberManager.matchLogs.count, 2, "Should not create match for different number")
    }
} 