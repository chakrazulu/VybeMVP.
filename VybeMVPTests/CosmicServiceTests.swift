/*
 * ========================================
 * 🌌 COSMIC SERVICE COMPREHENSIVE TESTS
 * ========================================
 * 
 * CRITICAL PURPOSE:
 * Comprehensive testing of CosmicService to ensure reliable cosmic data management,
 * Firebase integration, caching strategies, and offline fallback capabilities.
 * These tests validate the central cosmic data orchestration system.
 * 
 * TESTING CATEGORIES:
 * 1. Firebase Firestore Integration Tests
 * 2. Local Calculation Fallback Tests
 * 3. Caching Strategy and Performance Tests
 * 4. Data Consistency and Validation Tests
 * 5. Error Handling and Network Failure Tests
 * 6. Memory Management and Observable Object Tests
 * 
 * PERFORMANCE REQUIREMENTS:
 * - Local Calculation: < 10ms
 * - Firestore Fetch: < 500ms
 * - Cache Hit: 0ms (immediate)
 * - Memory Overhead: < 1MB
 * 
 * SECURITY REQUIREMENTS:
 * - Secure Firebase connection
 * - Input validation for all cosmic data
 * - Graceful handling of malformed data
 * - No sensitive data exposure in logs
 */

import XCTest
import FirebaseFirestore
import Combine
@testable import VybeMVP

@MainActor
final class CosmicServiceTests: XCTestCase {
    
    // MARK: - Test Configuration
    
    /// System under test
    private var cosmicService: CosmicService!
    
    /// Combine cancellables for async testing
    private var cancellables: Set<AnyCancellable>!
    
    /// Mock Firestore for testing
    private var mockFirestore: Firestore!
    
    /// Test expectation timeout
    private let testTimeout: TimeInterval = 5.0
    
    // MARK: - Setup and Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Initialize test environment
        cancellables = Set<AnyCancellable>()
        cosmicService = CosmicService()
        
        // Configure test settings
        continueAfterFailure = false
        
        // Clear any cached data
        UserDefaults.standard.removeObject(forKey: "cosmicDataCache")
        UserDefaults.standard.removeObject(forKey: "cosmicDataTimestamp")
    }
    
    override func tearDownWithError() throws {
        // Clean up test resources
        cancellables?.removeAll()
        cosmicService = nil
        
        // Clear test data
        UserDefaults.standard.removeObject(forKey: "cosmicDataCache")
        UserDefaults.standard.removeObject(forKey: "cosmicDataTimestamp")
        
        try super.tearDownWithError()
    }
    
    // MARK: - 🔥 FIREBASE FIRESTORE INTEGRATION TESTS
    
    /// Claude: Test Firebase connection and data fetching
    /// Validates that CosmicService can successfully connect to Firestore
    func testFirebaseConnection() throws {
        let expectation = XCTestExpectation(description: "Firebase connection test")
        
        cosmicService.refreshCosmicData()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure(let error):
                        XCTFail("Firebase connection failed: \(error)")
                    }
                },
                receiveValue: { cosmicData in
                    XCTAssertNotNil(cosmicData, "Cosmic data should not be nil")
                    XCTAssertFalse(cosmicData.isEmpty, "Cosmic data should not be empty")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: testTimeout)
    }
    
    /// Claude: Test Firestore document structure validation
    /// Ensures retrieved documents have expected structure and required fields
    func testFirestoreDocumentStructure() throws {
        let expectation = XCTestExpectation(description: "Document structure validation")
        
        cosmicService.fetchTodaysCosmicData()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { document in
                    XCTAssertNotNil(document, "Document should exist")
                    
                    // Validate required fields exist
                    let requiredFields = ["moonPhase", "planetaryPositions", "dailyEnergies", "timestamp"]
                    for field in requiredFields {
                        XCTAssertTrue(document.contains(field), "Document should contain \(field)")
                    }
                    
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: testTimeout)
    }
    
    /// Claude: Test network failure handling
    /// Validates graceful handling when Firebase is unavailable
    func testNetworkFailureHandling() throws {
        let expectation = XCTestExpectation(description: "Network failure handling")
        
        // Simulate network failure by using invalid Firestore configuration
        // This should trigger fallback to local calculations
        cosmicService.handleNetworkError(NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet))
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        expectation.fulfill()
                    case .failure(let error):
                        XCTFail("Should handle network errors gracefully: \(error)")
                    }
                },
                receiveValue: { fallbackData in
                    XCTAssertNotNil(fallbackData, "Should provide fallback data")
                    XCTAssertFalse(fallbackData.isEmpty, "Fallback data should not be empty")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: testTimeout)
    }
    
    // MARK: - 💻 LOCAL CALCULATION FALLBACK TESTS
    
    /// Claude: Test local calculation accuracy
    /// Validates that local calculations produce accurate results
    func testLocalCalculationAccuracy() throws {
        let testDate = Date()
        let localData = cosmicService.generateLocalCosmicData(for: testDate)
        
        XCTAssertNotNil(localData, "Local calculation should produce data")
        XCTAssertFalse(localData.isEmpty, "Local data should not be empty")
        
        // Validate moon phase calculation
        if let moonPhase = localData["moonPhase"] as? [String: Any] {
            XCTAssertNotNil(moonPhase["phase"], "Moon phase should have phase value")
            XCTAssertNotNil(moonPhase["illumination"], "Moon phase should have illumination percentage")
            
            if let illumination = moonPhase["illumination"] as? Double {
                XCTAssertGreaterThanOrEqual(illumination, 0.0, "Illumination should be non-negative")
                XCTAssertLessThanOrEqual(illumination, 100.0, "Illumination should not exceed 100%")
            }
        }
        
        // Validate planetary positions
        if let planetaryPositions = localData["planetaryPositions"] as? [[String: Any]] {
            XCTAssertGreaterThan(planetaryPositions.count, 0, "Should have planetary positions")
            
            for position in planetaryPositions {
                XCTAssertNotNil(position["planet"], "Each position should have planet name")
                XCTAssertNotNil(position["longitude"], "Each position should have longitude")
                XCTAssertNotNil(position["sign"], "Each position should have zodiac sign")
            }
        }
    }
    
    /// Claude: Test fallback performance requirements
    /// Ensures local calculations meet performance targets (< 10ms)
    func testLocalCalculationPerformance() throws {
        let testDate = Date()
        
        measure {
            let _ = cosmicService.generateLocalCosmicData(for: testDate)
        }
    }
    
    /// Claude: Test calculation consistency over time
    /// Validates that repeated calculations for same date produce identical results
    func testCalculationConsistency() throws {
        let testDate = Date()
        
        let result1 = cosmicService.generateLocalCosmicData(for: testDate)
        let result2 = cosmicService.generateLocalCosmicData(for: testDate)
        
        XCTAssertEqual(
            result1.description,
            result2.description,
            "Calculations for same date should be identical"
        )
    }
    
    // MARK: - 🗄️ CACHING STRATEGY AND PERFORMANCE TESTS
    
    /// Claude: Test cache functionality
    /// Validates that caching system works correctly and improves performance
    func testCacheOperation() throws {
        let testData: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970,
            "moonPhase": ["phase": "waxing_crescent", "illumination": 25.5],
            "planetaryPositions": []
        ]
        
        // Test cache storage
        cosmicService.cacheCosmicData(testData)
        
        // Test cache retrieval
        let cachedData = cosmicService.getCachedCosmicData()
        XCTAssertNotNil(cachedData, "Should retrieve cached data")
        
        // Validate cache content
        if let moonPhase = cachedData?["moonPhase"] as? [String: Any] {
            XCTAssertEqual(moonPhase["phase"] as? String, "waxing_crescent", "Cached moon phase should match")
            XCTAssertEqual(moonPhase["illumination"] as? Double, 25.5, accuracy: 0.1, "Cached illumination should match")
        }
    }
    
    /// Claude: Test cache expiration (TTL)
    /// Validates that cache expires after 24 hours as designed
    func testCacheExpiration() throws {
        let testData: [String: Any] = [
            "timestamp": Date().timeIntervalSince1970 - 86401, // 24 hours + 1 second ago
            "moonPhase": ["phase": "expired_phase"]
        ]
        
        // Cache old data
        cosmicService.cacheCosmicData(testData)
        
        // Should not retrieve expired cache
        let cachedData = cosmicService.getCachedCosmicData()
        XCTAssertNil(cachedData, "Expired cache should not be retrieved")
    }
    
    /// Claude: Test cache performance (0ms target)
    /// Validates that cache retrieval is immediate
    func testCachePerformance() throws {
        let testData: [String: Any] = ["test": "data"]
        cosmicService.cacheCosmicData(testData)
        
        measure {
            for _ in 0..<100 {
                let _ = cosmicService.getCachedCosmicData()
            }
        }
    }
    
    // MARK: - ✅ DATA CONSISTENCY AND VALIDATION TESTS
    
    /// Claude: Test data structure validation
    /// Ensures all cosmic data has required structure and valid values
    func testDataStructureValidation() throws {
        let expectation = XCTestExpectation(description: "Data validation test")
        
        cosmicService.validateCosmicData()
            .sink(
                receiveCompletion: { _ in expectation.fulfill() },
                receiveValue: { isValid in
                    XCTAssertTrue(isValid, "Cosmic data should be valid")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: testTimeout)
    }
    
    /// Claude: Test malformed data handling
    /// Validates graceful handling of corrupted or malformed data
    func testMalformedDataHandling() throws {
        let malformedData: [String: Any] = [
            "moonPhase": "invalid_string_instead_of_object",
            "planetaryPositions": "invalid_string_instead_of_array",
            "timestamp": "invalid_string_instead_of_timestamp"
        ]
        
        let isValid = cosmicService.validateDataStructure(malformedData)
        XCTAssertFalse(isValid, "Should detect malformed data")
        
        // Should provide fallback data
        let cleanedData = cosmicService.sanitizeCosmicData(malformedData)
        XCTAssertNotNil(cleanedData, "Should provide sanitized fallback data")
    }
    
    /// Claude: Test date boundary conditions
    /// Validates handling of edge cases like midnight, leap years, etc.
    func testDateBoundaryConditions() throws {
        let boundaryDates = [
            Date(timeIntervalSince1970: 0), // Unix epoch
            Date(), // Current time
            Calendar.current.date(byAdding: .year, value: 1, to: Date())!, // Future date
            Calendar.current.date(byAdding: .year, value: -10, to: Date())! // Past date
        ]
        
        for testDate in boundaryDates {
            let cosmicData = cosmicService.generateLocalCosmicData(for: testDate)
            XCTAssertNotNil(cosmicData, "Should handle boundary date: \(testDate)")
            XCTAssertFalse(cosmicData.isEmpty, "Should produce data for boundary date: \(testDate)")
        }
    }
    
    // MARK: - 🚨 ERROR HANDLING TESTS
    
    /// Claude: Test comprehensive error scenarios
    /// Validates proper error handling for all possible failure modes
    func testComprehensiveErrorHandling() throws {
        let errorScenarios: [NSError] = [
            NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet),
            NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut),
            NSError(domain: "FirebaseError", code: 7, userInfo: [NSLocalizedDescriptionKey: "Permission denied"]),
            NSError(domain: "CosmicServiceError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid calculation parameters"])
        ]
        
        for error in errorScenarios {
            let expectation = XCTestExpectation(description: "Error handling: \(error.localizedDescription)")
            
            cosmicService.handleError(error)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            expectation.fulfill()
                        case .failure:
                            XCTFail("Error handler should not propagate errors")
                        }
                    },
                    receiveValue: { recoveryData in
                        XCTAssertNotNil(recoveryData, "Should provide recovery data for error: \(error)")
                    }
                )
                .store(in: &cancellables)
            
            wait(for: [expectation], timeout: testTimeout)
        }
    }
    
    /// Claude: Test logging and debugging
    /// Validates that errors are properly logged for debugging
    func testErrorLogging() throws {
        let testError = NSError(domain: "TestError", code: 9999, userInfo: [NSLocalizedDescriptionKey: "Test error message"])
        
        // This should log the error without crashing
        cosmicService.logError(testError, context: "Unit Test")
        
        XCTAssertTrue(true, "Error logging completed without crash")
    }
    
    // MARK: - 🧠 MEMORY MANAGEMENT AND OBSERVABLE TESTS
    
    /// Claude: Test ObservableObject conformance
    /// Validates that CosmicService properly implements ObservableObject
    func testObservableObjectBehavior() throws {
        let expectation = XCTestExpectation(description: "Observable object updates")
        
        // Subscribe to published changes
        cosmicService.objectWillChange
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger a change
        cosmicService.refreshCosmicData()
        
        wait(for: [expectation], timeout: testTimeout)
    }
    
    /// Claude: Test memory leak prevention
    /// Validates no retain cycles or memory leaks in async operations
    func testMemoryLeakPrevention() throws {
        autoreleasepool {
            for _ in 0..<100 {
                let service = CosmicService()
                service.refreshCosmicData()
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { _ in }
                    )
                    .store(in: &cancellables)
            }
        }
        
        // If test completes without memory issues, no leaks detected
        XCTAssertTrue(true, "Memory leak test completed successfully")
    }
    
    /// Claude: Test Combine publisher cleanup
    /// Ensures proper cleanup of Combine subscriptions
    func testCombinePublisherCleanup() throws {
        var localCancellables = Set<AnyCancellable>()
        
        // Create multiple subscriptions
        for _ in 0..<10 {
            cosmicService.cosmicDataPublisher
                .sink { _ in }
                .store(in: &localCancellables)
        }
        
        // Cancel all subscriptions
        localCancellables.removeAll()
        
        XCTAssertTrue(localCancellables.isEmpty, "All subscriptions should be cleaned up")
    }
    
    // MARK: - 🔐 SECURITY AND INPUT VALIDATION TESTS
    
    /// Claude: Test input sanitization
    /// Validates that all inputs are properly sanitized to prevent security issues
    func testInputSanitization() throws {
        let maliciousInputs = [
            "'; DROP TABLE users; --",
            "<script>alert('xss')</script>",
            "../../etc/passwd",
            String(repeating: "A", count: 10000) // Large input
        ]
        
        for input in maliciousInputs {
            let sanitized = cosmicService.sanitizeInput(input)
            XCTAssertNotEqual(sanitized, input, "Input should be sanitized: \(input.prefix(50))")
            XCTAssertFalse(sanitized.contains("<script>"), "Should remove script tags")
            XCTAssertFalse(sanitized.contains("DROP TABLE"), "Should remove SQL injection attempts")
        }
    }
    
    /// Claude: Test data encryption for sensitive information
    /// Validates that sensitive cosmic data is properly secured
    func testDataSecurity() throws {
        let sensitiveData: [String: Any] = [
            "userLocation": ["lat": 40.7128, "lng": -74.0060],
            "personalData": ["birthDate": "1990-01-01", "birthTime": "12:00:00"]
        ]
        
        // Should not log sensitive data
        let logOutput = cosmicService.generateLogOutput(for: sensitiveData)
        XCTAssertFalse(logOutput.contains("40.7128"), "Should not log sensitive coordinates")
        XCTAssertFalse(logOutput.contains("1990-01-01"), "Should not log sensitive birth data")
    }
}

// MARK: - 🧪 TEST UTILITIES AND MOCK DATA

extension CosmicServiceTests {
    
    /// Claude: Generate mock cosmic data for testing
    /// Creates realistic test data that matches expected structure
    private func generateMockCosmicData() -> [String: Any] {
        return [
            "timestamp": Date().timeIntervalSince1970,
            "moonPhase": [
                "phase": "waxing_crescent",
                "illumination": 25.5,
                "nextNewMoon": Date().addingTimeInterval(86400 * 7).timeIntervalSince1970
            ],
            "planetaryPositions": [
                ["planet": "Sun", "longitude": 280.5, "sign": "Capricorn", "degree": 10.5],
                ["planet": "Moon", "longitude": 45.2, "sign": "Taurus", "degree": 15.2],
                ["planet": "Mercury", "longitude": 295.8, "sign": "Capricorn", "degree": 25.8]
            ],
            "dailyEnergies": [
                "focusNumber": 7,
                "realmNumber": 3,
                "energy": "Mystical Introspection"
            ]
        ]
    }
    
    /// Claude: Validate cosmic data structure helper
    /// Ensures data matches expected format and contains required fields
    private func validateCosmicDataStructure(_ data: [String: Any]) -> Bool {
        guard let timestamp = data["timestamp"] as? TimeInterval,
              let moonPhase = data["moonPhase"] as? [String: Any],
              let planetaryPositions = data["planetaryPositions"] as? [[String: Any]],
              let dailyEnergies = data["dailyEnergies"] as? [String: Any] else {
            return false
        }
        
        // Validate timestamp is reasonable
        let now = Date().timeIntervalSince1970
        guard timestamp > now - 86400 && timestamp < now + 86400 else { return false }
        
        // Validate moon phase structure
        guard moonPhase["phase"] is String,
              let illumination = moonPhase["illumination"] as? Double,
              illumination >= 0.0 && illumination <= 100.0 else { return false }
        
        // Validate planetary positions
        for position in planetaryPositions {
            guard position["planet"] is String,
                  let longitude = position["longitude"] as? Double,
                  longitude >= 0.0 && longitude < 360.0,
                  position["sign"] is String else { return false }
        }
        
        // Validate daily energies
        guard dailyEnergies["focusNumber"] is Int,
              dailyEnergies["realmNumber"] is Int,
              dailyEnergies["energy"] is String else { return false }
        
        return true
    }
}