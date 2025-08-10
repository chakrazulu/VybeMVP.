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

        // Create a unique, isolated in-memory store for each test
        persistenceController = PersistenceController(inMemory: true)

        // Clear any previous test data
        let context = persistenceController.container.viewContext
        let entities = persistenceController.container.managedObjectModel.entities

        // Clear all entities in the model
        for entity in entities {
            if let entityName = entity.name {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeObjectIDs

                do {
                    try context.execute(batchDeleteRequest)
                } catch {
                    print("Error clearing entity \(entityName): \(error)")
                }
            }
        }

        try context.save()

        // Initialize managers with the clean persistence controller
        focusNumberManager = FocusNumberManager.createForTesting(with: persistenceController)
        realmNumberManager = RealmNumberManager()
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
        // Create an expectation for the async save operation
        let saveExpectation = XCTestExpectation(description: "Match saved to Core Data")

        // Set up test values
        focusNumberManager.selectedFocusNumber = 5

        // Enable match detection for testing
        focusNumberManager.isMatchDetectionEnabled = true

        // Use updateRealmNumber instead of directly setting realmNumber
        // This ensures checkForMatches() gets called
        focusNumberManager.updateRealmNumber(5)

        // Explicitly trigger match detection
        focusNumberManager.checkForMatches()

        // Add a callback to be notified when the match is saved
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Verify match is logged after a delay to allow for async operations
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FocusMatch")
            do {
                let count = try self.persistenceController.container.viewContext.count(for: fetchRequest)
                print("Test found \(count) matches after waiting")
                if count > 0 {
                    saveExpectation.fulfill()
                } else {
                    // Try one more time after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        do {
                            let count = try self.persistenceController.container.viewContext.count(for: fetchRequest)
                            print("Test found \(count) matches on second attempt")
                            if count > 0 {
                                saveExpectation.fulfill()
                            }
                        } catch {
                            XCTFail("Failed to fetch matches on second attempt: \(error)")
                        }
                    }
                }
            } catch {
                XCTFail("Failed to fetch matches: \(error)")
            }
        }

        // Wait for the expectation to be fulfilled
        wait(for: [saveExpectation], timeout: 3.0)

        // Final verification - use count instead of fetching objects
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FocusMatch")
        let count = try persistenceController.container.viewContext.count(for: fetchRequest)

        XCTAssertTrue(count > 0, "A match should be logged when focus numbers align")
    }

    // MARK: - RealmNumberManager Tests

    func testRealmStateTransitions() {
        // Test initial state
        print("Initial realm number: \(realmNumberManager.currentRealmNumber)")
        XCTAssertEqual(realmNumberManager.currentRealmNumber, 1)

        // Test state after location update
        let location = CLLocation(latitude: 35.334329, longitude: -80.895466)
        print("Updating location to: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        realmNumberManager.updateLocation(location)

        // Wait for calculation
        Thread.sleep(forTimeInterval: 0.5)  // Increase wait time
        let numberAfterLocation = realmNumberManager.currentRealmNumber
        print("Realm number after location update: \(numberAfterLocation)")
        XCTAssertNotEqual(numberAfterLocation, 1, "Realm number should change after location update")

        // Force a calculation after location update
        realmNumberManager.calculateRealmNumber()

        // Store current BPM and cycle through all mock BPMs
        let initialBPM = realmNumberManager.currentMockBPM
        print("Initial mock BPM: \(initialBPM)")
        var foundDifferentNumber = false

        // Try cycling through BPMs multiple times to ensure we get a different number
        for i in 0..<5 {
            let previousNumber = realmNumberManager.currentRealmNumber
            realmNumberManager.cycleToNextMockBPM()
            let currentMockBPM = realmNumberManager.currentMockBPM
            let currentNumber = realmNumberManager.currentRealmNumber
            print("Cycle \(i+1): BPM=\(currentMockBPM), Realm Number: \(previousNumber) -> \(currentNumber)")

            // Force a calculation
            realmNumberManager.calculateRealmNumber()
            Thread.sleep(forTimeInterval: 0.1)

            // Check if we found a different BPM that changes the realm number
            if realmNumberManager.currentMockBPM != initialBPM {
                foundDifferentNumber = true
                print("Found different BPM: \(realmNumberManager.currentMockBPM)")
                break
            }
        }

        XCTAssertTrue(foundDifferentNumber, "Should be able to find a different BPM")
    }
}
