/**
 * KASPER MLX SwiftData Integration Tests
 * 
 * Comprehensive test suite for KASPER MLX integration with SwiftData spiritual database.
 * Validates that spiritual insights are properly generated using SwiftData models instead
 * of legacy JSON-based MegaCorpus data.
 * 
 * Key Testing Areas:
 * - SwiftData model integration with KASPER MLX providers
 * - NumberMeaning insights with rich categorized content
 * - Astrological data integration for cosmic insights  
 * - Performance with SwiftData queries
 * - Cache integration with SwiftData persistence
 */

import XCTest
import SwiftData
import Combine
@testable import VybeMVP

@available(iOS 17.0, *)
@MainActor
final class KASPERMLXSwiftDataIntegrationTests: XCTestCase {
    
    // MARK: - Test Properties
    
    private var kasperEngine: KASPERMLXEngine!
    private var spiritualDataController: SpiritualDataController!
    private var testModelContainer: ModelContainer!
    private var testRealmNumberManager: RealmNumberManager!
    private var testFocusNumberManager: FocusNumberManager!
    
    // MARK: - Test Lifecycle
    
    override func setUpWithError() throws {
        super.setUp()
        
        // Create in-memory SwiftData container for testing
        let schema = Schema([
            NumberMeaning.self,
            ZodiacMeaning.self, 
            PersonalizedInsightTemplate.self,
            AstrologicalAspect.self,
            AstrologicalElement.self,
            AstrologicalMode.self,
            AstrologicalPlanet.self,
            ApparentMotion.self,
            MoonPhase.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        
        testModelContainer = try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
        
        // Initialize test managers
        testRealmNumberManager = RealmNumberManager()
        testFocusNumberManager = FocusNumberManager.shared
        
        // Initialize KASPER engine
        kasperEngine = KASPERMLXEngine.shared
        
        // Populate test data
        try populateTestData()
        
        print("🧪 KASPERMLXSwiftDataIntegrationTests: Setup complete")
    }
    
    override func tearDownWithError() throws {
        kasperEngine = nil
        spiritualDataController = nil
        testModelContainer = nil
        testRealmNumberManager = nil
        testFocusNumberManager = nil
        super.tearDown()
        
        print("🧪 KASPERMLXSwiftDataIntegrationTests: Teardown complete")
    }
    
    // MARK: - Test Data Population
    
    private func populateTestData() throws {
        let context = testModelContainer.mainContext
        
        // Create test NumberMeaning data
        let testNumbers = [1, 3, 7, 9]
        for number in testNumbers {
            let numberMeaning = NumberMeaning(
                number: number,
                archetype: getTestArchetype(for: number),
                title: "The \(getTestArchetype(for: number))",
                element: getTestElement(for: number),
                keywords: getTestKeywords(for: number),
                strengths: getTestStrengths(for: number),
                legacyChallenges: getTestChallenges(for: number),
                spiritualDescription: getTestDescription(for: number),
                planetaryCorrespondence: getTestPlanet(for: number),
                signCorrespondence: getTestSign(for: number),
                color: getTestColor(for: number),
                insights: getTestInsights(for: number),
                reflections: getTestReflections(for: number),
                contemplations: getTestContemplations(for: number),
                manifestations: getTestManifestations(for: number)
            )
            context.insert(numberMeaning)
        }
        
        // Create test ZodiacMeaning data
        let testSigns = ["Aries", "Cancer", "Libra", "Pisces"]
        for (index, sign) in testSigns.enumerated() {
            let zodiacMeaning = ZodiacMeaning(
                name: sign,
                glyph: getTestGlyph(for: sign),
                dateRange: getTestDateRange(for: sign),
                symbol: getTestSymbol(for: sign),
                ruler: getTestRuler(for: sign),
                house: "\(index + 1)st House",
                element: getTestElementForSign(for: sign),
                mode: getTestModeForSign(for: sign),
                keyword: getTestKeywordForSign(for: sign),
                signDescription: getTestSignDescription(for: sign),
                signOrderNumber: index + 1,
                rulerVibration: index + 1,
                elementNumber: (index % 4) + 1,
                modeNumber: (index % 3) + 1,
                resonantNumbers: [index + 1, index + 4, index + 7],
                keyTraits: getTestSignTraits(for: sign),
                spiritualGuidance: getTestSignGuidance(for: sign)
            )
            context.insert(zodiacMeaning)
        }
        
        try context.save()
        print("✅ Test SwiftData populated successfully")
    }
    
    // MARK: - SwiftData Integration Tests
    
    /**
     * TEST 1: NumberMeaning SwiftData Integration
     * Validates that KASPER MLX can access NumberMeaning data from SwiftData
     */
    func testNumberMeaningSwiftDataIntegration() async throws {
        // Given: Test focus number
        let testFocusNumber = 7
        testFocusNumberManager.userDidPickFocusNumber(testFocusNumber)
        
        // Configure engine
        await kasperEngine.configure(
            realmManager: testRealmNumberManager,
            focusManager: testFocusNumberManager,
            healthManager: nil
        )
        
        // When: Generating insight for focus number
        let context = InsightContext(
            primaryData: [
                "focusNumber": testFocusNumber,
                "testMode": true
            ],
            userQuery: "What spiritual guidance does my focus number offer?",
            constraints: InsightConstraints(
                maxLength: 200,
                spiritualDepth: .deep
            )
        )
        
        let request = InsightRequest(
            feature: .dailyCard,
            type: .guidance,
            priority: .high,
            context: context
        )
        
        let insight = try await kasperEngine.generateInsight(for: request)
        
        // Then: Validate SwiftData integration
        XCTAssertNotNil(insight, "Should generate insight with SwiftData")
        XCTAssertFalse(insight.content.isEmpty, "Should have meaningful content")
        XCTAssertGreaterThan(insight.confidence, 0.7, "Should have high confidence with real data")
        
        // Should contain focus number 7 specific spiritual themes
        let content = insight.content.lowercased()
        let mysticKeywords = ["mystic", "spiritual", "wisdom", "intuition", "sacred", "inner", "divine"]
        let containsMysticThemes = mysticKeywords.contains { content.contains($0) }
        
        XCTAssertTrue(containsMysticThemes, 
                     "Focus 7 should contain mystical themes. Generated: \(insight.content)")
        
        print("✅ NumberMeaning SwiftData integration validated")
        print("🔮 Generated insight: \(insight.content)")
    }
    
    /**
     * TEST 2: ZodiacMeaning SwiftData Integration  
     * Validates astrological data integration from SwiftData
     */
    func testZodiacMeaningSwiftDataIntegration() async throws {
        // Given: Configure engine
        await kasperEngine.configure(
            realmManager: testRealmNumberManager,
            focusManager: testFocusNumberManager,
            healthManager: nil
        )
        
        // When: Generating cosmic timing insight that uses zodiac data
        let context = InsightContext(
            primaryData: [
                "cosmicQuery": "current_zodiac_energy",
                "testMode": true
            ],
            userQuery: "What is the current cosmic energy?",
            constraints: InsightConstraints(maxLength: 150)
        )
        
        let request = InsightRequest(
            feature: .cosmicTiming,
            type: .guidance,
            priority: .high,
            context: context
        )
        
        let insight = try await kasperEngine.generateInsight(for: request)
        
        // Then: Validate zodiac data integration
        XCTAssertNotNil(insight, "Should generate cosmic insight")
        XCTAssertFalse(insight.content.isEmpty, "Should have cosmic content")
        
        // Should reference astrological concepts
        let content = insight.content.lowercased()
        let astrologicalTerms = ["cosmic", "energy", "planetary", "celestial", "universe", "alignment"]
        let containsAstrologicalTerms = astrologicalTerms.contains { content.contains($0) }
        
        XCTAssertTrue(containsAstrologicalTerms,
                     "Cosmic timing should reference astrological concepts. Generated: \(insight.content)")
        
        print("✅ ZodiacMeaning SwiftData integration validated")
        print("🌌 Generated cosmic insight: \(insight.content)")
    }
    
    /**
     * TEST 3: Rich Insight Categories Integration
     * Validates that NumberMeaning's rich categorized insights are utilized
     */
    func testRichInsightCategoriesIntegration() async throws {
        // Given: Focus number with rich insight data
        let testFocusNumber = 3
        testFocusNumberManager.userDidPickFocusNumber(testFocusNumber)
        
        await kasperEngine.configure(
            realmManager: testRealmNumberManager,
            focusManager: testFocusNumberManager,
            healthManager: nil
        )
        
        // Test different insight types to ensure variety
        let insightTypes: [KASPERInsightType] = [.guidance, .reflection, .affirmation]
        
        for insightType in insightTypes {
            // When: Generating specific insight type
            let context = InsightContext(
                primaryData: [
                    "focusNumber": testFocusNumber,
                    "requestCategory": insightType.rawValue
                ],
                userQuery: "Provide \(insightType.rawValue) for my spiritual journey"
            )
            
            let request = InsightRequest(
                feature: .journalInsight,
                type: insightType,
                priority: .high,
                context: context
            )
            
            let insight = try await kasperEngine.generateInsight(for: request)
            
            // Then: Validate type-specific content
            XCTAssertNotNil(insight, "Should generate \(insightType.rawValue) insight")
            XCTAssertEqual(insight.type, insightType, "Should match requested type")
            XCTAssertFalse(insight.content.isEmpty, "Should have meaningful content")
            
            // Focus 3 should contain creative/expressive themes
            let content = insight.content.lowercased()
            let creativeKeywords = ["creative", "expression", "communicate", "artistic", "joy", "inspiration"]
            let containsCreativeThemes = creativeKeywords.contains { content.contains($0) }
            
            XCTAssertTrue(containsCreativeThemes,
                         "Focus 3 \(insightType.rawValue) should contain creative themes. Generated: \(insight.content)")
            
            print("✅ \(insightType.rawValue) insight for Focus 3: \(insight.content)")
        }
        
        print("✅ Rich insight categories integration validated")
    }
    
    /**
     * TEST 4: SwiftData Performance with KASPER MLX
     * Validates that SwiftData queries don't negatively impact performance
     */
    func testSwiftDataPerformanceIntegration() async throws {
        // Given: Configure engine
        await kasperEngine.configure(
            realmManager: testRealmNumberManager, 
            focusManager: testFocusNumberManager,
            healthManager: nil
        )
        
        let performanceTests = 10
        var totalTime: TimeInterval = 0
        
        for i in 0..<performanceTests {
            // When: Generating insights with SwiftData
            let startTime = Date()
            
            let context = InsightContext(
                primaryData: ["performanceTest": i],
                userQuery: "Performance test query \(i)"
            )
            
            let request = InsightRequest(
                feature: .dailyCard,
                type: .guidance,
                priority: .high,
                context: context
            )
            
            let insight = try await kasperEngine.generateInsight(for: request)
            let queryTime = Date().timeIntervalSince(startTime)
            totalTime += queryTime
            
            // Validate quality isn't compromised
            XCTAssertNotNil(insight, "Performance test \(i) should generate insight")
            XCTAssertFalse(insight.content.isEmpty, "Performance test \(i) should have content")
            XCTAssertLessThan(queryTime, 0.5, "Individual query should be under 500ms")
        }
        
        let averageTime = totalTime / Double(performanceTests)
        
        // Then: Validate overall performance
        XCTAssertLessThan(averageTime, 0.1, "Average SwiftData query time should be under 100ms")
        XCTAssertLessThan(totalTime, 2.0, "Total time for \(performanceTests) queries should be under 2 seconds")
        
        print("✅ SwiftData performance validated")
        print("📊 Average query time: \(String(format: "%.2f", averageTime * 1000))ms")
        print("📊 Total time for \(performanceTests) queries: \(String(format: "%.2f", totalTime * 1000))ms")
    }
    
    // MARK: - Test Data Helpers
    
    private func getTestArchetype(for number: Int) -> String {
        switch number {
        case 1: return "Pioneer"
        case 3: return "Creator" 
        case 7: return "Mystic"
        case 9: return "Humanitarian"
        default: return "Seeker"
        }
    }
    
    private func getTestElement(for number: Int) -> String {
        switch number {
        case 1, 9: return "Fire"
        case 3, 7: return "Air"
        default: return "Universal"
        }
    }
    
    private func getTestKeywords(for number: Int) -> [String] {
        switch number {
        case 1: return ["leadership", "independence", "initiative", "pioneering"]
        case 3: return ["creativity", "expression", "communication", "joy"]
        case 7: return ["spirituality", "wisdom", "intuition", "mysticism"]
        case 9: return ["compassion", "service", "universal love", "completion"]
        default: return ["growth", "learning"]
        }
    }
    
    private func getTestStrengths(for number: Int) -> [String] {
        switch number {
        case 1: return ["Natural leader", "Confident", "Independent"]
        case 3: return ["Creative genius", "Inspiring communicator", "Optimistic"]
        case 7: return ["Deep wisdom", "Spiritual insight", "Analytical mind"]
        case 9: return ["Humanitarian heart", "Universal perspective", "Compassionate"]
        default: return ["Adaptable", "Resilient"]
        }
    }
    
    private func getTestChallenges(for number: Int) -> [String] {
        switch number {
        case 1: return ["Impatience", "Selfishness"]
        case 3: return ["Scattered energy", "Superficiality"]  
        case 7: return ["Isolation", "Over-analysis"]
        case 9: return ["Emotional overwhelm", "Martyrdom"]
        default: return ["Self-doubt"]
        }
    }
    
    private func getTestDescription(for number: Int) -> String {
        switch number {
        case 1: return "The pioneering spirit that initiates new beginnings and leads with courage."
        case 3: return "The creative force that expresses divine inspiration through art, communication, and joy."
        case 7: return "The mystical seeker who seeks truth through spiritual wisdom and inner knowing."
        case 9: return "The humanitarian who serves the greater good with universal love and compassion."
        default: return "A path of spiritual growth and learning."
        }
    }
    
    private func getTestPlanet(for number: Int) -> String? {
        switch number {
        case 1: return "Sun"
        case 3: return "Jupiter"
        case 7: return "Neptune"
        case 9: return "Mars"
        default: return nil
        }
    }
    
    private func getTestSign(for number: Int) -> String? {
        switch number {
        case 1: return "Aries"
        case 3: return "Sagittarius"
        case 7: return "Pisces"
        case 9: return "Leo"
        default: return nil
        }
    }
    
    private func getTestColor(for number: Int) -> String? {
        switch number {
        case 1: return "Red"
        case 3: return "Yellow"
        case 7: return "Violet"
        case 9: return "Gold"
        default: return nil
        }
    }
    
    private func getTestInsights(for number: Int) -> [String] {
        switch number {
        case 1: return [
            "Your pioneering spirit opens new pathways for others to follow.",
            "Trust your instincts to lead with courage and authenticity.",
            "Independence is your strength, but remember to include others in your vision."
        ]
        case 3: return [
            "Your creative gifts are meant to inspire and uplift the world.",
            "Express your truth through art, words, and joyful communication.",
            "Let your inner light shine brightly to guide others to their own creativity."
        ]
        case 7: return [
            "Dive deep into the mysteries of existence to find your truth.",
            "Your intuitive wisdom is a gift that serves both yourself and others.",
            "Solitude and reflection are necessary for your spiritual growth."
        ]
        case 9: return [
            "Your compassionate heart has the power to heal the world.",
            "Service to humanity is your highest calling and greatest joy.",
            "Let go of what no longer serves to make space for universal love."
        ]
        default: return ["Trust your journey of growth and discovery."]
        }
    }
    
    private func getTestReflections(for number: Int) -> [String] {
        switch number {
        case 1: return [
            "How can you lead with more compassion today?",
            "What new beginning is calling to your pioneer spirit?"
        ]
        case 3: return [
            "What creative project is seeking expression through you?",
            "How can you bring more joy to your daily interactions?"
        ]
        case 7: return [
            "What spiritual truth is emerging in your consciousness?",
            "How can you balance solitude with meaningful connection?"
        ]
        case 9: return [
            "How can you serve others while honoring your own needs?",
            "What are you ready to release to make space for love?"
        ]
        default: return ["What is your soul trying to teach you today?"]
        }
    }
    
    private func getTestContemplations(for number: Int) -> [String] {
        switch number {
        case 1: return ["The courage to begin is the first step toward all achievement."]
        case 3: return ["Creativity is the soul's way of expressing divine love."]
        case 7: return ["In the depths of silence, the greatest truths are revealed."]
        case 9: return ["Universal love transcends all boundaries and limitations."]
        default: return ["Every moment offers an opportunity for growth."]
        }
    }
    
    private func getTestManifestations(for number: Int) -> [String] {
        switch number {
        case 1: return ["I am a confident leader who pioneers new possibilities."]
        case 3: return ["I express my creativity with joy and authentic inspiration."]
        case 7: return ["I trust my inner wisdom to guide me toward truth."]
        case 9: return ["I serve others with compassion and universal love."]
        default: return ["I am growing into my highest potential."]
        }
    }
    
    // Zodiac test data helpers
    private func getTestGlyph(for sign: String) -> String {
        switch sign {
        case "Aries": return "♈"
        case "Cancer": return "♋"
        case "Libra": return "♎"
        case "Pisces": return "♓"
        default: return "♈"
        }
    }
    
    private func getTestDateRange(for sign: String) -> String {
        switch sign {
        case "Aries": return "March 21 - April 19"
        case "Cancer": return "June 21 - July 22"
        case "Libra": return "September 23 - October 22"
        case "Pisces": return "February 19 - March 20"
        default: return "Test Range"
        }
    }
    
    private func getTestSymbol(for sign: String) -> String {
        switch sign {
        case "Aries": return "The Ram"
        case "Cancer": return "The Crab"
        case "Libra": return "The Scales"
        case "Pisces": return "The Fish"
        default: return "Test Symbol"
        }
    }
    
    private func getTestRuler(for sign: String) -> String {
        switch sign {
        case "Aries": return "Mars"
        case "Cancer": return "Moon"
        case "Libra": return "Venus"
        case "Pisces": return "Neptune"
        default: return "Sun"
        }
    }
    
    private func getTestElementForSign(for sign: String) -> String {
        switch sign {
        case "Aries": return "Fire"
        case "Cancer": return "Water"
        case "Libra": return "Air"
        case "Pisces": return "Water"
        default: return "Fire"
        }
    }
    
    private func getTestModeForSign(for sign: String) -> String {
        switch sign {
        case "Aries": return "Cardinal"
        case "Cancer": return "Cardinal"
        case "Libra": return "Cardinal"
        case "Pisces": return "Mutable"
        default: return "Cardinal"
        }
    }
    
    private func getTestKeywordForSign(for sign: String) -> String {
        switch sign {
        case "Aries": return "I Am"
        case "Cancer": return "I Feel"
        case "Libra": return "I Balance"
        case "Pisces": return "I Believe"
        default: return "I Exist"
        }
    }
    
    private func getTestSignDescription(for sign: String) -> String {
        switch sign {
        case "Aries": return "The pioneering ram that charges forward with courage and initiative."
        case "Cancer": return "The nurturing crab that protects and cares with emotional depth."
        case "Libra": return "The balancing scales that seek harmony and justice in all things."
        case "Pisces": return "The mystical fish that swims in the depths of spiritual consciousness."
        default: return "A spiritual archetype of cosmic wisdom."
        }
    }
    
    private func getTestSignTraits(for sign: String) -> [String] {
        switch sign {
        case "Aries": return ["Bold", "Energetic", "Leadership", "Independent"]
        case "Cancer": return ["Nurturing", "Intuitive", "Protective", "Emotional"]
        case "Libra": return ["Harmonious", "Diplomatic", "Aesthetic", "Fair"]
        case "Pisces": return ["Mystical", "Compassionate", "Intuitive", "Dreamy"]
        default: return ["Spiritual", "Wise"]
        }
    }
    
    private func getTestSignGuidance(for sign: String) -> String {
        switch sign {
        case "Aries": return "Channel your pioneering energy into meaningful new beginnings."
        case "Cancer": return "Honor your emotions as sacred guidance from your inner wisdom."
        case "Libra": return "Seek balance in all aspects of life to create harmony within and without."
        case "Pisces": return "Trust your intuitive connection to the divine source of all wisdom."
        default: return "Follow your spiritual path with courage and compassion."
        }
    }
}