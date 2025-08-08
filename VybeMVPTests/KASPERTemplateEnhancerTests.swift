/**
 * KASPERTemplateEnhancerTests.swift
 * 
 * 🧪 COMPREHENSIVE KASPER TEMPLATE ENHANCER TEST SUITE
 * 
 * ✅ STATUS: Complete unit test coverage for enhanced template generation
 * ✅ SCOPE: Natural language templates, sentence flow, spiritual authenticity
 * ✅ ARCHITECTURE: Static method testing with template variety validation
 * 
 * PURPOSE:
 * These tests validate the revolutionary KASPERTemplateEnhancer that eliminates
 * rigid "templatey" sentence patterns and creates natural, flowing spiritual 
 * insights with authentic spiritual language.
 * 
 * WHY THESE TESTS MATTER:
 * - Template quality directly impacts user perception of AI authenticity
 * - Natural language flow prevents robotic spiritual guidance
 * - Template variety ensures engaging, non-repetitive spiritual experience  
 * - Spiritual authenticity maintains trust and credibility
 * - Performance requirements ensure smooth cosmic animations
 * 
 * WHAT WE'RE TESTING:
 * 1. Template generation methods for all insight types
 * 2. Natural language flow and sentence structure quality
 * 3. Template variety and randomization effectiveness
 * 4. Spiritual authenticity markers and language patterns
 * 5. Relationship compatibility template accuracy
 * 6. Cosmic timing integration and contextual awareness
 * 7. Performance characteristics of template generation
 * 
 * TEMPLATE ENHANCEMENT VALIDATION:
 * - Guidance templates with 10+ natural variations
 * - Reflection templates with contemplative depth
 * - Affirmation templates with empowering energy
 * - Prediction templates with mystical foresight
 * - Relationship templates with spiritual wisdom
 * - Cosmic timing templates with astrological accuracy
 */

import XCTest
@testable import VybeMVP

final class KASPERTemplateEnhancerTests: XCTestCase {
    
    // MARK: - Test Lifecycle
    
    override func setUpWithError() throws {
        super.setUp()
        print("🧪 KASPERTemplateEnhancerTests: Setting up template enhancer test suite...")
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        print("🧪 KASPERTemplateEnhancerTests: Teardown complete")
    }
    
    // MARK: - Guidance Template Tests
    
    /**
     * TEST 1: Guidance Template Generation and Variety
     * 
     * VALIDATES:
     * - generateGuidanceInsight produces varied, natural templates
     * - All generated insights contain appropriate spiritual markers
     * - Templates maintain consistent structure while varying content
     * - Natural language flow eliminates "templatey" patterns
     * 
     * BUSINESS IMPACT:
     * Guidance templates are the foundation of daily spiritual direction,
     * requiring natural flow and authentic spiritual language.
     */
    func testGuidanceTemplateGenerationAndVariety() throws {
        print("🧪 Testing guidance template generation and variety...")
        
        let testComponents = ["divine wisdom energy", "sacred leadership energy", "mystical transformation energy"]
        let testReferences = ["your natural leadership abilities", "your gift for creating harmony", "your intuitive wisdom"]
        let testGuidances = ["trust your instincts to initiate new ventures", "seek collaboration and peaceful resolution", "embrace change as a pathway to growth"]
        
        var generatedInsights: Set<String> = []
        let totalGenerations = 30 // Generate enough to test variety
        
        for i in 0..<totalGenerations {
            let component = testComponents[i % testComponents.count]
            let reference = testReferences[i % testReferences.count]
            let guidance = testGuidances[i % testGuidances.count]
            
            let insight = KASPERTemplateEnhancer.generateGuidanceInsight(
                component: component,
                reference: reference,
                guidance: guidance
            )
            
            // Validate basic structure
            XCTAssertFalse(insight.isEmpty, "Generated insight should not be empty")
            XCTAssertGreaterThan(insight.count, 50, "Guidance should have substantial content")
            
            // Validate spiritual authenticity markers
            XCTAssertTrue(insight.contains("🌟"), "Guidance should contain guidance emoji")
            
            // Validate natural language patterns
            XCTAssertFalse(insight.contains("Trust Your The"), "Should not contain malformed patterns")
            XCTAssertFalse(insight.contains("Nature Trust"), "Should not contain fragmented sentence patterns")
            
            // Validate component integration
            XCTAssertTrue(insight.contains(component) || insight.contains(component.replacingOccurrences(of: " energy", with: "")), 
                         "Should integrate component naturally")
            XCTAssertTrue(insight.contains(reference) || insight.lowercased().contains(reference.lowercased()), 
                         "Should integrate reference naturally")
            XCTAssertTrue(insight.contains(guidance) || insight.lowercased().contains(guidance.lowercased()), 
                         "Should integrate guidance naturally")
            
            // Validate spiritual language patterns
            let spiritualPatterns = ["cosmic", "divine", "sacred", "spiritual", "energy", "universe", "wisdom", "guidance"]
            let containsSpiritualLanguage = spiritualPatterns.contains { pattern in
                insight.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsSpiritualLanguage, "Should contain authentic spiritual language")
            
            generatedInsights.insert(insight)
        }
        
        // Validate template variety
        let varietyRatio = Double(generatedInsights.count) / Double(totalGenerations)
        XCTAssertGreaterThan(varietyRatio, 0.5, "Should generate at least 50% unique templates for variety")
        
        print("✅ Guidance template generation validated")
        print("📊 Generated \(generatedInsights.count)/\(totalGenerations) unique templates (\(String(format: "%.1f", varietyRatio * 100))% variety)")
    }
    
    /**
     * TEST 2: Reflection Template Depth and Contemplation
     * 
     * VALIDATES:
     * - generateReflectionInsight creates contemplative, introspective content
     * - Templates encourage deep spiritual reflection
     * - Question patterns promote inner wisdom discovery
     * - Contemplative language maintains spiritual authenticity
     * 
     * BUSINESS IMPACT:
     * Reflection templates guide users toward deeper spiritual understanding
     * and self-discovery through contemplative practices.
     */
    func testReflectionTemplateDepthAndContemplation() throws {
        print("🧪 Testing reflection template depth and contemplation...")
        
        let testData = [
            ("mystical wisdom energy", "your intuitive wisdom", "trust your intuition and inner wisdom"),
            ("harmonizing cooperative energy", "your gift for creating harmony", "seek collaboration and peaceful resolution"),
            ("creative expression energy", "your vibrant creative gifts", "express your truth through creative communication")
        ]
        
        for (component, reference, guidance) in testData {
            let reflection = KASPERTemplateEnhancer.generateReflectionInsight(
                component: component,
                reference: reference,
                guidance: guidance
            )
            
            // Validate reflection-specific structure
            XCTAssertFalse(reflection.isEmpty, "Reflection should not be empty")
            XCTAssertTrue(reflection.contains("🌙"), "Reflection should contain moon emoji")
            XCTAssertGreaterThan(reflection.count, 60, "Reflection should have substantial contemplative content")
            
            // Validate contemplative language patterns
            let contemplativePatterns = ["reflect", "consider", "observe", "notice", "contemplate", "inner", "wisdom", "awareness", "consciousness"]
            let containsContemplation = contemplativePatterns.contains { pattern in
                reflection.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsContemplation, "Should contain contemplative language patterns")
            
            // Validate question or introspective prompts
            let introspectivePrompts = ["what", "how", "consider", "reflect", "observe", "listen"]
            let containsIntrospection = introspectivePrompts.contains { prompt in
                reflection.lowercased().contains(prompt)
            }
            XCTAssertTrue(containsIntrospection, "Should contain introspective prompts")
            
            // Validate spiritual depth
            let depthMarkers = ["soul", "essence", "sacred", "divine", "spiritual", "consciousness", "awareness"]
            let containsDepth = depthMarkers.contains { marker in
                reflection.lowercased().contains(marker)
            }
            XCTAssertTrue(containsDepth, "Should contain spiritual depth markers")
        }
        
        print("✅ Reflection template depth and contemplation validated")
    }
    
    /**
     * TEST 3: Affirmation Template Empowerment and Energy
     * 
     * VALIDATES:
     * - generateAffirmationInsight creates empowering, positive statements
     * - "I am" and "I" patterns promote self-empowerment
     * - Templates inspire confidence and spiritual authority
     * - Empowering language maintains authentic spiritual power
     * 
     * BUSINESS IMPACT:
     * Affirmation templates help users embody their spiritual power
     * and divine nature through positive self-declaration.
     */
    func testAffirmationTemplateEmpowermentAndEnergy() throws {
        print("🧪 Testing affirmation template empowerment and energy...")
        
        let testData = [
            ("pioneering leadership energy", "your natural leadership abilities", "trust your instincts to initiate new ventures"),
            ("nurturing service energy", "your compassionate heart", "offer healing presence to those around you"),
            ("manifestation mastery energy", "your manifestation abilities", "balance ambition with spiritual integrity")
        ]
        
        for (component, reference, guidance) in testData {
            let affirmation = KASPERTemplateEnhancer.generateAffirmationInsight(
                component: component,
                reference: reference,
                guidance: guidance
            )
            
            // Validate affirmation structure
            XCTAssertFalse(affirmation.isEmpty, "Affirmation should not be empty")
            XCTAssertTrue(affirmation.contains("💫"), "Affirmation should contain empowerment emoji")
            XCTAssertGreaterThan(affirmation.count, 50, "Affirmation should have empowering content")
            
            // Validate empowering "I" statements
            XCTAssertTrue(affirmation.contains("I "), "Affirmation should contain 'I' statements")
            
            // Validate empowering language patterns
            let empowermentPatterns = ["embody", "channel", "master", "create", "manifest", "align", "power", "divine", "sacred", "authority"]
            let containsEmpowerment = empowermentPatterns.contains { pattern in
                affirmation.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsEmpowerment, "Should contain empowering language patterns")
            
            // Validate positive, affirming tone
            let positiveWords = ["divine", "sacred", "perfect", "powerful", "magnificent", "grace", "joyfully", "confidently"]
            let containsPositivity = positiveWords.contains { word in
                affirmation.lowercased().contains(word)
            }
            XCTAssertTrue(containsPositivity, "Should contain positive, affirming language")
            
            // Ensure no negative or limiting language
            let negativeWords = ["can't", "won't", "never", "impossible", "fail", "wrong"]
            let containsNegativity = negativeWords.contains { word in
                affirmation.lowercased().contains(word)
            }
            XCTAssertFalse(containsNegativity, "Should not contain negative or limiting language")
        }
        
        print("✅ Affirmation template empowerment and energy validated")
    }
    
    /**
     * TEST 4: Prediction Template Mystical Foresight
     * 
     * VALIDATES:
     * - generatePredictionInsight creates mystical, prophetic content
     * - Future-oriented language suggests upcoming possibilities
     * - Templates maintain spiritual mystery and divine timing
     * - Mystical language patterns enhance prophetic authenticity
     * 
     * BUSINESS IMPACT:
     * Prediction templates provide mystical foresight that helps users
     * navigate future possibilities with spiritual wisdom.
     */
    func testPredictionTemplateMysticalForesight() throws {
        print("🧪 Testing prediction template mystical foresight...")
        
        let testData = [
            ("transformative freedom energy", "your adventurous spirit", "embrace change as a pathway to growth"),
            ("material mastery energy", "your manifestation abilities", "balance ambition with spiritual integrity"),
            ("universal compassion energy", "your universal compassion", "serve the universal good through compassionate action")
        ]
        
        for (component, reference, guidance) in testData {
            let prediction = KASPERTemplateEnhancer.generatePredictionInsight(
                component: component,
                reference: reference,
                guidance: guidance
            )
            
            // Validate prediction structure
            XCTAssertFalse(prediction.isEmpty, "Prediction should not be empty")
            XCTAssertTrue(prediction.contains("🔮"), "Prediction should contain crystal ball emoji")
            XCTAssertGreaterThan(prediction.count, 60, "Prediction should have mystical content")
            
            // Validate future-oriented language
            let futurePatterns = ["ahead", "coming", "approaching", "future", "will", "prepare", "cosmic tide", "wave", "unfold"]
            let containsFutureLanguage = futurePatterns.contains { pattern in
                prediction.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsFutureLanguage, "Should contain future-oriented language")
            
            // Validate mystical and prophetic language
            let mysticalPatterns = ["cosmic", "destiny", "oracle", "vision", "prophetic", "divine", "sacred", "mystical", "quantum", "stellar"]
            let containsMysticism = mysticalPatterns.contains { pattern in
                prediction.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsMysticism, "Should contain mystical and prophetic language")
            
            // Validate timing and preparation themes
            let timingPatterns = ["timing", "moment", "cycle", "window", "opportunity", "align", "prepare"]
            let containsTiming = timingPatterns.contains { pattern in
                prediction.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsTiming, "Should contain timing and preparation themes")
        }
        
        print("✅ Prediction template mystical foresight validated")
    }
    
    // MARK: - Relationship Compatibility Tests
    
    /**
     * TEST 5: Relationship Compatibility Template Accuracy
     * 
     * VALIDATES:
     * - generateRelationshipInsight creates accurate numerological compatibility
     * - Number combinations produce appropriate spiritual chemistry descriptions
     * - Template variety ensures engaging relationship guidance
     * - Moon phase integration enhances astrological accuracy
     * 
     * BUSINESS IMPACT:
     * Relationship templates guide users in understanding spiritual
     * connections and compatibility through numerological wisdom.
     */
    func testRelationshipCompatibilityTemplateAccuracy() throws {
        print("🧪 Testing relationship compatibility template accuracy...")
        
        let compatibilityTestCases = [
            (1, 9), // Should create powerful spiritual resonance
            (2, 6), // Should create harmonious heart connection  
            (3, 7), // Should create creative mystical synergy
            (4, 8), // Should create grounding manifestation power
            (5, 5), // Should create mirror soul reflection
        ]
        
        for (number1, number2) in compatibilityTestCases {
            let relationshipInsight = KASPERTemplateEnhancer.generateRelationshipInsight(
                number1: number1,
                number2: number2,
                moonPhase: "Full Moon"
            )
            
            // Validate relationship insight structure
            XCTAssertFalse(relationshipInsight.isEmpty, "Relationship insight should not be empty")
            XCTAssertTrue(relationshipInsight.contains("💞"), "Should contain heart emoji")
            XCTAssertGreaterThan(relationshipInsight.count, 80, "Should have substantial relationship guidance")
            
            // Validate number integration
            XCTAssertTrue(relationshipInsight.contains("\(number1)"), "Should mention first number")
            XCTAssertTrue(relationshipInsight.contains("\(number2)"), "Should mention second number")
            
            // Validate compatibility description
            let compatibilityTypes = ["resonance", "connection", "synergy", "power", "reflection", "harmony", "catalyst", "polarity", "mystery"]
            let containsCompatibility = compatibilityTypes.contains { type in
                relationshipInsight.lowercased().contains(type)
            }
            XCTAssertTrue(containsCompatibility, "Should describe compatibility type")
            
            // Validate spiritual relationship language
            let relationshipPatterns = ["souls", "spiritual", "sacred", "divine", "cosmic", "alchemy", "chemistry", "mirror", "dance"]
            let containsRelationshipLanguage = relationshipPatterns.contains { pattern in
                relationshipInsight.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsRelationshipLanguage, "Should contain spiritual relationship language")
            
            // Validate moon phase integration (when provided)
            XCTAssertTrue(relationshipInsight.contains("Full Moon"), "Should integrate moon phase context")
        }
        
        print("✅ Relationship compatibility template accuracy validated")
    }
    
    /**
     * TEST 6: Cosmic Timing Template Integration
     * 
     * VALIDATES:
     * - generateCosmicTimingInsight creates time-aware spiritual guidance
     * - Planetary and astrological context enhances timing accuracy
     * - Templates emphasize divine timing and cosmic orchestration
     * - Astrological events are integrated meaningfully
     * 
     * BUSINESS IMPACT:
     * Cosmic timing templates help users align with universal rhythms
     * and optimal timing for spiritual actions and manifestation.
     */
    func testCosmicTimingTemplateIntegration() throws {
        print("🧪 Testing cosmic timing template integration...")
        
        let timingTestCases: [(planetaryEnergy: String?, moonPhase: String?, astrologicalEvent: String?)] = [
            (planetaryEnergy: "Mercury", moonPhase: "New Moon", astrologicalEvent: "Mercury Retrograde"),
            (planetaryEnergy: "Venus", moonPhase: "Full Moon", astrologicalEvent: "Venus in Taurus"),
            (planetaryEnergy: "Mars", moonPhase: "Waxing Crescent", astrologicalEvent: "Mars in Aries"),
            (planetaryEnergy: nil, moonPhase: "Waning Gibbous", astrologicalEvent: nil),
        ]
        
        for testCase in timingTestCases {
            let cosmicInsight = KASPERTemplateEnhancer.generateCosmicTimingInsight(
                planetaryEnergy: testCase.planetaryEnergy,
                moonPhase: testCase.moonPhase,
                astrologicalEvent: testCase.astrologicalEvent
            )
            
            // Validate cosmic timing structure
            XCTAssertFalse(cosmicInsight.isEmpty, "Cosmic timing insight should not be empty")
            XCTAssertTrue(cosmicInsight.contains("⏰"), "Should contain timing emoji")
            XCTAssertGreaterThan(cosmicInsight.count, 80, "Should have substantial timing guidance")
            
            // Validate timing-specific language
            let timingPatterns = ["timing", "moment", "window", "opportunity", "align", "orchestrate", "cosmic", "divine", "celestial"]
            let containsTimingLanguage = timingPatterns.contains { pattern in
                cosmicInsight.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsTimingLanguage, "Should contain timing-specific language")
            
            // Validate integration of provided elements
            if let planetary = testCase.planetaryEnergy {
                XCTAssertTrue(cosmicInsight.contains(planetary), "Should integrate planetary energy")
            }
            
            if let moon = testCase.moonPhase {
                XCTAssertTrue(cosmicInsight.contains(moon), "Should integrate moon phase")
            }
            
            if let event = testCase.astrologicalEvent {
                XCTAssertTrue(cosmicInsight.contains(event), "Should integrate astrological event")
            }
            
            // Validate action-oriented guidance
            let actionPatterns = ["step", "move", "embrace", "align", "prepare", "trust", "answer", "dance"]
            let containsAction = actionPatterns.contains { pattern in
                cosmicInsight.lowercased().contains(pattern)
            }
            XCTAssertTrue(containsAction, "Should contain action-oriented guidance")
        }
        
        print("✅ Cosmic timing template integration validated")
    }
    
    // MARK: - Performance and Quality Tests
    
    /**
     * TEST 7: Template Generation Performance
     * 
     * VALIDATES:
     * - All template generation methods meet performance requirements
     * - Template randomization doesn't impact performance significantly
     * - Memory usage remains controlled during template generation
     * - Large-scale template generation maintains consistent performance
     * 
     * BUSINESS IMPACT:
     * Performance optimization ensures template generation doesn't
     * impact the app's smooth 60fps cosmic animations.
     */
    func testTemplateGenerationPerformance() throws {
        print("🧪 Testing template generation performance...")
        
        let performanceIterations = 100
        let testComponent = "sacred wisdom energy"
        let testReference = "your divine spiritual gifts"
        let testGuidance = "trust your inner wisdom and spiritual authority"
        
        // Test guidance template performance
        let guidanceStartTime = Date()
        for _ in 0..<performanceIterations {
            _ = KASPERTemplateEnhancer.generateGuidanceInsight(
                component: testComponent,
                reference: testReference,
                guidance: testGuidance
            )
        }
        let guidanceTime = Date().timeIntervalSince(guidanceStartTime)
        let guidanceAvgTime = guidanceTime / Double(performanceIterations)
        
        XCTAssertLessThan(guidanceAvgTime, 0.001, "Guidance template generation should be under 1ms")
        
        // Test reflection template performance
        let reflectionStartTime = Date()
        for _ in 0..<performanceIterations {
            _ = KASPERTemplateEnhancer.generateReflectionInsight(
                component: testComponent,
                reference: testReference,
                guidance: testGuidance
            )
        }
        let reflectionTime = Date().timeIntervalSince(reflectionStartTime)
        let reflectionAvgTime = reflectionTime / Double(performanceIterations)
        
        XCTAssertLessThan(reflectionAvgTime, 0.001, "Reflection template generation should be under 1ms")
        
        // Test affirmation template performance
        let affirmationStartTime = Date()
        for _ in 0..<performanceIterations {
            _ = KASPERTemplateEnhancer.generateAffirmationInsight(
                component: testComponent,
                reference: testReference,
                guidance: testGuidance
            )
        }
        let affirmationTime = Date().timeIntervalSince(affirmationStartTime)
        let affirmationAvgTime = affirmationTime / Double(performanceIterations)
        
        XCTAssertLessThan(affirmationAvgTime, 0.001, "Affirmation template generation should be under 1ms")
        
        // Test relationship template performance
        let relationshipStartTime = Date()
        for i in 0..<performanceIterations {
            _ = KASPERTemplateEnhancer.generateRelationshipInsight(
                number1: (i % 9) + 1,
                number2: ((i + 3) % 9) + 1,
                moonPhase: "Full Moon"
            )
        }
        let relationshipTime = Date().timeIntervalSince(relationshipStartTime)
        let relationshipAvgTime = relationshipTime / Double(performanceIterations)
        
        XCTAssertLessThan(relationshipAvgTime, 0.001, "Relationship template generation should be under 1ms")
        
        print("✅ Template generation performance validated")
        print("📊 Guidance: \(String(format: "%.3f", guidanceAvgTime * 1000))ms avg")
        print("📊 Reflection: \(String(format: "%.3f", reflectionAvgTime * 1000))ms avg")
        print("📊 Affirmation: \(String(format: "%.3f", affirmationAvgTime * 1000))ms avg")
        print("📊 Relationship: \(String(format: "%.3f", relationshipAvgTime * 1000))ms avg")
    }
    
    /**
     * TEST 8: Template Quality and Spiritual Authenticity
     * 
     * VALIDATES:
     * - All templates maintain spiritual authenticity standards
     * - Natural language flow eliminates robotic patterns
     * - Template content is meaningful and actionable
     * - Spiritual depth is preserved across all template types
     * 
     * BUSINESS IMPACT:
     * Quality assurance ensures all AI-generated insights maintain
     * the spiritual authenticity and wisdom users expect from Vybe.
     */
    func testTemplateQualityAndSpiritualAuthenticity() throws {
        print("🧪 Testing template quality and spiritual authenticity...")
        
        let qualityTestData = [
            ("divine leadership energy", "your pioneering spirit", "trust your instincts to lead"),
            ("sacred harmony energy", "your gift for balance", "seek peaceful resolution"),
            ("mystical wisdom energy", "your intuitive knowing", "trust your inner guidance"),
            ("creative expression energy", "your artistic gifts", "express your authentic truth"),
            ("transformative energy", "your ability to change", "embrace growth courageously")
        ]
        
        for (component, reference, guidance) in qualityTestData {
            // Test all template types for quality
            let templates = [
                ("Guidance", KASPERTemplateEnhancer.generateGuidanceInsight(component: component, reference: reference, guidance: guidance)),
                ("Reflection", KASPERTemplateEnhancer.generateReflectionInsight(component: component, reference: reference, guidance: guidance)),
                ("Affirmation", KASPERTemplateEnhancer.generateAffirmationInsight(component: component, reference: reference, guidance: guidance)),
                ("Prediction", KASPERTemplateEnhancer.generatePredictionInsight(component: component, reference: reference, guidance: guidance))
            ]
            
            for (type, template) in templates {
                // Validate basic quality requirements
                XCTAssertGreaterThan(template.count, 40, "\(type) template should have substantial content")
                XCTAssertFalse(template.isEmpty, "\(type) template should not be empty")
                
                // Validate natural language flow (no robotic patterns)
                XCTAssertFalse(template.contains("Trust Your The"), "\(type) should not contain malformed patterns")
                XCTAssertFalse(template.contains("Nature Trust"), "\(type) should not contain fragmented patterns")
                XCTAssertFalse(template.contains("  "), "\(type) should not contain double spaces")
                
                // Validate spiritual authenticity markers
                let spiritualMarkers = ["divine", "sacred", "spiritual", "cosmic", "wisdom", "energy", "soul", "essence"]
                let containsSpiritual = spiritualMarkers.contains { marker in
                    template.lowercased().contains(marker)
                }
                XCTAssertTrue(containsSpiritual, "\(type) should contain spiritual authenticity markers")
                
                // Validate actionable guidance
                let actionablePatterns = ["trust", "embrace", "align", "honor", "channel", "express", "seek", "create"]
                let containsActionable = actionablePatterns.contains { pattern in
                    template.lowercased().contains(pattern)
                }
                XCTAssertTrue(containsActionable, "\(type) should contain actionable guidance")
                
                // Ensure no harmful or negative content
                let negativePatterns = ["fear", "fail", "never", "impossible", "can't", "won't"]
                let containsNegative = negativePatterns.contains { pattern in
                    template.lowercased().contains(pattern)
                }
                XCTAssertFalse(containsNegative, "\(type) should not contain negative or limiting language")
            }
        }
        
        print("✅ Template quality and spiritual authenticity validated")
    }
}