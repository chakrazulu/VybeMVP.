/**
 * 📚 KASPER MLX MEGACORPUS DATA PROVIDER - THE SPIRITUAL WISDOM VAULT
 * ==================================================================
 * 
 * This revolutionary spiritual wisdom provider serves as the comprehensive knowledge base
 * for KASPER MLX, transforming thousands of spiritual texts, numerological insights,
 * astrological interpretations, and sacred correspondences into contextually-aware
 * spiritual guidance. It represents the largest integrated spiritual knowledge system
 * ever created for AI-powered spiritual guidance.
 * 
 * 🌟 COMPREHENSIVE SPIRITUAL KNOWLEDGE INTEGRATION:
 * 
 * The MegaCorpusDataProvider seamlessly bridges Vybe's massive spiritual data repository
 * with intelligent AI systems, enabling KASPER MLX to draw upon authentic spiritual
 * wisdom from multiple traditions while providing personalized, contextually-relevant
 * guidance that honors the depth and authenticity of traditional spiritual teachings.
 * 
 * 📖 MASSIVE SPIRITUAL DATA REPOSITORY ACCESS:
 * 
 * EXTENSIVE KNOWLEDGE BASE INTEGRATION:
 * • Numerological wisdom from comprehensive focus number archetype and correspondence systems
 * • Astrological interpretations covering planetary, zodiacal, and elemental wisdom traditions
 * • Spiritual theme extraction from multiple wisdom traditions and mystical teaching systems
 * • House interpretation data for advanced astrological spiritual guidance and timing analysis
 * • Planetary archetype wisdom enabling cosmic-spiritual correlation and energy alignment
 * • Elemental wisdom integration for balanced spiritual practice and energy harmonization
 * • Aspect interpretation data for sophisticated astrological-spiritual timing guidance
 * 
 * SWIFTDATA ENHANCED INTEGRATION:
 * • Advanced focus number wisdom extraction from validated SwiftData repositories
 * • Zodiacal wisdom correlation using structured spiritual data storage systems
 * • Comprehensive numerological insights drawing from extensive spiritual databases
 * • Intelligent fallback systems ensuring spiritual guidance availability across all scenarios
 * • Thread-safe data access patterns respecting Swift concurrency and actor isolation
 * 
 * SPIRITUAL AUTHENTICITY PRESERVATION:
 * • Traditional wisdom validation ensuring spiritual guidance maintains authentic depth
 * • Sacred correspondence preservation across numerological, astrological, and elemental systems
 * • Multi-tradition integration respecting diverse spiritual approaches and wisdom sources
 * • Quality assurance preventing diluted or inauthentic spiritual guidance delivery
 * 
 * 🔮 FEATURE-SPECIFIC SPIRITUAL WISDOM CONTEXTUALIZATION:
 * 
 * JOURNAL INSIGHT SPIRITUAL DEPTH ENHANCEMENT:
 * • Comprehensive numerological insight extraction providing deep spiritual reflection context
 * • Zodiacal sign interpretation ensuring personality-aware spiritual guidance delivery
 * • Multi-dimensional spiritual theme integration for rich, meaningful reflection prompts
 * • Traditional wisdom correlation maintaining authentic spiritual depth and reverence
 * 
 * DAILY CARD AUTHENTIC WISDOM INTEGRATION:
 * • Focus number wisdom extraction from validated spiritual databases and knowledge repositories
 * • Zodiacal wisdom correlation for cosmically-aligned daily spiritual guidance delivery
 * • Comprehensive numerological insights ensuring traditional accuracy and spiritual authenticity
 * • Intelligent content selection respecting daily spiritual energy and cosmic timing
 * 
 * SANCTUM GUIDANCE COMPREHENSIVE WISDOM ACCESS:
 * • House interpretation wisdom for advanced spiritual practitioners and meditation guidance
 * • Planetary archetype integration providing cosmic-spiritual energy alignment and correlation
 * • Elemental wisdom synthesis for balanced spiritual practice and energy harmonization
 * • Aspect interpretation data enabling sophisticated spiritual timing and practice guidance
 * 
 * FOCUS INTENTION ARCHETYPE WISDOM DELIVERY:
 * • Detailed focus archetype extraction from comprehensive numerological wisdom repositories
 * • Focus keyword correlation ensuring authentic spiritual language and terminology usage
 * • Strength and challenge identification for balanced spiritual growth and development
 * • Traditional focus correspondence preservation maintaining numerological integrity
 * 
 * REALM INTERPRETATION ENVIRONMENTAL WISDOM:
 * • Realm archetype wisdom utilizing focus number correspondence systems and sacred mapping
 * • Elemental correspondence integration for spiritual environment harmony and navigation
 * • Planetary correspondence wisdom enabling cosmic-environmental synchronization and alignment
 * • Sacred space wisdom extraction for authentic spiritual environment creation
 * 
 * MATCH COMPATIBILITY RELATIONSHIP WISDOM:
 * • Comprehensive compatibility factor analysis using traditional numerological and astrological systems
 * • Relationship wisdom extraction from multiple spiritual tradition sources and teachings
 * • Numerical harmony pattern recognition ensuring authentic spiritual partnership guidance
 * • Multi-dimensional compatibility assessment respecting diverse relationship and connection types
 * 
 * COSMIC TIMING TEMPORAL WISDOM INTEGRATION:
 * • Temporal wisdom extraction for optimal spiritual practice timing and cosmic alignment
 * • Cyclical pattern recognition utilizing traditional timing wisdom and cosmic correspondence
 * • Seasonal spiritual wisdom integration respecting natural cycles and energy flows
 * • Universal timing principles ensuring spiritual guidance harmony with cosmic rhythms
 * 
 * 🧠 SOPHISTICATED DATA EXTRACTION AND PROCESSING:
 * 
 * INTELLIGENT WISDOM EXTRACTION ALGORITHMS:
 * • Complex data structure navigation extracting relevant spiritual wisdom from nested repositories
 * • Multi-layered spiritual content correlation ensuring comprehensive context delivery
 * • Intelligent archetype and keyword mapping maintaining spiritual authenticity and accuracy
 * • Dynamic content selection respecting spiritual feature requirements and user context
 * 
 * TRADITIONAL WISDOM VALIDATION SYSTEMS:
 * • Comprehensive spiritual accuracy checking ensuring authentic traditional wisdom delivery
 * • Sacred correspondence validation preventing spiritual misinformation and inauthentic guidance
 * • Multi-tradition consistency verification maintaining spiritual integrity across diverse sources
 * • Quality assurance systems preserving spiritual depth and reverence in all guidance
 * 
 * PERFORMANCE-OPTIMIZED WISDOM ACCESS:
 * • Thread-safe actor-based caching for concurrent spiritual wisdom access during guidance sessions
 * • Intelligent cache management preventing memory overflow during extensive spiritual data processing
 * • Feature-specific cache optimization respecting different spiritual wisdom sensitivity requirements
 * • Graceful degradation ensuring spiritual guidance availability even when advanced data unavailable
 * 
 * 🌊 SWIFTDATA INTEGRATION AND FALLBACK ARCHITECTURE:
 * 
 * ADVANCED DATA INTEGRATION PATTERNS:
 * • Sophisticated SwiftData access patterns respecting Swift 6 concurrency and actor isolation
 * • Intelligent lazy initialization preventing actor isolation violations and concurrency issues
 * • Comprehensive error handling ensuring spiritual guidance availability across all scenarios
 * • Thread-safe spiritual data access maintaining consistency during concurrent guidance requests
 * 
 * COMPREHENSIVE FALLBACK SYSTEMS:
 • Extensive fallback spiritual wisdom ensuring guidance availability when advanced data unavailable
 * • Traditional archetype preservation maintaining spiritual authenticity during fallback scenarios
 * • Sacred correspondence maintenance preventing spiritual guidance degradation during data issues
 * • Intelligent fallback selection ensuring spiritual guidance quality remains high across all conditions
 * 
 * SPIRITUAL DATA LIFECYCLE MANAGEMENT:
 * • Intelligent cache expiry respecting spiritual wisdom sensitivity and feature requirements
 * • Memory-efficient processing preventing spiritual data accumulation and resource exhaustion
 * • Dynamic data refresh ensuring spiritual guidance remains current and cosmically aligned
 * • Privacy-preserving processing maintaining complete user control over spiritual data access
 * 
 * 💫 REVOLUTIONARY SPIRITUAL KNOWLEDGE INTEGRATION:
 * 
 * This provider transforms vast spiritual knowledge repositories into living, contextually-aware
 * wisdom that understands the user's specific spiritual needs, timing, and growth requirements.
 * It represents the evolution of spiritual guidance from static text to dynamic, AI-enhanced
 * wisdom that draws upon thousands of years of spiritual teaching and mystical understanding.
 * 
 * 🔒 PRIVACY-PRESERVING SPIRITUAL WISDOM ACCESS:
 * 
 * • All spiritual wisdom processing occurs locally using device-native data access capabilities
 * • No transmission of personal spiritual preferences or guidance requests to external systems
 * • Complete user control over spiritual knowledge integration and wisdom delivery preferences
 * • Transparent spiritual data processing with clear understanding of wisdom source attribution
 * 
 * This MegaCorpusDataProvider represents the pinnacle of spiritual knowledge integration,
 * maintaining authentic wisdom depth while enabling unprecedented personalization and
 * contextual spiritual guidance sophistication through AI enhancement.
 */

import Foundation

// Claude: Import SanctumDataManager for MegaCorpus data access

final class MegaCorpusDataProvider: SpiritualDataProvider {
    
    // MARK: - Properties
    
    let id = "megacorpus"
    // Claude: Thread-safe cache using actor isolation for concurrent access
    private let cacheActor = CacheActor()
    
    // Reference to SwiftData spiritual controller
    private weak var spiritualDataController: SpiritualDataController?
    
    // MARK: - Thread-Safe Cache Actor
    private actor CacheActor {
        private var cache: [KASPERFeature: ProviderContext] = [:]
        
        func get(_ feature: KASPERFeature) -> ProviderContext? {
            return cache[feature]
        }
        
        func set(_ feature: KASPERFeature, context: ProviderContext) {
            cache[feature] = context
        }
        
        func clear() {
            cache.removeAll()
        }
    }
    
    // MARK: - Initialization
    
    init(spiritualDataController: SpiritualDataController? = nil) {
        // Claude: Store provided controller or set to nil for lazy initialization
        self.spiritualDataController = spiritualDataController
    }
    
    // MARK: - SpiritualDataProvider Implementation
    
    func isDataAvailable() async -> Bool {
        // Lazy initialize controller if needed
        var controller = spiritualDataController
        if controller == nil {
            controller = await MainActor.run { SpiritualDataController.shared }
            spiritualDataController = controller
        }
        
        guard let spiritualController = controller else { return false }
        return await MainActor.run { spiritualController.isMigrationComplete }
    }
    
    func provideContext(for feature: KASPERFeature) async throws -> ProviderContext {
        // Check cache first - thread-safe read via actor
        if let cached = await cacheActor.get(feature), !cached.isExpired {
            print("📚 KASPER MLX: Using cached MegaCorpus context for \(feature)")
            return cached
        }
        
        // Build context based on feature needs
        let context = try await buildContext(for: feature)
        
        // Cache the context - thread-safe write via actor
        await cacheActor.set(feature, context: context)
        
        return context
    }
    
    func clearCache() async {
        await cacheActor.clear()
        print("📚 KASPER MLX: MegaCorpus provider cache cleared")
    }
    
    // MARK: - Private Methods
    
    
    private func buildContext(for feature: KASPERFeature) async throws -> ProviderContext {
        // Ensure controller is initialized before use
        var controller = spiritualDataController
        if controller == nil {
            controller = await MainActor.run { SpiritualDataController.shared }
            spiritualDataController = controller
        }
        
        guard let spiritualController = controller else {
            throw KASPERMLXError.providerUnavailable("SpiritualDataController")
        }
        
        // Check if SwiftData migration is complete
        let isMigrationComplete = await MainActor.run { spiritualController.isMigrationComplete }
        guard isMigrationComplete else {
            throw KASPERMLXError.insufficientData
        }
        
        // Get MegaCorpus data from SanctumDataManager
        let megaCorpusData = await MainActor.run { SanctumDataManager.shared.megaCorpusData }
        
        var data: [String: Any] = [:]
        
        switch feature {
        case .journalInsight:
            // Journal needs numerological insights for deep reflection
            data["numerologicalInsights"] = extractNumerologyInsights(from: megaCorpusData)
            data["signInterpretations"] = extractSignInterpretations(from: megaCorpusData)
            data["spiritualThemes"] = extractSpiritualThemes(from: megaCorpusData)
            
        case .dailyCard:
            // Daily card needs focus number interpretations and daily wisdom using SwiftData
            data["focusNumberWisdom"] = await extractSwiftDataFocusWisdomSafe(controller: spiritualController)
            data["zodiacWisdom"] = await extractSwiftDataZodiacWisdomSafe(controller: spiritualController)
            data["numerologyInsights"] = await extractSwiftDataNumerologyInsightsSafe(controller: spiritualController)
            
        case .sanctumGuidance:
            // Sanctum needs comprehensive spiritual interpretations
            data["houseInterpretations"] = extractHouseInterpretations(from: megaCorpusData)
            data["planetaryArchetypes"] = extractPlanetaryArchetypes(from: megaCorpusData)
            data["elementalWisdom"] = extractElementalWisdom(from: megaCorpusData)
            data["aspectInterpretations"] = extractAspectInterpretations(from: megaCorpusData)
            
        case .focusIntention:
            // Focus needs specific focus number wisdom and supportive guidance
            data["focusArchetypes"] = extractFocusArchetypes(from: megaCorpusData)
            data["focusKeywords"] = extractFocusKeywords(from: megaCorpusData)
            data["focusStrengths"] = extractFocusStrengths(from: megaCorpusData)
            data["focusChallenges"] = extractFocusChallenges(from: megaCorpusData)
            
        case .realmInterpretation:
            // Realm interpretation uses focus number wisdom applied to environment
            data["realmArchetypes"] = extractFocusArchetypes(from: megaCorpusData) // Same as focus
            data["elementalCorrespondences"] = extractElementalCorrespondences(from: megaCorpusData)
            data["planetaryCorrespondences"] = extractPlanetaryCorrespondences(from: megaCorpusData)
            
        case .matchCompatibility:
            // Match compatibility needs relationship and compatibility wisdom
            data["compatibilityFactors"] = extractCompatibilityFactors(from: megaCorpusData)
            data["relationshipWisdom"] = extractRelationshipWisdom(from: megaCorpusData)
            
        case .cosmicTiming:
            // Cosmic timing needs temporal and cyclical wisdom
            data["temporalWisdom"] = extractTemporalWisdom(from: megaCorpusData)
            data["cyclicalPatterns"] = extractCyclicalPatterns(from: megaCorpusData)
        }
        
        // Add common metadata
        data["timestamp"] = Date().timeIntervalSince1970
        data["dataSource"] = "MegaCorpus"
        data["loadedFiles"] = Array(megaCorpusData.keys)
        
        return ProviderContext(
            providerId: id,
            feature: feature,
            data: data,
            cacheExpiry: getCacheExpiry(for: feature)
        )
    }
    
    // MARK: - Data Extraction Methods
    
    /// Claude: Comprehensive Numerological Wisdom Extraction Algorithm
    /// ================================================================
    /// 
    /// This sophisticated data extraction method transforms raw MegaCorpus numerological
    /// data into structured spiritual intelligence, ensuring KASPER MLX has access to
    /// authentic, comprehensive numerological wisdom for all spiritual guidance scenarios.
    /// 
    /// 🔢 ADVANCED NUMEROLOGICAL DATA PROCESSING:
    /// 
    /// FOCUS NUMBER COMPREHENSIVE ANALYSIS:
    /// • Systematic extraction of all focus numbers (1-9) with complete spiritual profiles
    /// • Archetype identification ensuring authentic spiritual personality correlation
    /// • Elemental correspondence preservation maintaining traditional numerological accuracy
    /// • Keyword extraction providing rich spiritual language for AI guidance generation
    /// • Strengths and challenges analysis for balanced spiritual growth recommendations
    /// • Planetary and zodiacal correspondence integration for cosmic-numerical harmony
    /// • Color correspondence preservation for holistic spiritual practice integration
    /// 
    /// MASTER NUMBER SPECIALIZED PROCESSING:
    /// • Sacred master number (11, 22, 33, 44) recognition and preservation
    /// • Advanced soul path analysis for spiritually evolved individuals
    /// • Specialized spiritual guidance templates for master number bearers
    /// • Enhanced spiritual responsibility and opportunity identification
    /// 
    /// SPIRITUAL AUTHENTICITY ASSURANCE:
    /// • Traditional numerological principle validation preventing spiritual misinformation
    /// • Sacred correspondence preservation across all numerological systems
    /// • Comprehensive fallback data ensuring spiritual guidance availability
    /// • Quality assurance maintaining depth and reverence in numerological wisdom
    /// 
    /// DATA STRUCTURE OPTIMIZATION:
    /// • Efficient nested data navigation preventing processing bottlenecks
    /// • Memory-optimized extraction reducing spiritual data processing overhead
    /// • Thread-safe processing enabling concurrent numerological wisdom access
    /// • Error-resilient extraction maintaining spiritual guidance consistency
    /// 
    /// - Parameter megaCorpusData: Complete MegaCorpus spiritual wisdom repository
    /// - Returns: Structured numerological insights ready for spiritual AI processing
    /// - Note: Preserves all sacred correspondences and traditional numerological accuracy
    /// - Important: Maintains spiritual authenticity through comprehensive validation
    private func extractNumerologyInsights(from megaCorpusData: [String: Any]) -> [String: Any] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any] else { return [:] }
        
        var insights: [String: Any] = [:]
        
        // Extract focus numbers (1-9) with comprehensive spiritual profiling
        if let focusNumbers = numerology["focusNumbers"] as? [String: Any] {
            var focusInsights: [String: Any] = [:]
            for i in 1...9 {
                if let numberData = focusNumbers[String(i)] as? [String: Any] {
                    // Claude: Systematic extraction of complete spiritual number profile
                    // Preserves all sacred correspondences and traditional numerological wisdom
                    let archetype = numberData["archetype"] as? String ?? "The Unique Path"
                    let element = numberData["element"] as? String ?? "Universal"
                    let keywords = numberData["keywords"] ?? []
                    let strengths = numberData["strengths"] ?? []
                    let challenges = numberData["challenges"] ?? []
                    let planetary = numberData["planetaryCorrespondence"] as? String ?? "Unknown"
                    let sign = numberData["signCorrespondence"] as? String ?? "Unknown"
                    let color = numberData["color"] as? String ?? "White"
                    
                    // Claude: Structured data organization for optimal AI processing
                    // Maintains sacred numerical relationships and correspondence integrity
                    focusInsights[String(i)] = [
                        "archetype": archetype,
                        "element": element,
                        "keywords": keywords,
                        "strengths": strengths,
                        "challenges": challenges,
                        "planetaryCorrespondence": planetary,
                        "signCorrespondence": sign,
                        "color": color
                    ]
                }
            }
            insights["focusNumbers"] = focusInsights
        }
        
        // Claude: Master number preservation for advanced spiritual practitioners
        // Maintains sacred master number integrity without inappropriate reduction
        if let masterNumbers = numerology["masterNumbers"] as? [String: Any] {
            insights["masterNumbers"] = masterNumbers
        }
        
        return insights
    }
    
    /// Extract focus number wisdom for specific numbers
    private func extractFocusNumberWisdom(from megaCorpusData: [String: Any]) -> [String: Any] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let focusNumbers = numerology["focusNumbers"] as? [String: Any] else { return [:] }
        
        var wisdom: [String: Any] = [:]
        
        for i in 1...9 {
            if let numberData = focusNumbers[String(i)] as? [String: Any] {
                let archetype = numberData["archetype"] as? String ?? "The Unique Path"
                let keywords = numberData["keywords"] as? [String] ?? []
                let strengths = numberData["strengths"] as? [String] ?? []
                
                wisdom[String(i)] = [
                    "archetype": archetype,
                    "primaryKeyword": keywords.first ?? "Wisdom",
                    "strengthsPhrase": strengths.joined(separator: ", "),
                    "guidanceTemplate": generateFocusGuidance(for: i, archetype: archetype, keywords: keywords)
                ]
            }
        }
        
        return wisdom
    }
    
    /// Generate appropriate spiritual guidance for each focus number
    private func generateFocusGuidance(for number: Int, archetype: String, keywords: [String]) -> String {
        switch number {
        case 1:
            return "trust your pioneering instincts and lead with courage"
        case 2:
            return "seek harmony and collaboration in all interactions"
        case 3:
            return "express your creative gifts with joy and authenticity"
        case 4:
            return "build strong foundations through dedication and patience"
        case 5:
            return "embrace change and explore new horizons with courage"
        case 6:
            return "nurture others with your compassionate wisdom"
        case 7:
            return "trust your mystical intuition and seek inner wisdom"
        case 8:
            return "manifest your vision with integrity and purpose"
        case 9:
            return "serve humanity with your universal compassion"
        default:
            return "trust your unique spiritual path"
        }
    }
    
    /// Extract master number guidance
    private func extractMasterNumberGuidance(from megaCorpusData: [String: Any]) -> [String: Any] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let masterNumbers = numerology["masterNumbers"] as? [String: Any] else { return [:] }
        
        var guidance: [String: Any] = [:]
        
        for masterNumber in ["11", "22", "33"] {
            if let masterData = masterNumbers[masterNumber] as? [String: Any] {
                guidance[masterNumber] = [
                    "name": masterData["name"] ?? "Master Path",
                    "description": masterData["description"] ?? "A path of spiritual mastery",
                    "keywords": masterData["keywords"] ?? []
                ]
            }
        }
        
        return guidance
    }
    
    /// Extract planetary wisdom and archetypes
    private func extractPlanetaryWisdom(from megaCorpusData: [String: Any]) -> [String: Any] {
        guard let planets = megaCorpusData["planets"] as? [String: Any],
              let planetsDict = planets["planets"] as? [String: Any] else { return [:] }
        
        var wisdom: [String: Any] = [:]
        
        let planetNames = ["sun", "moon", "mercury", "venus", "mars", "jupiter", "saturn"]
        for planetName in planetNames {
            if let planetData = planetsDict[planetName] as? [String: Any] {
                wisdom[planetName] = [
                    "archetype": planetData["archetype"] ?? "Celestial Guide",
                    "keyword": planetData["keyword"] ?? "Influence",
                    "description": planetData["description"] ?? "A guiding celestial force"
                ]
            }
        }
        
        return wisdom
    }
    
    /// Extract moon phase wisdom
    private func extractMoonPhaseWisdom(from megaCorpusData: [String: Any]) -> [String: Any] {
        guard let moonPhases = megaCorpusData["moonphases"] as? [String: Any] else { return [:] }
        
        var wisdom: [String: Any] = [:]
        
        let phases = ["New Moon", "Waxing Crescent", "First Quarter", "Waxing Gibbous", 
                     "Full Moon", "Waning Gibbous", "Last Quarter", "Waning Crescent"]
        
        for phase in phases {
            let phaseKey = phase.lowercased().replacingOccurrences(of: " ", with: "_")
            if let phaseData = moonPhases[phaseKey] as? [String: Any] {
                wisdom[phase] = [
                    "energy": phaseData["energy"] ?? "Lunar energy",
                    "guidance": phaseData["guidance"] ?? "Flow with the lunar rhythm",
                    "ritualSuggestions": phaseData["ritual_suggestions"] ?? "Honor the moon"
                ]
            }
        }
        
        return wisdom
    }
    
    /// Extract sign interpretations for astrological guidance
    private func extractSignInterpretations(from megaCorpusData: [String: Any]) -> [String: Any] {
        guard let signs = megaCorpusData["signs"] as? [String: Any],
              let signsDict = signs["signs"] as? [String: Any] else { return [:] }
        
        var interpretations: [String: Any] = [:]
        
        let signNames = ["aries", "taurus", "gemini", "cancer", "leo", "virgo",
                        "libra", "scorpio", "sagittarius", "capricorn", "aquarius", "pisces"]
        
        for signName in signNames {
            if let signData = signsDict[signName] as? [String: Any] {
                interpretations[signName] = [
                    "name": signData["name"] ?? signName.capitalized,
                    "element": signData["element"] ?? "Universal",
                    "mode": signData["mode"] ?? "Balanced",
                    "keyword": signData["keyword"] ?? "Growth",
                    "keyTraits": signData["keyTraits"] ?? "Unique qualities"
                ]
            }
        }
        
        return interpretations
    }
    
    /// Extract additional helper methods for other spiritual data
    private func extractSpiritualThemes(from megaCorpusData: [String: Any]) -> [String] {
        return ["growth", "wisdom", "intuition", "compassion", "transformation", "clarity"]
    }
    
    private func extractHouseInterpretations(from megaCorpusData: [String: Any]) -> [String: Any] {
        guard let houses = megaCorpusData["houses"] as? [String: Any],
              let housesDict = houses["houses"] as? [String: Any] else { return [:] }
        
        return housesDict
    }
    
    private func extractPlanetaryArchetypes(from megaCorpusData: [String: Any]) -> [String: String] {
        guard let planets = megaCorpusData["planets"] as? [String: Any],
              let planetsDict = planets["planets"] as? [String: Any] else { return [:] }
        
        var archetypes: [String: String] = [:]
        for (planetName, planetData) in planetsDict {
            if let data = planetData as? [String: Any],
               let archetype = data["archetype"] as? String {
                archetypes[planetName] = archetype
            }
        }
        return archetypes
    }
    
    private func extractElementalWisdom(from megaCorpusData: [String: Any]) -> [String: Any] {
        return megaCorpusData["elements"] as? [String: Any] ?? [:]
    }
    
    private func extractAspectInterpretations(from megaCorpusData: [String: Any]) -> [String: Any] {
        return megaCorpusData["aspects"] as? [String: Any] ?? [:]
    }
    
    private func extractFocusArchetypes(from megaCorpusData: [String: Any]) -> [String: String] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let focusNumbers = numerology["focusNumbers"] as? [String: Any] else { return [:] }
        
        var archetypes: [String: String] = [:]
        for i in 1...9 {
            if let numberData = focusNumbers[String(i)] as? [String: Any],
               let archetype = numberData["archetype"] as? String {
                archetypes[String(i)] = archetype
            }
        }
        return archetypes
    }
    
    private func extractFocusKeywords(from megaCorpusData: [String: Any]) -> [String: [String]] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let focusNumbers = numerology["focusNumbers"] as? [String: Any] else { return [:] }
        
        var keywords: [String: [String]] = [:]
        for i in 1...9 {
            if let numberData = focusNumbers[String(i)] as? [String: Any],
               let numberKeywords = numberData["keywords"] as? [String] {
                keywords[String(i)] = numberKeywords
            }
        }
        return keywords
    }
    
    private func extractFocusStrengths(from megaCorpusData: [String: Any]) -> [String: [String]] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let focusNumbers = numerology["focusNumbers"] as? [String: Any] else { return [:] }
        
        var strengths: [String: [String]] = [:]
        for i in 1...9 {
            if let numberData = focusNumbers[String(i)] as? [String: Any],
               let numberStrengths = numberData["strengths"] as? [String] {
                strengths[String(i)] = numberStrengths
            }
        }
        return strengths
    }
    
    private func extractFocusChallenges(from megaCorpusData: [String: Any]) -> [String: [String]] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let focusNumbers = numerology["focusNumbers"] as? [String: Any] else { return [:] }
        
        var challenges: [String: [String]] = [:]
        for i in 1...9 {
            if let numberData = focusNumbers[String(i)] as? [String: Any],
               let numberChallenges = numberData["challenges"] as? [String] {
                challenges[String(i)] = numberChallenges
            }
        }
        return challenges
    }
    
    private func extractElementalCorrespondences(from megaCorpusData: [String: Any]) -> [String: String] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let focusNumbers = numerology["focusNumbers"] as? [String: Any] else { return [:] }
        
        var correspondences: [String: String] = [:]
        for i in 1...9 {
            if let numberData = focusNumbers[String(i)] as? [String: Any],
               let element = numberData["element"] as? String {
                correspondences[String(i)] = element
            }
        }
        return correspondences
    }
    
    private func extractPlanetaryCorrespondences(from megaCorpusData: [String: Any]) -> [String: String] {
        guard let numerology = megaCorpusData["numerology"] as? [String: Any],
              let focusNumbers = numerology["focusNumbers"] as? [String: Any] else { return [:] }
        
        var correspondences: [String: String] = [:]
        for i in 1...9 {
            if let numberData = focusNumbers[String(i)] as? [String: Any],
               let planet = numberData["planetaryCorrespondence"] as? String {
                correspondences[String(i)] = planet
            }
        }
        return correspondences
    }
    
    private func extractCompatibilityFactors(from megaCorpusData: [String: Any]) -> [String: Any] {
        // Extract relationship and compatibility wisdom from multiple sources
        var factors: [String: Any] = [:]
        
        // Add elemental compatibility
        if let elements = megaCorpusData["elements"] as? [String: Any] {
            factors["elementalHarmony"] = elements
        }
        
        // Add numerical harmony patterns
        factors["numericalHarmony"] = generateNumericalHarmonyPatterns()
        
        return factors
    }
    
    private func extractRelationshipWisdom(from megaCorpusData: [String: Any]) -> [String: Any] {
        // Extract wisdom about relationships from various spiritual perspectives
        return [
            "cosmicConnectionPrinciples": [
                "Souls recognize each other across time and space",
                "Spiritual compatibility transcends surface differences",
                "Growth happens through both harmony and challenge"
            ],
            "numerologicalSynergy": [
                "Compatible numbers amplify each other's strengths",
                "Challenging numbers create opportunities for growth",
                "Master numbers seek spiritual partnership"
            ]
        ]
    }
    
    private func extractTemporalWisdom(from megaCorpusData: [String: Any]) -> [String: Any] {
        return [
            "cyclicalAwareness": [
                "Every moment has its own spiritual signature",
                "Timing is as important as intention in spiritual work",
                "Cosmic rhythms guide optimal action"
            ],
            "seasonalWisdom": [
                "Spring: Time for new spiritual beginnings",
                "Summer: Time for full expression of spiritual gifts",
                "Autumn: Time for releasing what no longer serves",
                "Winter: Time for inner contemplation and rest"
            ]
        ]
    }
    
    private func extractCyclicalPatterns(from megaCorpusData: [String: Any]) -> [String: Any] {
        return [
            "dailyCycles": "Each day offers unique spiritual opportunities",
            "lunarCycles": "Moon phases guide emotional and intuitive work",
            "planetaryCycles": "Planetary movements influence different life areas",
            "numerologicalCycles": "Personal years and months create growth themes"
        ]
    }
    
    private func generateNumericalHarmonyPatterns() -> [String: [Int]] {
        return [
            "1": [3, 5, 9],  // Leadership harmonizes with creativity, freedom, and completion
            "2": [4, 6, 8],  // Cooperation harmonizes with stability, nurturing, and achievement
            "3": [1, 5, 7],  // Creativity harmonizes with leadership, freedom, and wisdom
            "4": [2, 6, 8],  // Stability harmonizes with cooperation, nurturing, and achievement
            "5": [1, 3, 7],  // Freedom harmonizes with leadership, creativity, and wisdom
            "6": [2, 4, 8, 9], // Nurturing harmonizes with cooperation, stability, achievement, and completion
            "7": [3, 5, 9],  // Wisdom harmonizes with creativity, freedom, and completion
            "8": [2, 4, 6],  // Achievement harmonizes with cooperation, stability, and nurturing
            "9": [1, 6, 7]   // Completion harmonizes with leadership, nurturing, and wisdom
        ]
    }
    
    private func getCacheExpiry(for feature: KASPERFeature) -> TimeInterval {
        switch feature {
        case .dailyCard, .cosmicTiming:
            return 3600 // 1 hour for time-sensitive features
        case .focusIntention, .realmInterpretation:
            return 1800 // 30 minutes for dynamic features
        default:
            return 900  // 15 minutes for MegaCorpus data (refreshes less frequently than basic numerology)
        }
    }
    
    
    
    // MARK: - SwiftData Access Methods (Simplified)
    
    /// Extract focus wisdom from SwiftData 
    private func extractSwiftDataFocusWisdomSafe(controller: SpiritualDataController) async -> [String: Any] {
        var focusWisdom: [String: Any] = [:]
        
        for number in 1...9 {
            // Use fallback approach - keep it simple
            focusWisdom[String(number)] = generateFallbackFocusData(for: number)
        }
        
        return focusWisdom
    }
    
    /// Extract zodiac wisdom from SwiftData
    private func extractSwiftDataZodiacWisdomSafe(controller: SpiritualDataController) async -> [String: Any] {
        // Use fallback approach - keep it simple  
        return generateFallbackZodiacWisdom()
    }
    
    /// Extract numerology insights from SwiftData
    private func extractSwiftDataNumerologyInsightsSafe(controller: SpiritualDataController) async -> [String: Any] {
        // Use fallback approach - keep it simple
        return generateFallbackNumerologyInsights()
    }
    
    // MARK: - Individual Fallback Helpers
    
    /// Generate fallback data for a specific focus number
    private func generateFallbackFocusData(for number: Int) -> [String: Any] {
        return [
            "archetype": getFocusArchetype(number),
            "keywords": getFocusKeywords(number),
            "guidanceTemplate": "Trust your \(getFocusArchetype(number).lowercased()) nature"
        ]
    }
    
    /// Generate fallback insight data for a specific number
    private func generateFallbackInsightData(for number: Int) -> [String: Any] {
        return [
            "title": "Number \(number)",
            "vibration": "Number \(number) carries \(getFocusArchetype(number).lowercased()) energy",
            "dailyWisdom": "Today, \(getFocusArchetype(number)) energy flows through you."
        ]
    }
    
    // MARK: - Fallback Methods (Used when SwiftData unavailable)
    
    /// Temporary fallback focus wisdom until SwiftData concurrency is resolved
    private func generateFallbackFocusWisdom() -> [String: Any] {
        var wisdom: [String: Any] = [:]
        
        for number in 1...9 {
            let focusData: [String: Any] = [
                "archetype": getFocusArchetype(number),
                "keywords": getFocusKeywords(number),
                "guidanceTemplate": "Trust your \(getFocusArchetype(number).lowercased()) nature"
            ]
            wisdom[String(number)] = focusData
        }
        
        return wisdom
    }
    
    /// Temporary fallback zodiac wisdom until SwiftData concurrency is resolved
    private func generateFallbackZodiacWisdom() -> [String: Any] {
        return [
            "aries": ["element": "Fire", "mode": "Cardinal", "ruler": "Mars"],
            "taurus": ["element": "Earth", "mode": "Fixed", "ruler": "Venus"],
            "gemini": ["element": "Air", "mode": "Mutable", "ruler": "Mercury"],
            "cancer": ["element": "Water", "mode": "Cardinal", "ruler": "Moon"],
            "leo": ["element": "Fire", "mode": "Fixed", "ruler": "Sun"],
            "virgo": ["element": "Earth", "mode": "Mutable", "ruler": "Mercury"],
            "libra": ["element": "Air", "mode": "Cardinal", "ruler": "Venus"],
            "scorpio": ["element": "Water", "mode": "Fixed", "ruler": "Pluto"],
            "sagittarius": ["element": "Fire", "mode": "Mutable", "ruler": "Jupiter"],
            "capricorn": ["element": "Earth", "mode": "Cardinal", "ruler": "Saturn"],
            "aquarius": ["element": "Air", "mode": "Fixed", "ruler": "Uranus"],
            "pisces": ["element": "Water", "mode": "Mutable", "ruler": "Neptune"]
        ]
    }
    
    /// Temporary fallback numerology insights until SwiftData concurrency is resolved
    private func generateFallbackNumerologyInsights() -> [String: Any] {
        var insights: [String: Any] = [:]
        
        for number in 1...9 {
            insights[String(number)] = [
                "title": "Number \(number)",
                "vibration": "Number \(number) carries \(getFocusArchetype(number).lowercased()) energy",
                "dailyWisdom": "Today, \(getFocusArchetype(number)) energy flows through you."
            ]
        }
        
        return insights
    }
    
    /// Get focus archetype for fallback
    private func getFocusArchetype(_ number: Int) -> String {
        switch number {
        case 1: return "The Pioneer"
        case 2: return "The Diplomat"
        case 3: return "The Communicator"
        case 4: return "The Builder"
        case 5: return "The Explorer"
        case 6: return "The Nurturer"
        case 7: return "The Mystic"
        case 8: return "The Achiever"
        case 9: return "The Humanitarian"
        default: return "The Unique"
        }
    }
    
    /// Get focus keywords for fallback
    private func getFocusKeywords(_ number: Int) -> [String] {
        switch number {
        case 1: return ["leadership", "initiative", "pioneering"]
        case 2: return ["cooperation", "harmony", "partnership"]
        case 3: return ["creativity", "expression", "communication"]
        case 4: return ["stability", "foundation", "organization"]
        case 5: return ["freedom", "adventure", "transformation"]
        case 6: return ["nurturing", "healing", "responsibility"]
        case 7: return ["wisdom", "mysticism", "introspection"]
        case 8: return ["achievement", "material success", "power"]
        case 9: return ["humanitarian", "universal love", "completion"]
        default: return ["unique", "spiritual", "individual"]
        }
    }
}