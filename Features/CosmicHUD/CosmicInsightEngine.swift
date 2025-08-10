import Foundation

// MARK: - Cosmic Insight Engine
/// Claude: Revolutionary JSON-based insight system for free/paid tiers and KASPER integration
/// This creates the foundation for spiritually intelligent, contextually aware guidance

// MARK: - Insight Schema Models

/// Core insight structure that can be serialized for KASPER
struct CosmicInsight: Codable, Identifiable {
    let id = UUID()
    let timestamp: Date
    let tier: InsightTier
    let type: CosmicInsightType
    let components: InsightComponents
    let display: InsightDisplay
    let kasperMetadata: KASPERMetadata?

    enum CodingKeys: String, CodingKey {
        case timestamp, tier, type, components, display, kasperMetadata
    }
}

/// Free vs Premium insight tiers
enum InsightTier: String, Codable {
    case free = "free"
    case premium = "premium"
    case kasper = "kasper_ai"
}

/// Types of cosmic insights we can generate
enum CosmicInsightType: String, Codable {
    case momentary = "momentary"           // Quick Dynamic Island insights
    case detailed = "detailed"            // Full app insights
    case predictive = "predictive"        // Future guidance (Premium)
    case personalized = "personalized"    // KASPER AI insights
}

/// Structured spiritual data components
struct InsightComponents: Codable {
    let numerology: NumerologyComponent
    let astrology: AstrologyComponent
    let elements: ElementComponent
    let synthesis: String // How they combine
}

struct NumerologyComponent: Codable {
    let rulerNumber: Int
    let realmNumber: Int
    let influence: String
    let theme: String
    let specificAction: String // Actionable ruler guidance
    let detailedGuidance: String // Lock screen detailed guidance
}

struct AstrologyComponent: Codable {
    let dominantAspect: String
    let planets: [String] // Planet names for integration
    let aspectType: String
    let influence: String
    let planetaryNarrative: String // Human-readable planet interaction
    let specificGuidance: String // Actionable planetary guidance
    let detailedMessage: String // Lock screen detailed message
    let orb: Double?
}

struct ElementComponent: Codable {
    let element: String
    let phase: String
    let influence: String
    let application: String // Specific elemental application
    let detailedAction: String // Lock screen detailed action
}

/// How to display the insight
struct InsightDisplay: Codable {
    let compact: String      // For Dynamic Island compact view (single line)
    let expanded: String     // For Dynamic Island expanded view (3 lines)
    let lockScreen: String   // For lock screen widget (2 lines, detailed)
    let meditation: String?  // Optional meditation prompt
}

/// Metadata for KASPER AI integration
struct KASPERMetadata: Codable {
    let contextVector: [String] // User's spiritual context
    let intentClassification: String
    let personalityFactors: [String]
    let readyForAI: Bool
}

// MARK: - Insight Engine

class CosmicInsightEngine {
    static let shared = CosmicInsightEngine()

    private init() {}

    /// Generate insight based on current cosmic state
    func generateInsight(
        rulerNumber: Int,
        realmNumber: Int,
        aspectDisplay: String,
        element: String,
        tier: InsightTier = .free
    ) -> CosmicInsight {

        let components = buildComponents(
            rulerNumber: rulerNumber,
            realmNumber: realmNumber,
            aspectDisplay: aspectDisplay,
            element: element
        )

        let display = buildDisplay(components: components, tier: tier)
        let kasperMetadata = tier == .premium ? buildKASPERMetadata(components: components) : nil

        return CosmicInsight(
            timestamp: Date(),
            tier: tier,
            type: .momentary,
            components: components,
            display: display,
            kasperMetadata: kasperMetadata
        )
    }

    // MARK: - Private Builder Methods

    private func buildComponents(
        rulerNumber: Int,
        realmNumber: Int,
        aspectDisplay: String,
        element: String
    ) -> InsightComponents {

        let numerology = NumerologyComponent(
            rulerNumber: rulerNumber,
            realmNumber: realmNumber,
            influence: getNumerologyInfluence(ruler: rulerNumber, realm: realmNumber),
            theme: getNumerologyTheme(rulerNumber),
            specificAction: getSpecificRulerAction(rulerNumber),
            detailedGuidance: getDetailedRulerGuidance(rulerNumber)
        )

        let planets = extractPlanets(from: aspectDisplay)
        let aspectType = extractAspectType(from: aspectDisplay)

        let astrology = AstrologyComponent(
            dominantAspect: aspectDisplay,
            planets: planets,
            aspectType: aspectType,
            influence: getAstrologyInfluence(aspectDisplay),
            planetaryNarrative: generatePlanetaryNarrative(planets: planets, aspectType: aspectType),
            specificGuidance: getSpecificPlanetaryGuidance(aspectType, planets: planets),
            detailedMessage: getDetailedPlanetaryMessage(aspectType, planets: planets),
            orb: nil // Would need actual orb data
        )

        let elements = ElementComponent(
            element: element,
            phase: getElementPhase(element),
            influence: getElementInfluence(element),
            application: getElementalApplication(element),
            detailedAction: getDetailedElementalAction(element)
        )

        let synthesis = synthesizeInfluences(
            numerology: numerology,
            astrology: astrology,
            elements: elements
        )

        return InsightComponents(
            numerology: numerology,
            astrology: astrology,
            elements: elements,
            synthesis: synthesis
        )
    }

    private func buildDisplay(components: InsightComponents, tier: InsightTier) -> InsightDisplay {
        switch tier {
        case .free:
            return InsightDisplay(
                compact: "\(components.numerology.theme) • \(components.elements.influence)",
                expanded: "\(components.numerology.specificAction)\n\(components.astrology.planetaryNarrative) through \(getElementName(components.elements.element)) energy",
                lockScreen: "\(components.numerology.detailedGuidance)\n\(components.astrology.planetaryNarrative). \(getShortElementAction(components.elements.element))",
                meditation: nil
            )

        case .premium:
            return InsightDisplay(
                compact: "\(components.numerology.theme) as \(components.astrology.planetaryNarrative) \(components.elements.influence)",
                expanded: "\(components.numerology.specificAction)\n\(components.astrology.planetaryNarrative) through \(getElementName(components.elements.element)) energy",
                lockScreen: "\(components.numerology.detailedGuidance)\n\(components.astrology.planetaryNarrative). \(getShortElementAction(components.elements.element))",
                meditation: generateMeditation(components)
            )

        case .kasper:
            return InsightDisplay(
                compact: "KASPER: \(components.numerology.theme) flows with cosmic alignment",
                expanded: "🤖 KASPER AI integration ready\nPersonalized cosmic guidance awaits",
                lockScreen: "🤖 KASPER AI is preparing personalized insights\nEnhanced cosmic guidance coming soon",
                meditation: generateAdvancedMeditation(components)
            )
        }
    }

    private func buildKASPERMetadata(components: InsightComponents) -> KASPERMetadata {
        return KASPERMetadata(
            contextVector: [
                "ruler_\(components.numerology.rulerNumber)",
                "realm_\(components.numerology.realmNumber)",
                "aspect_\(components.astrology.aspectType)",
                "element_\(components.elements.element.replacingOccurrences(of: "🔥🌱💨💧", with: ""))"
            ],
            intentClassification: classifyIntent(components),
            personalityFactors: derivePersonalityFactors(components),
            readyForAI: true
        )
    }

    // MARK: - Analysis Methods

    private func getNumerologyInfluence(ruler: Int, realm: Int) -> String {
        let balance = abs(ruler - realm)
        switch balance {
        case 0: return "Perfect alignment"
        case 1...2: return "Harmonious flow"
        case 3...4: return "Dynamic tension"
        default: return "Transformative contrast"
        }
    }

    private func getNumerologyTheme(_ number: Int) -> String {
        switch number {
        case 1: return "Leadership awakening"
        case 2: return "Harmony seeking"
        case 3: return "Creative expression"
        case 4: return "Foundation building"
        case 5: return "Freedom exploring"
        case 6: return "Love nurturing"
        case 7: return "Wisdom deepening"
        case 8: return "Power manifesting"
        case 9: return "Service completing"
        default: return "Cosmic channeling"
        }
    }

    private func extractPlanets(from aspectDisplay: String) -> [String] {
        let planetMap: [Character: String] = [
            "☉": "Sun", "☽": "Moon", "☿": "Mercury", "♀": "Venus",
            "♂": "Mars", "♃": "Jupiter", "♄": "Saturn", "♅": "Uranus",
            "♆": "Neptune", "♇": "Pluto"
        ]

        return aspectDisplay.compactMap { char in
            planetMap[char]
        }
    }

    private func extractAspectType(from aspectDisplay: String) -> String {
        if aspectDisplay.contains("△") { return "trine" }
        if aspectDisplay.contains("□") { return "square" }
        if aspectDisplay.contains("☌") { return "conjunction" }
        if aspectDisplay.contains("☍") { return "opposition" }
        if aspectDisplay.contains("⚹") { return "sextile" }
        if aspectDisplay.contains("⚻") { return "quincunx" }
        return "unknown"
    }

    private func getAstrologyInfluence(_ aspectDisplay: String) -> String {
        let aspectType = extractAspectType(from: aspectDisplay)
        switch aspectType {
        case "trine": return "Harmonious flow"
        case "square": return "Dynamic challenge"
        case "conjunction": return "Unified power"
        case "opposition": return "Balanced tension"
        case "sextile": return "Opportunity opens"
        case "quincunx": return "Adjustment needed"
        default: return "Cosmic alignment"
        }
    }

    private func getElementPhase(_ element: String) -> String {
        switch element {
        case "🔥": return "Transforming"
        case "🌱": return "Growing"
        case "💨": return "Expanding"
        case "💧": return "Flowing"
        default: return "Cycling"
        }
    }

    private func getElementInfluence(_ element: String) -> String {
        switch element {
        case "🔥": return "Fire transforms"
        case "🌱": return "Earth grounds"
        case "💨": return "Air expands"
        case "💧": return "Water flows"
        default: return "Elements align"
        }
    }

    private func synthesizeInfluences(
        numerology: NumerologyComponent,
        astrology: AstrologyComponent,
        elements: ElementComponent
    ) -> String {
        return "\(numerology.theme) as \(astrology.planetaryNarrative) \(elements.influence). \(numerology.influence) creates the foundation for spiritual growth."
    }

    private func generatePlanetaryNarrative(planets: [String], aspectType: String) -> String {
        guard planets.count >= 2 else {
            return "cosmic forces align"
        }

        let planet1 = planets[0]
        let planet2 = planets[1]

        // Use proper astrological aspect terminology
        switch aspectType {
        case "trine": return "\(planet1) trine \(planet2)"
        case "square": return "\(planet1) square \(planet2)"
        case "conjunction": return "\(planet1) conjunct \(planet2)"
        case "opposition": return "\(planet1) opposite \(planet2)"
        case "sextile": return "\(planet1) sextile \(planet2)"
        case "quincunx": return "\(planet1) quincunx \(planet2)"
        default: return "\(planet1) aspects \(planet2)"
        }
    }

    private func generatePremiumInsight(_ components: InsightComponents) -> String {
        return """
        🌟 PREMIUM INSIGHT

        Numerology: \(components.numerology.theme) with \(components.numerology.influence)
        Astrology: \(components.astrology.planetaryNarrative) creating \(components.astrology.influence)
        Elements: \(components.elements.phase) \(components.elements.influence)

        Synthesis: \(components.synthesis)
        """
    }

    private func generateMeditation(_ components: InsightComponents) -> String {
        return "Focus on \(components.numerology.theme.lowercased()) while breathing with \(components.elements.influence.lowercased()) energy."
    }

    private func generateAdvancedMeditation(_ components: InsightComponents) -> String {
        return "KASPER-guided meditation: Align your \(components.numerology.theme.lowercased()) with cosmic \(components.astrology.influence.lowercased()) through \(components.elements.phase.lowercased()) breath work."
    }

    private func classifyIntent(_ components: InsightComponents) -> String {
        if components.numerology.rulerNumber == components.numerology.realmNumber {
            return "alignment_seeking"
        } else if components.astrology.aspectType == "square" {
            return "challenge_navigating"
        } else if components.astrology.aspectType == "trine" {
            return "harmony_embracing"
        } else {
            return "growth_exploring"
        }
    }

    private func derivePersonalityFactors(_ components: InsightComponents) -> [String] {
        var factors: [String] = []

        // Numerology factors
        if components.numerology.rulerNumber <= 3 {
            factors.append("initiative_oriented")
        } else if components.numerology.rulerNumber <= 6 {
            factors.append("harmony_seeking")
        } else {
            factors.append("wisdom_pursuing")
        }

        // Astrological factors
        if components.astrology.aspectType == "trine" {
            factors.append("flow_preferring")
        } else if components.astrology.aspectType == "square" {
            factors.append("challenge_embracing")
        }

        return factors
    }

    // MARK: - Enhanced Insight Functions (matching Widget implementation)

    private func getSpecificRulerAction(_ number: Int) -> String {
        switch number {
        case 1: return "Take decisive leadership action today"
        case 2: return "Seek harmony in relationships"
        case 3: return "Express your creativity boldly"
        case 4: return "Build solid foundations now"
        case 5: return "Embrace new adventures"
        case 6: return "Nurture those around you"
        case 7: return "Trust your inner wisdom"
        case 8: return "Manifest your material goals"
        case 9: return "Complete what you've started"
        default: return "Channel cosmic energy purposefully"
        }
    }

    private func getDetailedRulerGuidance(_ number: Int) -> String {
        switch number {
        case 1: return "Your leadership energy is at its peak."
        case 2: return "Cooperation and balance guide you today."
        case 3: return "Creative expression opens new doors."
        case 4: return "Methodical planning yields lasting results."
        case 5: return "Change and adventure call your name."
        case 6: return "Your caring nature heals and nurtures."
        case 7: return "Deep reflection reveals hidden truths."
        case 8: return "Material success follows focused effort."
        case 9: return "Completion and wisdom merge beautifully."
        default: return "Cosmic forces amplify your potential."
        }
    }

    private func getSpecificPlanetaryGuidance(_ aspectType: String, planets: [String]) -> String {
        guard planets.count >= 2 else {
            return "Cosmic energies support your path"
        }

        let planet1 = planets[0]
        let planet2 = planets[1]

        // Use proper astrological aspect terminology
        switch aspectType {
        case "trine":
            return "\(planet1) trine \(planet2) creates flowing energy"
        case "square":
            return "\(planet1) square \(planet2) builds dynamic tension"
        case "conjunction":
            return "\(planet1) conjunct \(planet2) unites their powers"
        case "opposition":
            return "\(planet1) opposite \(planet2) seeks perfect balance"
        case "sextile":
            return "\(planet1) sextile \(planet2) opens opportunities"
        case "quincunx":
            return "\(planet1) quincunx \(planet2) requires adjustment"
        default:
            return "\(planet1) aspects \(planet2) in cosmic harmony"
        }
    }

    private func getDetailedPlanetaryMessage(_ aspectType: String, planets: [String]) -> String {
        guard planets.count >= 2 else {
            return "Universal energies support your journey."
        }

        let planet1 = planets[0]
        let planet2 = planets[1]

        // Use proper astrological aspect terminology
        switch aspectType {
        case "trine":
            return "\(planet1) trine \(planet2) creates harmonious opportunities for growth."
        case "square":
            return "\(planet1) square \(planet2) builds character through challenge."
        case "conjunction":
            return "\(planet1) conjunct \(planet2) amplifies their combined power."
        case "opposition":
            return "\(planet1) opposite \(planet2) seeks perfect balance in your life."
        case "sextile":
            return "\(planet1) sextile \(planet2) opens beneficial opportunities."
        case "quincunx":
            return "\(planet1) quincunx \(planet2) requires subtle adjustments."
        default:
            return "\(planet1) aspects \(planet2) in cosmic harmony."
        }
    }

    private func getElementalApplication(_ element: String) -> String {
        switch element {
        case "🔥": return "Apply passionate fire energy to your goals"
        case "🌱": return "Ground your ideas in practical earth action"
        case "💨": return "Let air element expand your thinking"
        case "💧": return "Trust water's intuitive flow"
        default: return "Balance all elemental energies"
        }
    }

    private func getDetailedElementalAction(_ element: String) -> String {
        switch element {
        case "🔥": return "Channel fire's transformative power into passionate action."
        case "🌱": return "Use earth's stability to manifest tangible results."
        case "💨": return "Let air's clarity expand your mental horizons."
        case "💧": return "Flow with water's intuitive wisdom and emotional depth."
        default: return "Balance all elements for complete spiritual harmony."
        }
    }

    private func getElementName(_ element: String) -> String {
        switch element {
        case "🔥": return "fire"
        case "🌱": return "earth"
        case "💨": return "air"
        case "💧": return "water"
        default: return "cosmic"
        }
    }

    private func getShortElementAction(_ element: String) -> String {
        switch element {
        case "🔥": return "Let fire transform you."
        case "🌱": return "Ground yourself in earth."
        case "💨": return "Expand with air's clarity."
        case "💧": return "Flow with water's wisdom."
        default: return "Find elemental balance."
        }
    }
}
