import XCTest
@testable import VybeMVP
import CoreData
import CoreLocation

final class CoreCalculationTests: XCTestCase {
    var focusNumberManager: FocusNumberManager!
    var realmNumberManager: RealmNumberManager!
    
    override func setUp() {
        super.setUp()
        // Clear existing data
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
        realmNumberManager = RealmNumberManager()
    }
    
    override func tearDown() {
        focusNumberManager = nil
        realmNumberManager = nil
        super.tearDown()
    }
    
    // MARK: - FocusNumberManager Tests
    
    func testNumerologicalReduction() {
        // Test various numbers and their reductions
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(123), 6) // 1+2+3 = 6
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(999), 9) // 9+9+9 = 27 → 2+7 = 9
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(2025), 9) // 2+0+2+5 = 9
    }
    
    func testTimeComponentCalculation() {
        let testDate = Calendar.current.date(from: DateComponents(year: 2025, month: 1, day: 23, hour: 15, minute: 30))!
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: testDate)
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let hour = components.hour!
        let minute = components.minute!
        
        // Test individual reductions
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(year), 9) // 2025 → 2+0+2+5 = 9
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(month), 1)
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(day), 5) // 23 → 2+3 = 5
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(hour), 6) // 15 → 1+5 = 6
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(minute), 3) // 30 → 3+0 = 3
    }
    
    func testLocationFactorCalculation() {
        let location = CLLocation(latitude: 35.334329, longitude: -80.895466)
        focusNumberManager.currentLocation = location
        
        // Test latitude reduction (35.334329 → 35334329 → 3+5+3+3+4+3+2+9 = 32 → 3+2 = 5)
        let latitudeDigits = String(format: "%.6f", abs(location.coordinate.latitude))
            .replacingOccurrences(of: ".", with: "")
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(Int(latitudeDigits) ?? 0), 5)
        
        // Test longitude reduction (80.895466 → 80895466 → 8+0+8+9+5+4+6+6 = 46 → 4+6 = 1)
        let longitudeDigits = String(format: "%.6f", abs(location.coordinate.longitude))
            .replacingOccurrences(of: ".", with: "")
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(Int(longitudeDigits) ?? 0), 1)
    }
    
    // MARK: - RealmNumberManager Tests
    
    func testTranscendentalCalculation() {
        // Create a fixed test date in UTC
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let testDate = calendar.date(from: DateComponents(year: 2025, month: 1, day: 23, hour: 20, minute: 30))!
        let location = CLLocation(latitude: 35.334329, longitude: -80.895466)
        
        // Set the test date in RealmNumberManager
        realmNumberManager.setTestDate(testDate)
        realmNumberManager.updateLocation(location)
        
        // Wait for initial calculation
        Thread.sleep(forTimeInterval: 0.1)
        
        // Test raw component calculations
        let hour = 20
        let minute = 30
        let timeSum = realmNumberManager.reduceToSingleDigit(hour + minute) // 20 + 30 = 50 → 5
        
        let day = 23
        let month = 1
        let dateSum = realmNumberManager.reduceToSingleDigit(day + month) // 23 + 1 = 24 → 2+4 = 6
        
        // Location sum (35.334329 → 5, -80.895466 → 1)
        let latString = String(format: "%.6f", abs(location.coordinate.latitude))
            .replacingOccurrences(of: ".", with: "")
        let longString = String(format: "%.6f", abs(location.coordinate.longitude))
            .replacingOccurrences(of: ".", with: "")
        
        let latSum = realmNumberManager.reduceToSingleDigit(Int(latString) ?? 0)  // Should be 5
        let longSum = realmNumberManager.reduceToSingleDigit(Int(longString) ?? 0)  // Should be 1
        let locationSum = realmNumberManager.reduceToSingleDigit(latSum + longSum)  // 5 + 1 = 6
        
        // Test BPM (using first mock value: 62)
        let bpmSum = realmNumberManager.reduceToSingleDigit(62)  // 6+2 = 8
        
        // Final calculation: (5 + 6 + 6 + 8 = 25 → 7)
        let totalSum = timeSum + dateSum + locationSum + bpmSum
        let finalNumber = realmNumberManager.reduceToSingleDigit(totalSum)
        
        print("\n🧪 Test Calculation Breakdown:")
        print("Time Sum (\(hour) + \(minute) = \(hour + minute) → \(timeSum)): \(timeSum)")
        print("Date Sum (\(day) + \(month) = \(day + month) → \(dateSum)): \(dateSum)")
        print("Location Sum (\(locationSum)): \(locationSum)")
        print("BPM Sum (\(realmNumberManager.currentMockBPM) → \(bpmSum)): \(bpmSum)")
        print("Total Sum (\(timeSum) + \(dateSum) + \(locationSum) + \(bpmSum) = \(totalSum) → \(finalNumber))")
        
        XCTAssertEqual(String(finalNumber), String(realmNumberManager.currentRealmNumber))
    }
    
    func testRealmStateTransitions() {
        // Test initial state
        XCTAssertEqual(realmNumberManager.currentRealmNumber, 1)
        
        // Test state after location update
        let location = CLLocation(latitude: 35.334329, longitude: -80.895466)
        realmNumberManager.updateLocation(location)
        
        // Wait for calculation
        Thread.sleep(forTimeInterval: 0.1)
        let numberAfterLocation = realmNumberManager.currentRealmNumber
        XCTAssertNotEqual(numberAfterLocation, 1, "Realm number should change after location update")
        
        // Test state after BPM change
        realmNumberManager.cycleToNextMockBPM()
        
        // Wait for calculation
        Thread.sleep(forTimeInterval: 0.1)
        XCTAssertNotEqual(realmNumberManager.currentRealmNumber, numberAfterLocation, "Realm number should change after BPM update")
    }
} 
