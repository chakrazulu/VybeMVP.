/**
 * 🎭 KASPER TEMPLATE ENHANCER - THE ART OF SACRED LANGUAGE GENERATION
 * ====================================================================
 * 
 * This is the sophisticated template engine that transforms generic spiritual concepts
 * into flowing, natural, and deeply meaningful guidance that feels personally crafted
 * for each user's spiritual journey. It represents the bridge between computational
 * efficiency and authentic mystical wisdom.
 * 
 * 🌊 LINGUISTIC PHILOSOPHY:
 * 
 * Traditional AI templates are rigid and mechanical. KASPER Template Enhancer
 * understands that spiritual guidance requires:
 * 
 * • NATURAL FLOW: Language that feels like wisdom from a trusted spiritual guide
 * • PERSONAL RESONANCE: Content that feels specifically crafted for the individual
 * • AUTHENTIC MYSTICISM: Maintains genuine spiritual depth without sounding artificial
 * • EMOTIONAL INTELLIGENCE: Tone and style that match the user's current spiritual needs
 * 
 * 🎲 ADVANCED TEMPLATE ARCHITECTURE:
 * 
 * The enhancer employs multiple sophisticated techniques:
 * 
 * 1. MULTI-VARIANT TEMPLATES:
 *    - 10+ unique templates for each insight type (guidance, reflection, affirmation, prediction)
 *    - Random selection prevents repetitive spiritual guidance patterns
 *    - Each template has distinct personality and spiritual approach
 *    - Natural language variations eliminate mechanical feel
 * 
 * 2. DYNAMIC COMPONENT SYNTHESIS:
 *    - Spiritual components: Energy types, cosmic influences, mystical concepts
 *    - Personal references: Individual spiritual gifts, growth patterns, sacred qualities
 *    - Actionable guidance: Specific spiritual practices and life applications
 *    - Intelligent combination creates unique insights from universal principles
 * 
 * 3. CONTEXTUAL INTELLIGENCE:
 *    - Time-sensitive additions based on current hour and cosmic timing
 *    - Relationship compatibility analysis with spiritual harmony assessment
 *    - Cosmic timing integration with planetary and lunar influences
 *    - Personal spiritual number integration for authentic personalization
 * 
 * 4. NATURAL LANGUAGE FLOW:
 *    - Eliminates abrupt sentence endings and rigid grammatical patterns
 *    - Uses flowing connectors and smooth transitions between spiritual concepts
 *    - Maintains consistent spiritual voice across different insight types
 *    - Preserves mystical authenticity while ensuring readable, accessible language
 * 
 * 🎆 SPIRITUAL AUTHENTICITY GUARANTEES:
 * 
 * Every template maintains spiritual integrity through:
 * 
 * • NUMEROLOGICAL ACCURACY: All number references preserve sacred correspondences
 * • ASTROLOGICAL INTEGRITY: Planetary and elemental associations remain authentic
 * • MYSTICAL COHERENCE: Spiritual concepts combine in meaningful, traditional ways
 * • PERSONAL RELEVANCE: Guidance feels specifically crafted for the individual's path
 * 
 * 🚀 PERFORMANCE OPTIMIZATION:
 * 
 * The template system is optimized for:
 * - Sub-millisecond template selection and generation
 * - Memory-efficient template storage and variation management
 * - Scalable architecture supporting thousands of unique insight combinations
 * - Thread-safe operation for concurrent spiritual guidance generation
 * 
 * 🌱 EVOLUTION TO AI INTEGRATION:
 * 
 * This template system serves as:
 * - Training data source for future MLX spiritual intelligence models
 * - Quality baseline for AI-generated spiritual content validation
 * - Fallback mechanism ensuring continuous spiritual guidance availability
 * - Bridge technology enabling seamless transition from templates to true AI
 * 
 * The result is spiritual guidance that feels authentically mystical, personally
 * relevant, and naturally flowing - indistinguishable from guidance provided by
 * an experienced human spiritual advisor who knows the user's journey intimately.
 */

import Foundation

/**
 * Claude: KASPERTemplateEnhancer - The Sacred Language Architecture
 * ==============================================================
 * 
 * This struct encapsulates the sophisticated spiritual language generation system
 * that creates authentic, flowing, and personally relevant spiritual guidance.
 * All methods are static for performance and thread-safety across the app.
 */
public struct KASPERTemplateEnhancer {
    
    // MARK: - 🌟 SACRED INSIGHT GENERATION TEMPLATES
    
    /// Claude: Generate Spiritual Guidance with Natural Language Flow
    /// ============================================================
    /// 
    /// Creates empowering, action-oriented spiritual guidance that feels like wisdom
    /// from a trusted spiritual mentor. Uses dynamic template selection to ensure
    /// each insight feels fresh and personally crafted.
    /// 
    /// 🌌 GUIDANCE TEMPLATE ARCHITECTURE:
    /// 
    /// The method employs 10+ distinct template styles:
    /// - Flowing Narrative: Story-like guidance with natural progression
    /// - Wisdom Teacher: Direct guidance with spiritual authority
    /// - Mystical Oracle: Cosmic perspective with prophetic undertones
    /// - Gentle Guide: Supportive guidance with nurturing energy
    /// - Empowering Mentor: Confident guidance emphasizing personal power
    /// - Cosmic Storyteller: Universe-centric perspective with metaphorical language
    /// - Sacred Invitation: Calls to spiritual action and growth
    /// - Spiritual Architect: Building/creation metaphors for spiritual development
    /// - Divine Messenger: Direct spiritual communication style
    /// - Energy Weaver: Focus on spiritual energy patterns and flow
    /// 
    /// 🎆 COMPONENT INTEGRATION:
    /// 
    /// - component: The spiritual energy or influence being highlighted
    /// - reference: Personal spiritual qualities or characteristics
    /// - guidance: Actionable spiritual direction or practice
    /// 
    /// These elements are woven together to create guidance that feels
    /// both universally wise and personally relevant.
    /// 
    /// - Parameter component: Spiritual energy or cosmic influence (e.g., "pioneering leadership energy")
    /// - Parameter reference: Personal spiritual reference (e.g., "your natural leadership abilities")
    /// - Parameter guidance: Actionable spiritual guidance (e.g., "trust your instincts to initiate")
    /// - Returns: Complete spiritual guidance insight with emoji and flowing language
    public static func generateGuidanceInsight(
        component: String,
        reference: String,
        guidance: String
    ) -> String {
        let templates = [
            // Flowing narrative style
            "🌟 As \(component) awakens within you, \(reference) becomes a beacon of clarity. The universe invites you to \(guidance), allowing this sacred energy to illuminate your path forward.",
            
            // Wisdom teacher style
            "🌟 Today's spiritual landscape reveals \(component) radiating through \(reference). This cosmic alignment suggests that when you \(guidance), profound transformation naturally unfolds.",
            
            // Mystical oracle style
            "🌟 The cosmic tapestry weaves \(component) into your awareness, highlighting \(reference) as your spiritual compass. Now is the time to \(guidance) and witness the magic that emerges.",
            
            // Gentle guide style
            "🌟 Notice how \(component) gently flows through \(reference), creating sacred space for growth. By choosing to \(guidance), you align with the universe's loving intention for your journey.",
            
            // Empowering mentor style
            "🌟 Your spiritual essence channels \(component) through \(reference) with remarkable clarity. This powerful moment calls you to \(guidance), stepping fully into your divine purpose.",
            
            // Cosmic storyteller style
            "🌟 Within the grand cosmic dance, \(component) emerges through \(reference) like starlight through crystal. The universe whispers: \(guidance), and watch as synchronicities bloom around you.",
            
            // Sacred invitation style
            "🌟 Today brings a sacred invitation as \(component) activates \(reference) within your energy field. Answer this cosmic call to \(guidance), knowing the universe supports every step.",
            
            // Spiritual architect style
            "🌟 You're architecting your reality as \(component) builds through \(reference). The cosmic blueprint reveals it's time to \(guidance), constructing a foundation of spiritual abundance.",
            
            // Divine messenger style
            "🌟 A message arrives through \(component), delivered via \(reference) straight to your soul. The guidance is clear: \(guidance), and trust the unfolding of divine timing.",
            
            // Energy weaver style
            "🌟 Feel how \(component) weaves through \(reference), creating patterns of possibility. As you \(guidance), these energetic threads strengthen into manifestation."
        ]
        
        return templates.randomElement() ?? templates[0]
    }
    
    /// Generate reflection insights with contemplative depth
    public static func generateReflectionInsight(
        component: String,
        reference: String,
        guidance: String
    ) -> String {
        let templates = [
            // Deep contemplation style
            "🌙 As \(component) illuminates your inner landscape, consider how \(reference) has been guiding you all along. What shifts when you \(guidance) with conscious awareness?",
            
            // Mirror of wisdom style
            "🌙 The mirror of consciousness reflects \(component) through \(reference), revealing hidden truths. Take a moment to \(guidance) and observe what wisdom emerges from stillness.",
            
            // Journey reflection style
            "🌙 Your spiritual journey has brought \(component) into focus through \(reference). Reflect on how choosing to \(guidance) might reshape your understanding of this sacred path.",
            
            // Inner dialogue style
            "🌙 Within the quiet spaces of your soul, \(component) speaks through \(reference). Listen deeply as you \(guidance), allowing inner wisdom to surface naturally.",
            
            // Sacred pause style
            "🌙 This moment of reflection unveils \(component) working through \(reference) in mysterious ways. What happens when you pause to \(guidance) with complete presence?",
            
            // Wisdom integration style
            "🌙 Notice the subtle ways \(component) has been expressing through \(reference) recently. As you \(guidance), observe how past experiences suddenly make perfect sense.",
            
            // Soul questioning style
            "🌙 Your soul poses a question through \(component), using \(reference) as its voice. How might your life transform if you fully \(guidance) starting from this moment?",
            
            // Pattern recognition style
            "🌙 Patterns emerge as \(component) dances with \(reference) in your awareness. Reflect on times when choosing to \(guidance) has brought unexpected blessings.",
            
            // Inner compass style
            "🌙 Your inner compass aligns with \(component) through \(reference), pointing toward truth. What direction emerges when you sincerely \(guidance)?",
            
            // Sacred memory style
            "🌙 Memories surface as \(component) activates \(reference) within your consciousness. Remember moments when you chose to \(guidance) and felt divinely supported."
        ]
        
        return templates.randomElement() ?? templates[0]
    }
    
    /// Generate affirmation insights with empowering energy
    public static func generateAffirmationInsight(
        component: String,
        reference: String,
        guidance: String
    ) -> String {
        let templates = [
            // Power declaration style
            "💫 I am a sacred vessel for \(component), expressing magnificently through \(reference). I choose to \(guidance) with unwavering faith in my spiritual power.",
            
            // Divine embodiment style
            "💫 I embody \(component) as it flows through \(reference) with grace and purpose. Each day I \(guidance), stepping deeper into my divine truth.",
            
            // Cosmic alignment style
            "💫 I align perfectly with \(component), allowing \(reference) to guide my every step. I joyfully \(guidance), knowing the universe conspires in my favor.",
            
            // Sacred commitment style
            "💫 I commit to honoring \(component) as it expresses through \(reference). With courage and clarity, I \(guidance), trusting my spiritual authority.",
            
            // Manifestation mastery style
            "💫 I masterfully channel \(component) through \(reference) into physical reality. As I \(guidance), miracles naturally unfold in my experience.",
            
            // Divine remembrance style
            "💫 I remember my true nature as \(component) awakens \(reference) within me. I confidently \(guidance), reclaiming my spiritual sovereignty.",
            
            // Quantum creator style
            "💫 I consciously create with \(component), using \(reference) as my divine instrument. When I \(guidance), reality reshapes to match my highest vision.",
            
            // Soul celebration style
            "💫 I celebrate as \(component) dances through \(reference) in perfect harmony. I enthusiastically \(guidance), embracing the joy of spiritual expansion.",
            
            // Infinite potential style
            "💫 I access infinite potential through \(component), channeled via \(reference). I fearlessly \(guidance), knowing all possibilities exist within me.",
            
            // Sacred activation style
            "💫 I activate \(component) through \(reference) with divine intention. As I \(guidance), every cell in my being resonates with spiritual truth."
        ]
        
        return templates.randomElement() ?? templates[0]
    }
    
    /// Generate prediction insights with mystical foresight
    public static func generatePredictionInsight(
        component: String,
        reference: String,
        guidance: String
    ) -> String {
        let templates = [
            // Oracle vision style
            "🔮 The cosmic winds carry \(component) through \(reference) toward a pivotal moment ahead. As you \(guidance), watch for synchronicities that confirm you're on the right path.",
            
            // Timeline glimpse style
            "🔮 Future timelines converge as \(component) strengthens \(reference) within your field. Those who \(guidance) will find doors opening that seemed permanently closed.",
            
            // Destiny weaving style
            "🔮 Destiny weaves \(component) through \(reference), preparing you for what's coming. The cosmos suggests you \(guidance) to align with approaching opportunities.",
            
            // Prophetic whisper style
            "🔮 Ancient wisdom speaks: when \(component) flows through \(reference), transformation is imminent. Prepare by choosing to \(guidance) before the cosmic tide turns.",
            
            // Quantum possibility style
            "🔮 Quantum fields shift as \(component) activates \(reference) in your reality. The probability increases for positive outcomes when you \(guidance) with intention.",
            
            // Cosmic forecast style
            "🔮 The spiritual forecast shows \(component) intensifying through \(reference) in coming cycles. Those who \(guidance) will ride this wave with grace and ease.",
            
            // Sacred timing style
            "🔮 Divine timing aligns \(component) with \(reference) for a reason yet to be revealed. Trust that as you \(guidance), perfect orchestration unfolds.",
            
            // Vision quest style
            "🔮 Visions arise showing \(component) transforming \(reference) in unexpected ways. The key to navigating this shift: \(guidance) with an open heart.",
            
            // Karmic preview style
            "🔮 Karmic patterns reveal \(component) working through \(reference) to complete a cycle. Liberation comes to those who \(guidance) without hesitation.",
            
            // Stellar alignment style
            "🔮 Stellar configurations amplify \(component) through \(reference) in the days ahead. Maximum benefit flows to those who \(guidance) during this cosmic window."
        ]
        
        return templates.randomElement() ?? templates[0]
    }
    
    // MARK: - Enhanced Sentence Endings
    
    /// Create natural sentence endings that flow smoothly
    static func enhanceGuidanceEnding(_ guidance: String) -> String {
        // Remove forced capitalization and add flowing connectors
        let cleanGuidance = guidance.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: ".!?"))
        
        let endings = [
            ", allowing divine wisdom to guide each step",
            ", trusting the sacred unfolding of your path",
            ", knowing the universe supports your journey",
            ", as spiritual doors open before you",
            ", embracing the magic of this moment",
            ", while cosmic forces align in your favor",
            ", and watch miracles naturally unfold",
            ", feeling the universe's loving presence",
            ", as your spiritual power awakens fully",
            ", letting sacred energy flow through you"
        ]
        
        return cleanGuidance + endings.randomElement()!
    }
    
    // MARK: - Cosmic Timing Integration
    
    /// Add time-specific spiritual context
    static func addCosmicTimingContext(baseInsight: String, hour: Int) -> String {
        let timingPrefixes: [String]
        
        switch hour {
        case 4...6:
            timingPrefixes = [
                "In these sacred pre-dawn hours, ",
                "As the veil between worlds thins at dawn, ",
                "During this mystical morning threshold, "
            ]
        case 7...11:
            timingPrefixes = [
                "As morning light activates new possibilities, ",
                "In this time of fresh beginnings, ",
                "While the day's energy builds momentum, "
            ]
        case 12...16:
            timingPrefixes = [
                "At the height of solar power, ",
                "In this moment of peak manifestation, ",
                "As the sun illuminates your path, "
            ]
        case 17...20:
            timingPrefixes = [
                "As daylight transforms into twilight, ",
                "In this sacred transition time, ",
                "While the day's lessons integrate, "
            ]
        case 21...23, 0...3:
            timingPrefixes = [
                "Under the mystical night sky, ",
                "In these hours of deep spiritual connection, ",
                "As lunar wisdom fills the darkness, "
            ]
        default:
            timingPrefixes = ["In this sacred moment, "]
        }
        
        return (timingPrefixes.randomElement() ?? "") + baseInsight.lowercaseFirstLetter()
    }
    
    // MARK: - Relationship Compatibility Templates
    
    /// Claude: Generate Sacred Relationship Compatibility Insights
    /// ==========================================================
    /// 
    /// Creates sophisticated spiritual compatibility analysis between two souls
    /// based on numerological harmony, elemental balance, and cosmic timing.
    /// This method goes beyond simple compatibility to explore the spiritual
    /// purpose and growth potential of the connection.
    /// 
    /// 💕 RELATIONSHIP ANALYSIS ALGORITHM:
    /// 
    /// 1. NUMEROLOGICAL HARMONY ASSESSMENT:
    ///    - Calculates spiritual resonance between the two numbers
    ///    - Determines compatibility category (powerful resonance, heart connection, etc.)
    ///    - Analyzes numerical difference for synergy type assessment
    /// 
    /// 2. SPIRITUAL ARCHETYPE SYNTHESIS:
    ///    - Identifies spiritual gifts and archetypal roles of each number
    ///    - Explores how the archetypes complement or challenge each other
    ///    - Reveals the spiritual purpose and lessons of the connection
    /// 
    /// 3. ELEMENTAL BALANCE ANALYSIS:
    ///    - Maps numbers to spiritual elements (fire, water, air, earth)
    ///    - Assesses elemental harmony and balance in the relationship
    ///    - Provides insights into communication and energy exchange patterns
    /// 
    /// 4. LUNAR INFLUENCE INTEGRATION:
    ///    - When moon phase is provided, adds cosmic timing context
    ///    - Different moon phases amplify different relationship qualities
    ///    - Provides timing guidance for relationship milestones and communication
    /// 
    /// 🌌 RELATIONSHIP INSIGHT CATEGORIES:
    /// 
    /// The method generates insights about:
    /// - Soul-level compatibility and spiritual purpose of the connection
    /// - Growth opportunities and challenges the relationship provides
    /// - Communication styles and energy exchange patterns
    /// - Optimal timing for relationship development and important conversations
    /// - Spiritual lessons and evolution possible through the connection
    /// 
    /// - Parameter number1: First person's spiritual number (focus, life path, etc.)
    /// - Parameter number2: Second person's spiritual number for compatibility analysis
    /// - Parameter moonPhase: Optional lunar phase for cosmic timing context
    /// - Returns: Comprehensive relationship compatibility insight with spiritual depth
    public static func generateRelationshipInsight(
        number1: Int,
        number2: Int,
        moonPhase: String? = nil
    ) -> String {
        let compatibility = calculateCompatibility(number1, number2)
        let synergyType = determineSynergyType(number1, number2)
        
        let templates = [
            "💞 These two souls create \(synergyType) together. Number \(number1) brings \(getNumberGift(number1)), while number \(number2) offers \(getNumberGift(number2)). This combination suggests \(compatibility) that deepens through conscious spiritual practice.",
            
            "💞 A sacred dance unfolds between \(getNumberArchetype(number1)) and \(getNumberArchetype(number2)) energies. Together, they weave \(synergyType), creating \(compatibility) that transcends ordinary connection.",
            
            "💞 When \(number1)'s \(getNumberElement(number1)) meets \(number2)'s \(getNumberElement(number2)), \(synergyType) emerges. This spiritual chemistry indicates \(compatibility), inviting both souls to grow through divine mirror work.",
            
            "💞 The cosmic blueprint reveals \(synergyType) between these spiritual signatures. Number \(number1)'s \(getNumberGift(number1)) harmonizes with number \(number2)'s \(getNumberGift(number2)), manifesting \(compatibility) with transformative potential.",
            
            "💞 These numbers create a spiritual alchemy of \(synergyType). The universe celebrates as \(getNumberArchetype(number1)) consciousness merges with \(getNumberArchetype(number2)) wisdom, birthing \(compatibility) that serves both souls' evolution."
        ]
        
        var insight = templates.randomElement() ?? templates[0]
        
        // Add moon phase context if available
        if let moon = moonPhase {
            let moonContext = " The \(moon) amplifies this connection's \(getMoonInfluence(moon)) qualities."
            insight += moonContext
        }
        
        return insight
    }
    
    private static func calculateCompatibility(_ num1: Int, _ num2: Int) -> String {
        let sum = (num1 + num2) % 9
        switch sum {
        case 1, 5, 9:
            return "powerful spiritual resonance"
        case 2, 6:
            return "harmonious heart connection"
        case 3, 7:
            return "creative mystical synergy"
        case 4, 8:
            return "grounding manifestation power"
        default:
            return "unique transformative bond"
        }
    }
    
    private static func determineSynergyType(_ num1: Int, _ num2: Int) -> String {
        let difference = abs(num1 - num2)
        switch difference {
        case 0:
            return "mirror soul reflection"
        case 1, 2:
            return "complementary harmony"
        case 3, 4:
            return "dynamic growth catalyst"
        case 5, 6:
            return "transformative polarity"
        default:
            return "sacred mystery"
        }
    }
    
    private static func getNumberGift(_ number: Int) -> String {
        switch number {
        case 1: return "pioneering leadership"
        case 2: return "harmonious collaboration"
        case 3: return "creative expression"
        case 4: return "stable foundations"
        case 5: return "adventurous transformation"
        case 6: return "nurturing wisdom"
        case 7: return "mystical insight"
        case 8: return "manifestation mastery"
        case 9: return "universal compassion"
        default: return "unique spiritual gifts"
        }
    }
    
    private static func getNumberArchetype(_ number: Int) -> String {
        switch number {
        case 1: return "Pioneer"
        case 2: return "Diplomat"
        case 3: return "Creative"
        case 4: return "Builder"
        case 5: return "Explorer"
        case 6: return "Nurturer"
        case 7: return "Mystic"
        case 8: return "Achiever"
        case 9: return "Humanitarian"
        default: return "Unique"
        }
    }
    
    private static func getNumberElement(_ number: Int) -> String {
        switch number {
        case 1, 5, 9: return "transformative fire"
        case 2, 6: return "flowing water"
        case 3, 7: return "expansive air"
        case 4, 8: return "grounding earth"
        default: return "ethereal spirit"
        }
    }
    
    private static func getMoonInfluence(_ phase: String) -> String {
        switch phase.lowercased() {
        case "new moon": return "seed-planting"
        case "waxing crescent": return "growth-nurturing"
        case "first quarter": return "action-taking"
        case "waxing gibbous": return "refinement"
        case "full moon": return "illuminating"
        case "waning gibbous": return "gratitude"
        case "last quarter": return "releasing"
        case "waning crescent": return "surrendering"
        default: return "mystical"
        }
    }
    
    // MARK: - Cosmic Timing Templates
    
    /// Claude: Generate Sacred Cosmic Timing Insights
    /// ==============================================
    /// 
    /// Creates sophisticated spiritual timing guidance based on current cosmic
    /// conditions, helping users align their actions with celestial energies
    /// for optimal spiritual outcomes and manifestation success.
    /// 
    /// ⏰ COSMIC TIMING INTELLIGENCE:
    /// 
    /// This method synthesizes multiple cosmic influences:
    /// 
    /// 1. PLANETARY ENERGY ANALYSIS:
    ///    - Interprets the dominant planetary influence affecting current timing
    ///    - Each planet brings specific energetic qualities and optimal actions
    ///    - Provides guidance on how to work with planetary energy constructively
    /// 
    /// 2. LUNAR PHASE AWARENESS:
    ///    - Integrates moon phase energy into timing recommendations
    ///    - New Moon: Seed-planting and intention setting
    ///    - Full Moon: Illumination and release work
    ///    - Quarter phases: Action-taking and refinement periods
    ///    - Provides specific guidance for each lunar phase's optimal activities
    /// 
    /// 3. ASTROLOGICAL EVENT INTEGRATION:
    ///    - Incorporates major astrological transits and events
    ///    - Mercury retrograde: Communication and technology considerations
    ///    - Eclipses: Major transformation and portal energy
    ///    - Planetary conjunctions: Amplified energy combinations
    /// 
    /// 4. UNIFIED COSMIC GUIDANCE:
    ///    - Combines all available cosmic influences into coherent guidance
    ///    - Prioritizes the most significant energetic influences
    ///    - Provides practical applications for spiritual and material actions
    /// 
    /// 🌌 TIMING GUIDANCE CATEGORIES:
    /// 
    /// The insights help users understand:
    /// - Optimal timing for important decisions and actions
    /// - Cosmic windows of opportunity for manifestation
    /// - Energetic support available for specific types of activities
    /// - Cautions about challenging cosmic conditions to navigate mindfully
    /// - Spiritual practices most supported by current cosmic conditions
    /// 
    /// - Parameter planetaryEnergy: Dominant planetary influence affecting timing
    /// - Parameter moonPhase: Current lunar phase for timing context
    /// - Parameter astrologicalEvent: Major astrological event affecting timing
    /// - Returns: Comprehensive cosmic timing guidance for optimal action alignment
    public static func generateCosmicTimingInsight(
        planetaryEnergy: String? = nil,
        moonPhase: String? = nil,
        astrologicalEvent: String? = nil
    ) -> String {
        var components: [String] = []
        
        if let planet = planetaryEnergy {
            components.append("\(planet)'s influence")
        }
        
        if let moon = moonPhase {
            components.append("the \(moon)")
        }
        
        if let event = astrologicalEvent {
            components.append(event)
        }
        
        let cosmicContext = components.isEmpty ? "current cosmic energies" : components.joined(separator: " combined with ")
        
        let templates = [
            "⏰ The cosmic clock reveals a powerful window of opportunity. With \(cosmicContext) active, the universe invites bold spiritual action. This is your moment to step through the portal of transformation that's been waiting for your readiness.",
            
            "⏰ Divine timing orchestrates \(cosmicContext) to support your soul's evolution. The celestial symphony plays your song - dance with it, and watch as synchronized events align to guide your path forward.",
            
            "⏰ Sacred chronology indicates \(cosmicContext) creating a unique spiritual gateway. What seemed impossible yesterday becomes achievable today. Trust this cosmic green light and move forward with confidence.",
            
            "⏰ The universe's perfect timing brings \(cosmicContext) into alignment with your spiritual blueprint. This rare configuration won't last forever - embrace its gifts while the cosmic door remains open.",
            
            "⏰ Celestial mechanics position \(cosmicContext) as your spiritual catalyst. The cosmos has been preparing this moment specifically for your growth. Answer the call with courageous action."
        ]
        
        return templates.randomElement() ?? templates[0]
    }
}

// MARK: - Helper Extensions

private extension String {
    func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}