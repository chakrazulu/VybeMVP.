import XCTest
@testable import VybeMVP
import CoreData

final class MatchAnalyticsTests: XCTestCase {
    var focusNumberManager: FocusNumberManager!
    var analyticsView: MatchAnalyticsView!
    
    override func setUp() {
        super.setUp()
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FocusMatch")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Error clearing matches: \(error)")
        }
        
        focusNumberManager = FocusNumberManager()
        analyticsView = MatchAnalyticsView(focusNumberManager: focusNumberManager)
    }
    
    override func tearDown() {
        focusNumberManager.matchLogs = []
        focusNumberManager = nil
        analyticsView = nil
        super.tearDown()
    }
    
    func testMostCommonFocusNumber() {
        // Create test matches with known focus numbers
        let context = PersistenceController.shared.container.viewContext
        
        let match1 = FocusMatch(context: context)
        match1.chosenNumber = 7
        match1.timestamp = Date()
        focusNumberManager.matchLogs.append(match1)
        
        let match2 = FocusMatch(context: context)
        match2.chosenNumber = 7
        match2.timestamp = Date()
        focusNumberManager.matchLogs.append(match2)
        
        let match3 = FocusMatch(context: context)
        match3.chosenNumber = 4
        match3.timestamp = Date()
        focusNumberManager.matchLogs.append(match3)
        
        try? context.save()
        
        // Print actual value for debugging
        let result = analyticsView.getMostCommonFocusNumber()
        print("Most common focus number result: \(result)")
        XCTAssertEqual(result, "7 (2 times)", "Most common focus number should be 7")
    }
    
    func testPeakMatchTime() {
        let context = PersistenceController.shared.container.viewContext
        let calendar = Calendar.current
        let baseDate = Date()
        
        // Create matches at 9 AM
        let morning = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: baseDate)!
        let match1 = FocusMatch(context: context)
        match1.timestamp = morning
        focusNumberManager.matchLogs.append(match1)
        
        let match2 = FocusMatch(context: context)
        match2.timestamp = morning
        focusNumberManager.matchLogs.append(match2)
        
        // Create match at 3 PM
        let afternoon = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: baseDate)!
        let match3 = FocusMatch(context: context)
        match3.timestamp = afternoon
        focusNumberManager.matchLogs.append(match3)
        
        try? context.save()
        
        // Print actual value for debugging
        let result = analyticsView.getPeakMatchTime()
        print("Peak match time result: \(result)")
        XCTAssertEqual(result, "9 AM", "Peak match time should be 9 AM")
    }
    
    func testMatchFrequency() {
        let context = PersistenceController.shared.container.viewContext
        let calendar = Calendar.current
        let baseDate = Date()
        
        let match1 = FocusMatch(context: context)
        match1.timestamp = baseDate
        focusNumberManager.matchLogs.append(match1)
        
        let match2 = FocusMatch(context: context)
        match2.timestamp = calendar.date(byAdding: .hour, value: 2, to: baseDate)!
        focusNumberManager.matchLogs.append(match2)
        
        let match3 = FocusMatch(context: context)
        match3.timestamp = calendar.date(byAdding: .hour, value: 4, to: baseDate)!
        focusNumberManager.matchLogs.append(match3)
        
        try? context.save()
        
        // Print actual value for debugging
        let result = analyticsView.getMatchFrequency()
        print("Match frequency result: \(result)")
        XCTAssertEqual(result, "Every 2.0 hours", "Average time between matches should be 2 hours")
    }
    
    func testTodayMatchCount() {
        let context = PersistenceController.shared.container.viewContext
        let calendar = Calendar.current
        let now = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        
        // Today's matches
        let match1 = FocusMatch(context: context)
        match1.timestamp = now
        focusNumberManager.matchLogs.append(match1)
        
        let match2 = FocusMatch(context: context)
        match2.timestamp = now
        focusNumberManager.matchLogs.append(match2)
        
        // Yesterday's match
        let match3 = FocusMatch(context: context)
        match3.timestamp = yesterday
        focusNumberManager.matchLogs.append(match3)
        
        try? context.save()
        
        // Print actual value for debugging
        let result = analyticsView.getTodayMatchCount()
        print("Today's match count result: \(result)")
        XCTAssertEqual(result, "2", "Today's match count should be 2")
    }
} 
