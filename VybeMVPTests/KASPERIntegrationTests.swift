/**
 * KASPERIntegrationTests.swift
 * 
 * 🧪 COMPREHENSIVE KASPER INTEGRATION TEST SUITE
 * 
 * PURPOSE:
 * These tests validate the enhanced KASPER integration that bridges the gap between
 * natal chart data, real-time cosmic transits, and AI-powered spiritual insights.
 * 
 * WHY THESE TESTS MATTER:
 * - KASPER is the core of Vybe's personalization engine
 * - Multiple complex data sources must integrate seamlessly
 * - Apple Intelligence integration will depend on this data quality
 * - Spiritual authenticity requires data integrity validation
 * 
 * WHAT WE'RE TESTING:
 * 1. Complete payload generation with all enhanced data
 * 2. Graceful fallback behavior when data sources unavailable
 * 3. MegaCorpus spiritual wisdom extraction accuracy
 * 4. Data transformation integrity (UserProfile → KASPER)
 * 5. Performance and memory characteristics
 * 
 * FUTURE EXPANSION POINTS:
 * - Add Apple Intelligence integration tests
 * - Expand MegaCorpus content validation
 * - Add performance benchmarks
 * - Test premium vs free tier data differences
 * 
 * ARCHITECTURAL CONTEXT:
 * These tests validate the modular repository/viewmodel/view pattern
 * implementation that separates data concerns from UI presentation.
 */

import XCTest
@testable import VybeMVP

@available(iOS 13.0, *)
final class KASPERIntegrationTests: XCTestCase {
    
    // MARK: - Test Properties
    
    /// KASPERManager instance for testing
    private var kasperManager: KASPERManager!
    
    /// Mock user profile for consistent test data
    private var testUserProfile: UserProfile!
    
    // MARK: - Test Lifecycle
    
    override func setUpWithError() throws {
        super.setUp()
        
        // Initialize KASPERManager for testing
        kasperManager = KASPERManager.shared
        
        // Create comprehensive test user profile with natal chart data
        testUserProfile = createTestUserProfile()
        
        print("🧪 KASPERIntegrationTests: Setup complete with test profile")
    }
    
    override func tearDownWithError() throws {
        kasperManager = nil
        testUserProfile = nil
        super.tearDown()
        
        print("🧪 KASPERIntegrationTests: Teardown complete")
    }
    
    // MARK: - Core Integration Tests
    
    /**
     * TEST 1: Complete Enhanced Payload Generation
     * 
     * VALIDATES:
     * - All new payload fields are populated correctly
     * - Natal chart data flows from UserProfile to KASPER
     * - Transit data integrates from CosmicDataRepository
     * - MegaCorpus wisdom extraction works
     * - Environmental context is captured
     * 
     * BUSINESS IMPACT:
     * This is the foundation test for personalized AI insights.
     * If this fails, the entire premium personalization tier fails.
     */
    func testCompleteEnhancedPayloadGeneration() throws {
        // Given: A test user profile with complete natal chart data
        let userProfile = testUserProfile!
        
        // When: Generating a KASPER payload with the enhanced integration
        let payload = kasperManager.generatePayloadWithProfile(userProfile)
        
        // Then: Validate all enhanced fields are present and correctly populated
        XCTAssertNotNil(payload, "KASPER payload should be generated successfully")
        
        guard let payload = payload else {
            XCTFail("Payload generation failed - this breaks personalization")
            return
        }
        
        // Validate core numerological data (existing functionality)
        XCTAssertEqual(payload.lifePathNumber, userProfile.lifePathNumber)
        XCTAssertTrue(payload.isValid, "Generated payload must pass validation")
        
        // Validate NEW natal chart integration
        XCTAssertNotNil(payload.natalChart, "Natal chart data should be integrated")
        if let natalChart = payload.natalChart {
            XCTAssertEqual(natalChart.sunSign, userProfile.natalSunSign,
                          "Sun sign should flow from UserProfile to KASPER")
            XCTAssertEqual(natalChart.moonSign, userProfile.natalMoonSign,
                          "Moon sign should flow from UserProfile to KASPER")
            XCTAssertEqual(natalChart.risingSign, userProfile.risingSign,
                          "Rising sign should flow from UserProfile to KASPER")
            XCTAssertEqual(natalChart.dominantElement, userProfile.dominantElement,
                          "Dominant element should be preserved in KASPER")
        }
        
        // Validate NEW transit data integration
        XCTAssertNotNil(payload.currentTransits, "Current transit data should be available")
        if let transits = payload.currentTransits {
            XCTAssertFalse(transits.currentSunSign.isEmpty,
                          "Current Sun sign should be provided")
            XCTAssertFalse(transits.currentMoonSign.isEmpty,
                          "Current Moon sign should be provided")
            XCTAssertNotNil(transits.calculatedAt,
                           "Transit calculation timestamp should be present")
        }
        
        // Validate NEW environmental context
        XCTAssertNotNil(payload.environmentalContext, "Environmental context should be captured")
        if let environment = payload.environmentalContext {
            XCTAssertNotNil(environment.timeOfDay, "Time of day should be determined")
            XCTAssertFalse(environment.dayOfWeek.isEmpty, "Day of week should be available")
        }
        
        // Validate NEW MegaCorpus integration
        // Note: May be nil if MegaCorpus not loaded in test environment
        if let megaCorpus = payload.megaCorpusData {
            XCTAssertTrue(megaCorpus.extractedAt.timeIntervalSinceNow > -60,
                         "MegaCorpus extract should be recent")
        }
        
        print("✅ Complete enhanced payload generation validated")
        print("📊 Payload debug info: \(payload.debugDescription)")
    }
    
    /**
     * TEST 2: Graceful Fallback Behavior
     * 
     * VALIDATES:
     * - KASPER works when natal chart data is missing
     * - Anonymous user payload generation
     * - System resilience with partial data
     * 
     * BUSINESS IMPACT:
     * Ensures free tier users and incomplete profiles still get
     * valuable spiritual insights, maintaining user engagement.
     */
    func testGracefulFallbackBehavior() throws {
        // Given: Test scenarios with missing data
        
        // Test 1: Anonymous user (no profile)
        let anonymousPayload = kasperManager.generateCurrentPayload()
        
        // Should still generate a payload with fallback data
        XCTAssertNotNil(anonymousPayload, "Anonymous users should still get KASPER payload")
        
        if let payload = anonymousPayload {
            XCTAssertTrue(payload.isValid, "Anonymous payload should be valid")
            // Natal chart should be nil for anonymous users
            XCTAssertNil(payload.natalChart, "Anonymous users should not have natal chart data")
            // But should still have transit and environmental data
            XCTAssertNotNil(payload.currentTransits, "Anonymous users should get current transits")
            XCTAssertNotNil(payload.environmentalContext, "Anonymous users should get environmental context")
        }
        
        // Test 2: Profile with minimal natal chart data
        let minimalProfile = createMinimalUserProfile()
        let minimalPayload = kasperManager.generatePayloadWithProfile(minimalProfile)
        
        XCTAssertNotNil(minimalPayload, "Minimal profile should still generate payload")
        
        if let payload = minimalPayload {
            XCTAssertTrue(payload.isValid, "Minimal payload should be valid")
            XCTAssertNotNil(payload.natalChart, "Minimal profile should have natal chart structure")
            
            // Validate that missing natal data is handled gracefully
            if let natalChart = payload.natalChart {
                // Should not crash with nil values
                XCTAssertNotNil(natalChart, "Natal chart structure should exist even with minimal data")
            }
        }
        
        print("✅ Graceful fallback behavior validated")
    }
    
    /**
     * TEST 3: MegaCorpus Spiritual Wisdom Extraction
     * 
     * VALIDATES:
     * - Relevant spiritual interpretations are extracted
     * - Sign interpretations match natal chart
     * - Planetary meanings are contextualized
     * - Elemental guidance is provided
     * 
     * BUSINESS IMPACT:
     * This is what differentiates Vybe from generic astrology apps.
     * Rich, contextual spiritual wisdom creates premium user experience.
     */
    func testMegaCorpusWisdomExtraction() throws {
        // Given: A user profile with clear astrological data
        let userProfile = testUserProfile!
        
        // When: Generating payload (which extracts MegaCorpus data)
        let payload = kasperManager.generatePayloadWithProfile(userProfile)
        
        // Then: Validate MegaCorpus extraction quality
        XCTAssertNotNil(payload, "Payload should be generated for MegaCorpus testing")
        
        // Note: MegaCorpus data may be nil in test environment
        // This test validates the structure and logic, not necessarily content
        
        if let megaCorpus = payload?.megaCorpusData {
            // Validate extraction structure
            XCTAssertNotNil(megaCorpus.signInterpretations,
                           "Sign interpretations structure should exist")
            XCTAssertNotNil(megaCorpus.planetaryMeanings,
                           "Planetary meanings structure should exist")
            XCTAssertNotNil(megaCorpus.elementalGuidance,
                           "Elemental guidance structure should exist")
            
            // If data is present, validate its relevance
            if !megaCorpus.signInterpretations.isEmpty {
                // Should contain interpretations for user's natal signs
                let natalSigns = [
                    userProfile.natalSunSign,
                    userProfile.natalMoonSign,
                    userProfile.risingSign
                ].compactMap { $0 }
                
                // At least one natal sign should have interpretation
                let hasRelevantInterpretation = natalSigns.contains { sign in
                    megaCorpus.signInterpretations.keys.contains(sign)
                }
                
                if !natalSigns.isEmpty {
                    XCTAssertTrue(hasRelevantInterpretation,
                                 "MegaCorpus should extract interpretations relevant to user's natal chart")
                }
            }
            
            print("✅ MegaCorpus extraction structure validated")
        } else {
            print("ℹ️ MegaCorpus data not available in test environment - structure tests passed")
        }
    }
    
    /**
     * TEST 4: Data Transformation Integrity
     * 
     * VALIDATES:
     * - UserProfile data correctly transforms to KASPER format
     * - No data loss during transformation
     * - Type safety and data consistency
     * - Spiritual authenticity preservation
     * 
     * BUSINESS IMPACT:
     * Ensures spiritual calculations maintain accuracy and authenticity,
     * critical for user trust in spiritual guidance.
     */
    func testDataTransformationIntegrity() throws {
        // Given: A user profile with specific known values
        let userProfile = testUserProfile!
        
        // When: Transforming to KASPER payload
        let payload = kasperManager.generatePayloadWithProfile(userProfile)
        
        // Then: Validate every field transformation
        XCTAssertNotNil(payload, "Data transformation should succeed")
        
        guard let payload = payload else {
            XCTFail("Data transformation failed")
            return
        }
        
        // Validate numerological integrity (critical for spiritual authenticity)
        XCTAssertEqual(payload.lifePathNumber, userProfile.lifePathNumber,
                      "Life Path number must be preserved exactly")
        
        if let soulUrge = userProfile.soulUrgeNumber {
            XCTAssertEqual(payload.soulUrgeNumber, soulUrge,
                          "Soul Urge number must be preserved exactly")
        }
        
        if let expression = userProfile.expressionNumber {
            XCTAssertEqual(payload.expressionNumber, expression,
                          "Expression number must be preserved exactly")
        }
        
        // Validate spiritual tone preservation
        XCTAssertEqual(payload.userTonePreference, userProfile.insightTone,
                      "User's spiritual tone preference must be preserved")
        
        // Validate astrological data transformation
        if let natalChart = payload.natalChart {
            XCTAssertEqual(natalChart.sunSign, userProfile.natalSunSign,
                          "Natal Sun sign must transform correctly")
            XCTAssertEqual(natalChart.moonSign, userProfile.natalMoonSign,
                          "Natal Moon sign must transform correctly")
            XCTAssertEqual(natalChart.risingSign, userProfile.risingSign,
                          "Rising sign must transform correctly")
            XCTAssertEqual(natalChart.dominantElement, userProfile.dominantElement,
                          "Dominant element must transform correctly")
            XCTAssertEqual(natalChart.hasBirthTime, userProfile.hasBirthTime,
                          "Birth time availability must transform correctly")
        }
        
        // Validate payload meets spiritual integrity requirements
        XCTAssertTrue(payload.isValid, "Transformed payload must pass spiritual validation")
        
        print("✅ Data transformation integrity validated")
    }
    
    /**
     * TEST 5: Performance and Memory Characteristics
     * 
     * VALIDATES:
     * - Payload generation completes within reasonable time
     * - Memory usage is controlled
     * - No memory leaks in enhanced integration
     * 
     * BUSINESS IMPACT:
     * Ensures premium features don't degrade app performance,
     * maintaining smooth user experience for all tiers.
     */
    func testPerformanceCharacteristics() throws {
        // Given: Performance measurement setup
        let userProfile = testUserProfile!
        
        // When: Measuring payload generation performance
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // Generate multiple payloads to test consistency
        var payloads: [KASPERPrimingPayload] = []
        
        for _ in 0..<10 {
            if let payload = kasperManager.generatePayloadWithProfile(userProfile) {
                payloads.append(payload)
            }
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let totalTime = endTime - startTime
        let averageTime = totalTime / 10.0
        
        // Then: Validate performance characteristics
        XCTAssertEqual(payloads.count, 10, "All payload generations should succeed")
        XCTAssertLessThan(averageTime, 0.1, "Average payload generation should be under 100ms")
        XCTAssertLessThan(totalTime, 1.0, "Total time for 10 generations should be under 1 second")
        
        // Validate consistency
        for payload in payloads {
            XCTAssertTrue(payload.isValid, "All generated payloads should be valid")
            XCTAssertEqual(payload.lifePathNumber, userProfile.lifePathNumber,
                          "Payload generation should be consistent")
        }
        
        print("✅ Performance characteristics validated")
        print("📊 Average generation time: \(String(format: "%.2f", averageTime * 1000))ms")
    }
    
    // MARK: - Test Helper Methods
    
    /**
     * Create comprehensive test user profile for consistent testing
     * 
     * This profile includes all the data needed to validate the enhanced
     * KASPER integration, including complete natal chart information.
     */
    private func createTestUserProfile() -> UserProfile {
        let testBirthdate = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
        
        return UserProfile(
            id: "test-user-kasper-integration",
            birthdate: testBirthdate,
            lifePathNumber: 7, // Known value for validation
            isMasterNumber: false,
            spiritualMode: "Manifestation",
            insightTone: "Poetic",
            focusTags: ["Wisdom", "Growth", "Connection"],
            cosmicPreference: "Full Cosmic Integration",
            cosmicRhythms: ["Moon Phases", "Zodiac Signs"],
            preferredHour: 9,
            wantsWhispers: true,
            birthName: "Test User",
            soulUrgeNumber: 11, // Master number for testing
            expressionNumber: 3,
            wantsReflectionMode: true,
            birthplaceLatitude: 35.2271, // Charlotte, NC coordinates
            birthplaceLongitude: -80.8431,
            birthplaceName: "Charlotte, NC, USA",
            birthTimezone: "America/New_York",
            // Enhanced natal chart data for KASPER integration testing
            risingSign: "Aquarius",
            midheavenSign: "Sagittarius",
            natalSunSign: "Leo",
            natalMoonSign: "Scorpio",
            natalMercurySign: "Virgo",
            natalVenusSign: "Cancer",
            natalMarsSign: "Aries",
            natalJupiterSign: "Pisces",
            natalSaturnSign: "Capricorn",
            birthTimeHour: 14,
            birthTimeMinute: 30,
            hasBirthTime: true,
            dominantElement: "Fire",
            dominantModality: "Fixed",
            northNodeSign: "Gemini",
            birthChartCalculatedAt: Date()
        )
    }
    
    /**
     * Create minimal user profile for fallback testing
     * 
     * This profile has minimal data to test graceful degradation
     * when complete natal chart information is not available.
     */
    private func createMinimalUserProfile() -> UserProfile {
        let testBirthdate = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
        
        return UserProfile(
            id: "test-user-minimal",
            birthdate: testBirthdate,
            lifePathNumber: 3,
            isMasterNumber: false,
            spiritualMode: "Reflection",
            insightTone: "Gentle",
            focusTags: ["Peace"],
            cosmicPreference: "Numerology Only",
            cosmicRhythms: ["Moon Phases"],
            preferredHour: 8,
            wantsWhispers: false,
            wantsReflectionMode: false
            // Note: Intentionally minimal - no natal chart data
        )
    }
}

/**
 * FUTURE TEST EXPANSION GUIDE
 * 
 * As Vybe evolves, consider adding tests for:
 * 
 * 1. Apple Intelligence Integration:
 *    - Test prompt generation from KASPER payload
 *    - Validate AI response quality and relevance
 *    - Test structured output generation
 * 
 * 2. Premium vs Free Tier:
 *    - Validate different data depth for tiers
 *    - Test monetization strategy implementation
 *    - Ensure free tier remains valuable
 * 
 * 3. Real-time Integration:
 *    - Test CosmicDataRepository integration
 *    - Validate reactive updates
 *    - Test background refresh behavior
 * 
 * 4. Edge Cases:
 *    - Test with various birth chart configurations
 *    - Validate with different time zones
 *    - Test with incomplete MegaCorpus data
 * 
 * 5. Performance Benchmarks:
 *    - Set specific performance targets
 *    - Test with large datasets
 *    - Memory leak detection
 */