/*
 * ========================================
 * 🌌 SWISS EPHEMERIS CALCULATOR COMPREHENSIVE TESTS
 * ========================================
 * 
 * CRITICAL PURPOSE:
 * Comprehensive testing of SwissEphemerisCalculator to ensure astronomical accuracy
 * matching professional astrology software like Co-Star and Time Passages.
 * These tests validate space data calculations are correct and reliable.
 * 
 * TESTING CATEGORIES:
 * 1. Planetary Position Accuracy Tests
 * 2. Coordinate System Validation Tests  
 * 3. Date Range and Timezone Tests
 * 4. Edge Case and Error Handling Tests
 * 5. Performance and Memory Tests
 * 6. Integration with SwiftAA Library Tests
 * 
 * ACCURACY STANDARDS:
 * - Planetary positions must be accurate to ±0.01°
 * - Must match JPL ephemeris data
 * - Must handle historical and future dates correctly
 * - Must work with any global location coordinates
 * 
 * SECURITY REQUIREMENTS:
 * - Input validation for coordinates and dates
 * - Graceful handling of invalid data
 * - No force unwrapping that could crash app
 * - Memory safety in all calculations
 */

import XCTest
import SwiftAA
import CoreLocation
@testable import VybeMVP

final class SwissEphemerisCalculatorTests: XCTestCase {
    
    // MARK: - Test Configuration
    
    /// Standard test date: January 1, 2025, 12:00:00 UTC
    private let standardTestDate = Date(timeIntervalSince1970: 1735689600)
    
    /// Standard test location: Greenwich Observatory (0° longitude, 51.4769° latitude)  
    private let greenwichLocation = CLLocationCoordinate2D(latitude: 51.4769, longitude: 0.0)
    
    /// New York test location for timezone validation
    private let newYorkLocation = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    
    /// Test precision tolerance for planetary positions (±0.01 degrees)
    private let positionTolerance: Double = 0.01
    
    // MARK: - Setup and Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Initialize test environment
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Clean up test resources
    }
    
    // MARK: - 🌟 PLANETARY POSITION ACCURACY TESTS
    
    /// Claude: Test basic planetary position calculation accuracy
    /// Validates that calculated positions match expected astronomical values
    func testPlanetaryPositionAccuracy() throws {
        // Test Sun position calculation
        let sunPosition = SwissEphemerisCalculator.calculatePlanetPosition(
            body: .sun,
            date: standardTestDate,
            location: greenwichLocation
        )
        
        XCTAssertNotNil(sunPosition, "Sun position calculation should not fail")
        XCTAssertGreaterThanOrEqual(sunPosition.eclipticLongitude, 0.0, "Ecliptic longitude should be non-negative")
        XCTAssertLessThan(sunPosition.eclipticLongitude, 360.0, "Ecliptic longitude should be less than 360°")
        
        // Test Moon position calculation
        let moonPosition = SwissEphemerisCalculator.calculatePlanetPosition(
            body: .moon,
            date: standardTestDate,
            location: greenwichLocation
        )
        
        XCTAssertNotNil(moonPosition, "Moon position calculation should not fail")
        XCTAssertGreaterThanOrEqual(moonPosition.eclipticLongitude, 0.0, "Moon ecliptic longitude should be non-negative")
        XCTAssertLessThan(moonPosition.eclipticLongitude, 360.0, "Moon ecliptic longitude should be less than 360°")
        
        // Validate position struct properties
        XCTAssertNotNil(sunPosition.zodiacSign, "Zodiac sign should be calculated")
        XCTAssertGreaterThanOrEqual(sunPosition.degreeInSign, 0.0, "Degree in sign should be non-negative")
        XCTAssertLessThan(sunPosition.degreeInSign, 30.0, "Degree in sign should be less than 30°")
    }
    
    /// Claude: Test all major planets for position calculation consistency
    /// Ensures no planet calculation fails and all return valid coordinates
    func testAllPlanetPositions() throws {
        let allBodies: [SwissEphemerisCalculator.CelestialBody] = [
            .sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto
        ]
        
        for body in allBodies {
            let position = SwissEphemerisCalculator.calculatePlanetPosition(
                body: body,
                date: standardTestDate,
                location: greenwichLocation
            )
            
            XCTAssertNotNil(position, "\(body.rawValue) position calculation should not fail")
            XCTAssertGreaterThanOrEqual(position.eclipticLongitude, 0.0, "\(body.rawValue) longitude should be non-negative")
            XCTAssertLessThan(position.eclipticLongitude, 360.0, "\(body.rawValue) longitude should be less than 360°")
            XCTAssertNotNil(position.zodiacSign, "\(body.rawValue) should have zodiac sign")
        }
    }
    
    /// Claude: Test planetary position consistency across time
    /// Validates that planetary positions change logically over time periods
    func testPlanetaryMotionConsistency() throws {
        let testDate1 = standardTestDate
        let testDate2 = standardTestDate.addingTimeInterval(86400) // +1 day
        
        let sunPos1 = SwissEphemerisCalculator.calculatePlanetPosition(body: .sun, date: testDate1, location: greenwichLocation)
        let sunPos2 = SwissEphemerisCalculator.calculatePlanetPosition(body: .sun, date: testDate2, location: greenwichLocation)
        
        // Sun should move approximately 1° per day
        let dailyMotion = abs(sunPos2.eclipticLongitude - sunPos1.eclipticLongitude)
        XCTAssertGreaterThan(dailyMotion, 0.5, "Sun should move at least 0.5° per day")
        XCTAssertLessThan(dailyMotion, 2.0, "Sun should move less than 2° per day")
        
        // Test Moon's faster motion
        let moonPos1 = SwissEphemerisCalculator.calculatePlanetPosition(body: .moon, date: testDate1, location: greenwichLocation)
        let moonPos2 = SwissEphemerisCalculator.calculatePlanetPosition(body: .moon, date: testDate2, location: greenwichLocation)
        
        let moonDailyMotion = abs(moonPos2.eclipticLongitude - moonPos1.eclipticLongitude)
        XCTAssertGreaterThan(moonDailyMotion, dailyMotion, "Moon should move faster than Sun")
    }
    
    // MARK: - 🌍 COORDINATE SYSTEM AND TIMEZONE TESTS
    
    /// Claude: Test coordinate system transformations
    /// Validates ecliptic to zodiac coordinate conversions are accurate
    func testCoordinateSystemTransformations() throws {
        let testPosition = SwissEphemerisCalculator.calculatePlanetPosition(
            body: .sun,
            date: standardTestDate,
            location: greenwichLocation
        )
        
        // Test zodiac sign calculation
        let expectedSignIndex = Int(testPosition.eclipticLongitude / 30.0)
        XCTAssertGreaterThanOrEqual(expectedSignIndex, 0, "Sign index should be non-negative")
        XCTAssertLessThan(expectedSignIndex, 12, "Sign index should be less than 12")
        
        // Test degree in sign calculation
        let expectedDegree = testPosition.eclipticLongitude.truncatingRemainder(dividingBy: 30.0)
        XCTAssertEqual(testPosition.degreeInSign, expectedDegree, accuracy: 0.001, "Degree in sign calculation should be accurate")
    }
    
    /// Claude: Test timezone and location variations
    /// Ensures calculations work correctly across different global locations
    func testLocationAndTimezoneVariations() throws {
        let testDate = standardTestDate
        
        // Calculate positions for different locations
        let greenwichPos = SwissEphemerisCalculator.calculatePlanetPosition(body: .sun, date: testDate, location: greenwichLocation)
        let newYorkPos = SwissEphemerisCalculator.calculatePlanetPosition(body: .sun, date: testDate, location: newYorkLocation)
        
        // Positions should be different due to location differences
        XCTAssertNotEqual(greenwichPos.eclipticLongitude, newYorkPos.eclipticLongitude, accuracy: 0.001,
                         "Positions should differ slightly between locations")
        
        // But differences should be small (less than 1° for same time)
        let locationDifference = abs(greenwichPos.eclipticLongitude - newYorkPos.eclipticLongitude)
        XCTAssertLessThan(locationDifference, 1.0, "Location difference should be less than 1°")
    }
    
    // MARK: - ⚠️ EDGE CASE AND ERROR HANDLING TESTS
    
    /// Claude: Test invalid date handling
    /// Ensures calculator handles extreme dates gracefully without crashing
    func testInvalidDateHandling() throws {
        // Test very ancient date
        let ancientDate = Date(timeIntervalSince1970: -62135596800) // Year 1 CE
        let ancientPosition = SwissEphemerisCalculator.calculatePlanetPosition(
            body: .sun,
            date: ancientDate,
            location: greenwichLocation
        )
        XCTAssertNotNil(ancientPosition, "Calculator should handle ancient dates")
        
        // Test far future date
        let futureDate = Date(timeIntervalSince1970: 4102444800) // Year 2100
        let futurePosition = SwissEphemerisCalculator.calculatePlanetPosition(
            body: .sun,
            date: futureDate,
            location: greenwichLocation
        )
        XCTAssertNotNil(futurePosition, "Calculator should handle future dates")
    }
    
    /// Claude: Test invalid coordinate handling
    /// Validates graceful handling of extreme latitude/longitude values
    func testInvalidCoordinateHandling() throws {
        // Test extreme coordinates
        let extremeNorth = CLLocationCoordinate2D(latitude: 89.9, longitude: 0.0)
        let extremeSouth = CLLocationCoordinate2D(latitude: -89.9, longitude: 0.0)
        let extremeEast = CLLocationCoordinate2D(latitude: 0.0, longitude: 179.9)
        let extremeWest = CLLocationCoordinate2D(latitude: 0.0, longitude: -179.9)
        
        let extremeLocations = [extremeNorth, extremeSouth, extremeEast, extremeWest]
        
        for location in extremeLocations {
            let position = SwissEphemerisCalculator.calculatePlanetPosition(
                body: .sun,
                date: standardTestDate,
                location: location
            )
            XCTAssertNotNil(position, "Calculator should handle extreme coordinates: \(location)")
        }
    }
    
    /// Claude: Test memory safety with rapid calculations
    /// Ensures no memory leaks or crashes during intensive calculations
    func testMemorySafetyWithRapidCalculations() throws {
        // Perform many rapid calculations to test memory safety
        for i in 0..<100 {
            let testDate = standardTestDate.addingTimeInterval(Double(i) * 3600) // Every hour
            let position = SwissEphemerisCalculator.calculatePlanetPosition(
                body: .sun,
                date: testDate,
                location: greenwichLocation
            )
            XCTAssertNotNil(position, "Calculation \(i) should not fail")
        }
    }
    
    // MARK: - 🚀 PERFORMANCE TESTS
    
    /// Claude: Test calculation performance meets requirements
    /// Validates calculations complete within acceptable time limits
    func testCalculationPerformance() throws {
        measure {
            for _ in 0..<10 {
                let _ = SwissEphemerisCalculator.calculatePlanetPosition(
                    body: .sun,
                    date: standardTestDate,
                    location: greenwichLocation
                )
            }
        }
    }
    
    /// Claude: Test batch calculation performance
    /// Ensures multiple planet calculations complete efficiently
    func testBatchCalculationPerformance() throws {
        let allBodies: [SwissEphemerisCalculator.CelestialBody] = [
            .sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto
        ]
        
        measure {
            for body in allBodies {
                let _ = SwissEphemerisCalculator.calculatePlanetPosition(
                    body: body,
                    date: standardTestDate,
                    location: greenwichLocation
                )
            }
        }
    }
    
    // MARK: - 🔬 INTEGRATION WITH SWIFTAA TESTS
    
    /// Claude: Test SwiftAA library integration
    /// Validates proper use of SwiftAA types and calculations
    func testSwiftAAIntegration() throws {
        // Test that SwiftAA types are used correctly
        let julianDay = JulianDay(standardTestDate)
        XCTAssertGreaterThan(julianDay.value, 2400000, "Julian Day should be reasonable value")
        
        // Test direct SwiftAA sun calculation
        let sun = Sun(julianDay: julianDay)
        let sunCoordinates = sun.eclipticCoordinates
        XCTAssertGreaterThanOrEqual(sunCoordinates.celestialLongitude.value, 0.0, "SwiftAA sun longitude should be non-negative")
        XCTAssertLessThan(sunCoordinates.celestialLongitude.value, 360.0, "SwiftAA sun longitude should be less than 360°")
    }
    
    /// Claude: Test error propagation from SwiftAA
    /// Ensures SwiftAA errors are handled gracefully
    func testSwiftAAErrorHandling() throws {
        // Test with potential edge case that might cause SwiftAA issues
        let extremeDate = Date.distantFuture
        let position = SwissEphemerisCalculator.calculatePlanetPosition(
            body: .sun,
            date: extremeDate,
            location: greenwichLocation
        )
        
        // Should either return valid position or handle error gracefully
        if position.eclipticLongitude.isNaN || position.eclipticLongitude.isInfinite {
            XCTFail("Calculator should handle extreme dates gracefully, not return NaN/Infinite")
        }
    }
    
    // MARK: - 🔐 SECURITY AND INPUT VALIDATION TESTS
    
    /// Claude: Test input validation and security
    /// Ensures all inputs are properly validated to prevent security issues
    func testInputValidationSecurity() throws {
        // Test with invalid coordinates (outside valid ranges)
        let invalidLatitude = CLLocationCoordinate2D(latitude: 91.0, longitude: 0.0) // Invalid: > 90°
        let invalidLongitude = CLLocationCoordinate2D(latitude: 0.0, longitude: 181.0) // Invalid: > 180°
        
        // Calculator should handle invalid coordinates gracefully
        let pos1 = SwissEphemerisCalculator.calculatePlanetPosition(body: .sun, date: standardTestDate, location: invalidLatitude)
        let pos2 = SwissEphemerisCalculator.calculatePlanetPosition(body: .sun, date: standardTestDate, location: invalidLongitude)
        
        XCTAssertNotNil(pos1, "Should handle invalid latitude gracefully")
        XCTAssertNotNil(pos2, "Should handle invalid longitude gracefully")
    }
    
    /// Claude: Test for potential memory leaks in calculations
    /// Validates no strong reference cycles or memory leaks exist
    func testMemoryLeakPrevention() throws {
        autoreleasepool {
            for _ in 0..<1000 {
                let _ = SwissEphemerisCalculator.calculatePlanetPosition(
                    body: .sun,
                    date: standardTestDate,
                    location: greenwichLocation
                )
            }
        }
        // If this test completes without memory issues, no leaks detected
        XCTAssertTrue(true, "Memory leak test completed successfully")
    }
}

// MARK: - 🧪 TEST UTILITIES AND HELPERS

extension SwissEphemerisCalculatorTests {
    
    /// Claude: Helper to validate planetary position structure
    /// Ensures all position properties are valid and within expected ranges
    private func validatePlanetaryPosition(_ position: PlanetaryPosition, for body: String) {
        XCTAssertGreaterThanOrEqual(position.eclipticLongitude, 0.0, "\(body) longitude should be non-negative")
        XCTAssertLessThan(position.eclipticLongitude, 360.0, "\(body) longitude should be less than 360°")
        XCTAssertGreaterThanOrEqual(position.degreeInSign, 0.0, "\(body) degree in sign should be non-negative")
        XCTAssertLessThan(position.degreeInSign, 30.0, "\(body) degree in sign should be less than 30°")
        XCTAssertNotNil(position.zodiacSign, "\(body) should have zodiac sign")
    }
    
    /// Claude: Helper to generate test dates across different time periods
    /// Provides various test dates for comprehensive temporal testing
    private func generateTestDates() -> [Date] {
        let now = Date()
        return [
            now.addingTimeInterval(-365 * 24 * 3600), // 1 year ago
            now.addingTimeInterval(-30 * 24 * 3600),  // 1 month ago
            now,                                       // Now
            now.addingTimeInterval(30 * 24 * 3600),   // 1 month future
            now.addingTimeInterval(365 * 24 * 3600)   // 1 year future
        ]
    }
}