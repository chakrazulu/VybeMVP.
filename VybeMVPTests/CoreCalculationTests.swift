import XCTest
@testable import VybeMVP
import CoreData
import CoreLocation

final class CoreCalculationTests: XCTestCase {
    var focusNumberManager: FocusNumberManager!
    var realmNumberManager: RealmNumberManager!
    var persistenceController: PersistenceController!
    
    override func setUpWithError() throws {
        super.setUp()
        persistenceController = PersistenceController(inMemory: true)
        focusNumberManager = FocusNumberManager.createForTesting(with: persistenceController)
        
        // Initialize realm manager
        realmNumberManager = RealmNumberManager()
        
        // Clear existing data if any
        let context = persistenceController.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FocusMatch")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            print("Error clearing matches: \(error)")
        }
    }
    
    override func tearDownWithError() throws {
        focusNumberManager = nil
        persistenceController = nil
        realmNumberManager = nil
        super.tearDown()
    }
    
    // MARK: - FocusNumberManager Tests
    
    func testNumerologicalReduction() throws {
        // Test various numbers and their reductions
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(123), 6) // 1+2+3 = 6
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(999), 9) // 9+9+9 = 27 → 2+7 = 9
        XCTAssertEqual(focusNumberManager.reduceToSingleDigit(2025), 9) // 2+0+2+5 = 9
    }
    
    func testTimeComponentCalculation() throws {
        // Get current time components
        let timeFactor = focusNumberManager.calculateTimeFactor()
        
        // Verify result is within valid range (1-9)
        XCTAssertTrue(timeFactor >= 1 && timeFactor <= 9, "Time factor should be between 1 and 9")
    }
    
    func testLocationFactorCalculation() throws {
        // Set up test location
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        focusNumberManager.currentLocation = testLocation
        
        // Calculate location factor
        let locationFactor = focusNumberManager.calculateLocationFactor()
        
        // Verify result is within valid range (1-9)
        XCTAssertTrue(locationFactor >= 1 && locationFactor <= 9, "Location factor should be between 1 and 9")
    }
    
    func testTranscendentalCalculation() throws {
        // Set up test values
        focusNumberManager.selectedFocusNumber = 7
        let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        focusNumberManager.currentLocation = testLocation
        
        // Calculate transcendental number
        let transcendentalNumber = focusNumberManager.calculateTranscendentalNumber()
        
        // Verify result is within valid range (1-9)
        XCTAssertTrue(transcendentalNumber >= 1 && transcendentalNumber <= 9, "Transcendental number should be between 1 and 9")
    }
    
    func testMatchLogging() throws {
        // Set up test values
        focusNumberManager.selectedFocusNumber = 5
        focusNumberManager.realmNumber = 5
        
        // Verify match is logged
        let fetchRequest: NSFetchRequest<FocusMatch> = FocusMatch.fetchRequest()
        let matches = try persistenceController.container.viewContext.fetch(fetchRequest)
        
        XCTAssertTrue(matches.count > 0, "A match should be logged when focus numbers align")
    }
    
    // MARK: - RealmNumberManager Tests
    
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
        
        // Store current BPM and cycle through all mock BPMs
        let initialBPM = realmNumberManager.currentMockBPM
        var foundDifferentNumber = false
    
        // Try cycling through BPMs multiple times to ensure we get a different number
        for _ in 0..<5 {
            realmNumberManager.cycleToNextMockBPM()
            Thread.sleep(forTimeInterval: 0.1)
        
            if realmNumberManager.currentRealmNumber != numberAfterLocation {
                foundDifferentNumber = true
                break
                }
            }
        
        XCTAssertTrue(foundDifferentNumber, "Realm number should change after cycling through different BPM values")
    }
} 
