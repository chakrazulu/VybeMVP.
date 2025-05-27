//
//  ArchetypeTests.swift
//  VybeMVPTests
//
//  Created by Corey Davis on 1/12/25.
//

import XCTest
@testable import VybeMVP

/**
 * Test suite for User Archetype and Resonance Engine functionality.
 *
 * These tests verify the core spiritual identity calculation and
 * local resonance detection systems work correctly.
 */
final class ArchetypeTests: XCTestCase {
    
    var archetypeManager: UserArchetypeManager!
    var resonanceEngine: ResonanceEngine!
    
    override func setUpWithError() throws {
        archetypeManager = UserArchetypeManager.shared
        resonanceEngine = ResonanceEngine.shared
        
        // Clear any cached data for clean tests
        archetypeManager.clearArchetype()
        resonanceEngine.clearAllMatches()
    }
    
    override func tearDownWithError() throws {
        archetypeManager = nil
        resonanceEngine = nil
    }
    
    // MARK: - Life Path Calculation Tests
    
    func testLifePathCalculation() throws {
        // Test date: June 15, 1990 (1+9+9+0 + 6 + 1+5 = 31 → 3+1 = 4)
        let testDate = Calendar.current.date(from: DateComponents(year: 1990, month: 6, day: 15))!
        let archetype = archetypeManager.calculateArchetype(from: testDate)
        
        XCTAssertEqual(archetype.lifePath, 4, "Life path calculation should be correct")
        XCTAssertEqual(archetype.zodiacSign, .gemini, "Zodiac sign should be Gemini for June 15")
        XCTAssertEqual(archetype.element, .air, "Gemini should be air element")
        XCTAssertEqual(archetype.primaryPlanet, .uranus, "Life Path 4 should have Uranus as primary")
        XCTAssertEqual(archetype.subconsciousPlanet, .moon, "Life Path 4 should have Moon as subconscious")
    }
    
    func testMasterNumberCalculation() throws {
        // Test date that results in master number 11
        // Example: March 29, 1965 (1+9+6+5 + 3 + 2+9 = 35, 3+5 = 8... let's find a real 11)
        // November 2, 1992: 1+9+9+2 + 1+1 + 2 = 25 → 2+5 = 7 (not 11)
        // Let's try February 2, 1990: 1+9+9+0 + 2 + 2 = 23 → 2+3 = 5 (not 11)
        // Try November 29, 1973: 1+9+7+3 + 1+1 + 2+9 = 33 → 3+3 = 6 (not 11)
        // February 20, 1999: 1+9+9+9 + 2 + 2+0 = 32 → 3+2 = 5 (not 11)
        
        // Let's construct a date that gives us 11: need sum of 29 or 38 or 47
        // November 11, 1999: 1+9+9+9 + 1+1 + 1+1 = 32 → 3+2 = 5 (not 11)
        // Need to get to 29: year(19)+month+day = 29, so month+day = 10
        // January 9, 1999: 1+9+9+9 + 1 + 9 = 38 → 3+8 = 11 ✓
        
        let testDate = Calendar.current.date(from: DateComponents(year: 1999, month: 1, day: 9))!
        let archetype = archetypeManager.calculateArchetype(from: testDate)
        
        XCTAssertEqual(archetype.lifePath, 11, "Should calculate master number 11")
        XCTAssertEqual(archetype.primaryPlanet, .moon, "Master number 11 should have Moon as primary")
        XCTAssertEqual(archetype.subconsciousPlanet, .uranus, "Master number 11 should have Uranus as subconscious")
    }
    
    // MARK: - Zodiac and Element Tests
    
    func testZodiacSignCalculation() throws {
        let testCases: [(month: Int, day: Int, expectedSign: ZodiacSign)] = [
            (3, 21, .aries),      // First day of Aries
            (4, 19, .aries),      // Last day of Aries
            (4, 20, .taurus),     // First day of Taurus
            (6, 21, .cancer),     // First day of Cancer
            (12, 22, .capricorn), // First day of Capricorn
            (2, 18, .aquarius),   // Last day of Aquarius
            (2, 19, .pisces)      // First day of Pisces
        ]
        
        for testCase in testCases {
            let testDate = Calendar.current.date(from: DateComponents(year: 2000, month: testCase.month, day: testCase.day))!
            let archetype = archetypeManager.calculateArchetype(from: testDate)
            
            XCTAssertEqual(archetype.zodiacSign, testCase.expectedSign, 
                          "Date \(testCase.month)/\(testCase.day) should be \(testCase.expectedSign)")
        }
    }
    
    func testElementAlignment() throws {
        // Test each element
        let fireDate = Calendar.current.date(from: DateComponents(year: 2000, month: 3, day: 25))! // Aries
        let earthDate = Calendar.current.date(from: DateComponents(year: 2000, month: 5, day: 5))! // Taurus
        let airDate = Calendar.current.date(from: DateComponents(year: 2000, month: 6, day: 5))! // Gemini
        let waterDate = Calendar.current.date(from: DateComponents(year: 2000, month: 7, day: 5))! // Cancer
        
        let fireArchetype = archetypeManager.calculateArchetype(from: fireDate)
        let earthArchetype = archetypeManager.calculateArchetype(from: earthDate)
        let airArchetype = archetypeManager.calculateArchetype(from: airDate)
        let waterArchetype = archetypeManager.calculateArchetype(from: waterDate)
        
        XCTAssertEqual(fireArchetype.element, .fire)
        XCTAssertEqual(earthArchetype.element, .earth)
        XCTAssertEqual(airArchetype.element, .air)
        XCTAssertEqual(waterArchetype.element, .water)
    }
    
    // MARK: - Archetype Caching Tests
    
    func testArchetypeCaching() throws {
        let testDate = Calendar.current.date(from: DateComponents(year: 1990, month: 6, day: 15))!
        
        // Calculate archetype
        let archetype1 = archetypeManager.calculateArchetype(from: testDate)
        
        // Load from cache
        let cachedArchetype = archetypeManager.loadCachedArchetype()
        
        XCTAssertNotNil(cachedArchetype, "Should load cached archetype")
        XCTAssertEqual(cachedArchetype?.lifePath, archetype1.lifePath)
        XCTAssertEqual(cachedArchetype?.zodiacSign, archetype1.zodiacSign)
        XCTAssertEqual(cachedArchetype?.element, archetype1.element)
        XCTAssertEqual(cachedArchetype?.primaryPlanet, archetype1.primaryPlanet)
        XCTAssertEqual(cachedArchetype?.subconsciousPlanet, archetype1.subconsciousPlanet)
    }
    
    // MARK: - Resonance Engine Tests
    
    func testFocusRealmAlignment() throws {
        let testArchetype = UserArchetype(
            lifePath: 7,
            zodiacSign: .gemini,
            element: .air,
            primaryPlanet: .neptune,
            subconsciousPlanet: .jupiter,
            calculatedDate: Date()
        )
        
        // Test perfect alignment
        resonanceEngine.analyzeCurrentResonance(
            focusNumber: 7,
            realmNumber: 7,
            archetype: testArchetype
        )
        
        let matches = resonanceEngine.getTodaysMatches()
        XCTAssertTrue(matches.contains { $0.type == .focusRealmAlignment }, 
                     "Should detect focus-realm alignment")
        
        let alignmentMatch = matches.first { $0.type == .focusRealmAlignment }
        XCTAssertEqual(alignmentMatch?.intensity, 1.0, "Perfect alignment should have maximum intensity")
    }
    
    func testNumericalHarmony() throws {
        let testArchetype = UserArchetype(
            lifePath: 5,
            zodiacSign: .gemini,
            element: .air,
            primaryPlanet: .mercury,
            subconsciousPlanet: .neptune,
            calculatedDate: Date()
        )
        
        // Test complementary numbers (add to 10)
        resonanceEngine.analyzeCurrentResonance(
            focusNumber: 3,
            realmNumber: 7,  // 3 + 7 = 10
            archetype: testArchetype
        )
        
        let matches = resonanceEngine.getTodaysMatches()
        let harmonyMatch = matches.first { $0.type == .numericalHarmony }
        
        XCTAssertNotNil(harmonyMatch, "Should detect numerical harmony for complementary numbers")
        XCTAssertTrue(harmonyMatch!.intensity > 0.0, "Harmony should have positive intensity")
    }
    
    func testSequentialMagic() throws {
        // Test sequential numbers
        resonanceEngine.analyzeCurrentResonance(
            focusNumber: 5,
            realmNumber: 6,  // Sequential: 5, 6
            archetype: nil
        )
        
        let matches = resonanceEngine.getTodaysMatches()
        let sequenceMatch = matches.first { $0.type == .sequentialMagic }
        
        XCTAssertNotNil(sequenceMatch, "Should detect sequential magic for consecutive numbers")
    }
    
    func testResonanceMatchProperties() throws {
        let match = ResonanceMatch.focusRealmAlignment(focusNumber: 8, realmNumber: 8)
        
        XCTAssertEqual(match.type, .focusRealmAlignment)
        XCTAssertEqual(match.title, "Perfect Alignment")
        XCTAssertEqual(match.subtitle, "Focus ↔ Realm")
        XCTAssertEqual(match.intensityPercentage, "100%")
        XCTAssertTrue(match.involvedNumbers.contains(8))
    }
    
    // MARK: - Performance Tests
    
    func testArchetypeCalculationPerformance() throws {
        let testDate = Calendar.current.date(from: DateComponents(year: 1990, month: 6, day: 15))!
        
        measure {
            // This should be fast
            for _ in 0..<100 {
                _ = archetypeManager.calculateArchetype(from: testDate)
            }
        }
    }
    
    func testResonanceAnalysisPerformance() throws {
        let testArchetype = UserArchetype(
            lifePath: 7,
            zodiacSign: .gemini,
            element: .air,
            primaryPlanet: .neptune,
            subconsciousPlanet: .jupiter,
            calculatedDate: Date()
        )
        
        measure {
            // This should also be fast
            for i in 1...100 {
                resonanceEngine.analyzeCurrentResonance(
                    focusNumber: i % 9 + 1,
                    realmNumber: (i + 1) % 9 + 1,
                    archetype: testArchetype
                )
            }
        }
    }
} 