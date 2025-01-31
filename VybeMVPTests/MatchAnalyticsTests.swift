import XCTest
@testable import VybeMVP
import CoreData
import SwiftUI

final class MatchAnalyticsTests: XCTestCase {
    var focusNumberManager: FocusNumberManager!
    var persistenceController: PersistenceController!
    var matchAnalyticsView: MatchAnalyticsView!
    
    override func setUpWithError() throws {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        focusNumberManager = FocusNumberManager.createForTesting(with: persistenceController)
        
        // Create the view directly
        matchAnalyticsView = MatchAnalyticsView()
        // Set up environment after creation
        let _ = matchAnalyticsView.environment(\.managedObjectContext, persistenceController.container.viewContext)
        let _ = matchAnalyticsView.environmentObject(focusNumberManager)
        
        // Create some test matches
        createTestMatches()
    }
    
    override func tearDownWithError() throws {
        focusNumberManager = nil
        persistenceController = nil
        matchAnalyticsView = nil
        super.tearDown()
    }
    
    private func createTestMatches() {
        let context = persistenceController.container.viewContext
        
        // Create matches at different times
        let calendar = Calendar.current
        let now = Date()
        
        // Create matches for today
        for hour in [9, 10, 10, 11, 14] { // 10 appears twice to test peak time
            if let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: now) {
                let match = FocusMatch(context: context)
                match.timestamp = date
                match.chosenNumber = 5
            }
        }
        
        // Create matches for yesterday
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now) {
            for hour in [9, 11, 15] {
                if let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: yesterday) {
                    let match = FocusMatch(context: context)
                    match.timestamp = date
                    match.chosenNumber = 7
                }
            }
        }
        
        try? context.save()
    }
    
    func testPeakMatchTime() throws {
        let peakTime = matchAnalyticsView.getPeakMatchTime()
        XCTAssertEqual(peakTime, "10:00", "Peak match time should be 10:00")
    }
    
    func testTodayMatchCount() throws {
        let todayCount = matchAnalyticsView.getTodayMatchCount()
        XCTAssertEqual(todayCount, "5", "Should have 5 matches today")
    }
    
    func testMostCommonFocusNumber() throws {
        let commonNumber = matchAnalyticsView.getMostCommonFocusNumber()
        XCTAssertEqual(commonNumber, "5 (5 times)", "Most common focus number should be 5 with 5 occurrences")
    }
} 
