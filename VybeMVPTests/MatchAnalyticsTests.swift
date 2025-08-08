import XCTest
@testable import VybeMVP
import CoreData
import SwiftUI

@MainActor
final class MatchAnalyticsTests: XCTestCase {
    var focusNumberManager: FocusNumberManager!
    var persistenceController: PersistenceController!
    var matchAnalyticsView: MatchAnalyticsView!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        super.setUp()
        // Create a fresh in-memory persistence controller for each test
        persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        
        // Create the manager with our test controller
        focusNumberManager = FocusNumberManager.createForTesting(with: persistenceController)
        
        // Create some test matches
        createTestMatches()
        
        // Create a TestableMatchAnalyticsWrapper to properly provide environment values
        matchAnalyticsView = MatchAnalyticsView()
    }
    
    override func tearDownWithError() throws {
        // Clean up
        clearTestData()
        focusNumberManager = nil
        persistenceController = nil
        matchAnalyticsView = nil
        context = nil
        super.tearDown()
    }
    
    private func clearTestData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FocusMatch")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Error clearing test data: \(error)")
        }
    }
    
    private func createTestMatches() {
        // Create matches at different times
        let calendar = Calendar.current
        let now = Date()
        
        // Create matches for today
        for hour in [9, 10, 10, 10, 11, 14] { // 10 appears THREE times to ensure it's the peak time
            if let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: now) {
                createMatch(timestamp: date, chosenNumber: 5)
            }
        }
        
        // Create matches for yesterday
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now) {
            for hour in [9, 11, 15] {
                if let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: yesterday) {
                    createMatch(timestamp: date, chosenNumber: 7)
                }
            }
        }
        
        // Save the context
        saveContext()
        
        // Force reload of matches in FocusNumberManager
        focusNumberManager.loadMatchLogs()
    }
    
    private func createMatch(timestamp: Date, chosenNumber: Int16) {
        // Create entity using context directly to avoid +entity method
        let entity = NSEntityDescription.entity(forEntityName: "FocusMatch", in: context)!
        let match = NSManagedObject(entity: entity, insertInto: context) as! FocusMatch
        
        match.timestamp = timestamp
        match.chosenNumber = chosenNumber
        match.matchedNumber = chosenNumber
        // REALM NUMBER ANALYTICS ENHANCEMENT: Set realm number for test analytics
        match.realmNumber = chosenNumber  // Use same number for simplicity in tests
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving test context: \(error)")
        }
    }
    
    // Testing helper function - direct access to the analytics view model
    private func getAnalyticsViewModel() -> MatchAnalyticsViewModel {
        // Create and configure the view model directly rather than through the view
        let viewModel = MatchAnalyticsViewModel()
        // Set the context and pass the manager's match logs directly
        viewModel.managedObjectContext = context
        viewModel.matchLogs = focusNumberManager.matchLogs
        return viewModel
    }
    
    func testPeakMatchTime() throws {
        let viewModel = getAnalyticsViewModel()
        let peakTime = viewModel.getPeakMatchTime()
        XCTAssertEqual(peakTime, "10:00", "Peak match time should be 10:00")
    }
    
    func testTodayMatchCount() throws {
        let viewModel = getAnalyticsViewModel()
        let todayCount = viewModel.getTodayMatchCount()
        XCTAssertEqual(todayCount, "6", "Should have 6 matches today")
    }
    
    func testMostCommonFocusNumber() throws {
        let viewModel = getAnalyticsViewModel()
        let commonNumber = viewModel.getMostCommonFocusNumber()
        XCTAssertEqual(commonNumber, "5 (6 times)", "Most common focus number should be 5 with 6 occurrences")
    }
    
    // REALM NUMBER ANALYTICS ENHANCEMENT: Test the new realm number analytics
    func testMostCommonRealmNumber() throws {
        let viewModel = getAnalyticsViewModel()
        let commonRealm = viewModel.getMostCommonRealmNumber()
        // In our test data, realm numbers match focus numbers, so 5 should be most common
        XCTAssertEqual(commonRealm, "5 (6 times)", "Most common realm number should be 5 with 6 occurrences")
    }
} 

