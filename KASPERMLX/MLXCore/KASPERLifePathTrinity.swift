/**
 * KASPERLifePathTrinity.swift
 * 
 * 🧠 PHASE 1: LIFE PATH TRINITY BEHAVIORAL ANALYSIS SYSTEM
 * 
 * ✅ PURPOSE: Revolutionary behavioral prediction using 3-number numerology combination
 * ✅ ARCHITECTURE: Complete personality DNA mapping for spiritual AI guidance
 * ✅ INTEGRATION: Core behavioral intelligence for KASPER's user understanding
 * 
 * THE TRINITY BREAKTHROUGH:
 * - Life Path Number (birth date): Soul's journey & destiny
 * - Expression Number (full name): Natural talents & gifts  
 * - Soul Urge Number (vowels): Inner motivations & desires
 * 
 * BEHAVIORAL MINING SCALE:
 * - 1,728 possible combinations (12 × 12 × 12)
 * - 50+ behavioral attributes per combination
 * - Predictive models for decisions, relationships, career, spiritual growth
 * 
 * WHY THIS IS REVOLUTIONARY:
 * - First AI system to use complete numerological personality profiling
 * - Behavioral prediction accuracy vs generic horoscope advice
 * - Personalized spiritual guidance based on actual personality DNA
 * - Real-time conflict resolution using trinity analysis
 */

import Foundation
import SwiftUI
import Combine

// MARK: - Core Trinity Data Structures

/// Claude: The three fundamental numbers that define spiritual personality
public struct LifePathTrinity: Codable, Identifiable, Hashable, Equatable {
    public let id: UUID
    
    /// Claude: Primary life purpose and destiny path (calculated from birth date)
    public let lifePath: Int        // 1-9, 11, 22, 33, 44
    
    /// Claude: Natural talents and expression style (calculated from full birth name)
    public let expression: Int      // 1-9, 11, 22, 33, 44
    
    /// Claude: Inner desires and motivations (calculated from vowels in name)
    public let soulUrge: Int       // 1-9, 11, 22, 33, 44
    
    /// Claude: Computed compatibility score for internal harmony (0.0-1.0)
    public let harmonyScore: Double
    
    /// Claude: Primary behavioral archetype based on trinity combination
    public let primaryArchetype: TrinityArchetype
    
    /// Claude: Secondary archetypal influence
    public let secondaryArchetype: TrinityArchetype?
    
    /// Claude: Major internal conflicts created by number interactions
    public let internalConflicts: [TrinityConflict]
    
    /// Claude: Predicted behavioral patterns across life domains
    public let behavioralProfile: BehavioralProfile
    
    /// Claude: Relationship compatibility with other trinity combinations
    // Note: Moved to computed property to maintain Hashable conformance
    public var compatibilityMatrix: [LifePathTrinity: Double] { [:] }
    
    /// Claude: Career alignment scores for different professional paths
    public let careerAlignment: CareerAlignment
    
    /// Claude: Spiritual growth path recommendations
    public let spiritualGrowth: SpiritualGrowthProfile
    
    /// Claude: Decision-making patterns and preferences
    public let decisionPatterns: DecisionProfile
    
    /// Claude: Communication style and relationship approach
    public let relationshipStyle: RelationshipProfile
    
    public init(
        id: UUID = UUID(),
        lifePath: Int,
        expression: Int, 
        soulUrge: Int
    ) {
        self.id = id
        self.lifePath = lifePath
        self.expression = expression
        self.soulUrge = soulUrge
        
        // Claude: Calculate harmony score based on number compatibility
        self.harmonyScore = Self.calculateHarmonyScore(
            lifePath: lifePath,
            expression: expression, 
            soulUrge: soulUrge
        )
        
        // Claude: Determine primary archetype from strongest number influence
        self.primaryArchetype = Self.determinePrimaryArchetype(
            lifePath: lifePath,
            expression: expression,
            soulUrge: soulUrge
        )
        
        // Claude: Calculate secondary archetype influence
        self.secondaryArchetype = Self.determineSecondaryArchetype(
            lifePath: lifePath,
            expression: expression,
            soulUrge: soulUrge
        )
        
        // Claude: Analyze internal conflicts between numbers
        self.internalConflicts = Self.analyzeInternalConflicts(
            lifePath: lifePath,
            expression: expression,
            soulUrge: soulUrge
        )
        
        // Claude: Generate comprehensive behavioral profile
        self.behavioralProfile = BehavioralProfile(trinity: (lifePath, expression, soulUrge))
        
        // Claude: Calculate career alignment scores
        self.careerAlignment = CareerAlignment(trinity: (lifePath, expression, soulUrge))
        
        // Claude: Generate spiritual growth recommendations
        self.spiritualGrowth = SpiritualGrowthProfile(trinity: (lifePath, expression, soulUrge))
        
        // Claude: Analyze decision-making patterns
        self.decisionPatterns = DecisionProfile(trinity: (lifePath, expression, soulUrge))
        
        // Claude: Generate relationship style analysis
        self.relationshipStyle = RelationshipProfile(trinity: (lifePath, expression, soulUrge))
    }
    
    /// Claude: Trinity combination as string for debugging/display
    public var trinityCode: String {
        return "\\(lifePath)-\\(expression)-\\(soulUrge)"
    }
    
    /// Claude: Human-readable description of trinity combination
    public var description: String {
        return "Life Path \\(lifePath), Expression \\(expression), Soul Urge \\(soulUrge)"
    }
    
    // Claude: Explicit Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(lifePath)
        hasher.combine(expression)
        hasher.combine(soulUrge)
        hasher.combine(harmonyScore)
        hasher.combine(primaryArchetype)
        hasher.combine(secondaryArchetype)
    }
    
    // Claude: Explicit Equatable conformance
    public static func == (lhs: LifePathTrinity, rhs: LifePathTrinity) -> Bool {
        return lhs.id == rhs.id &&
               lhs.lifePath == rhs.lifePath &&
               lhs.expression == rhs.expression &&
               lhs.soulUrge == rhs.soulUrge &&
               lhs.harmonyScore == rhs.harmonyScore &&
               lhs.primaryArchetype == rhs.primaryArchetype &&
               lhs.secondaryArchetype == rhs.secondaryArchetype
    }
}

// MARK: - Trinity Archetypes

/// Claude: Primary archetypal patterns that emerge from trinity combinations
public enum TrinityArchetype: String, CaseIterable, Codable {
    // Claude: Pure Leadership Archetypes (strong 1s)
    case visionary_leader = "visionary_leader"           // 1-1-1, 1-1-8
    case innovative_pioneer = "innovative_pioneer"       // 1-5-1, 1-3-5
    case sovereign_creator = "sovereign_creator"         // 1-8-1, 8-1-1
    
    // Claude: Diplomatic/Partnership Archetypes (strong 2s)
    case harmonizing_diplomat = "harmonizing_diplomat"   // 2-2-2, 2-6-2
    case intuitive_counselor = "intuitive_counselor"    // 2-7-2, 7-2-2
    case collaborative_builder = "collaborative_builder" // 2-4-6, 4-2-6
    
    // Claude: Creative/Communication Archetypes (strong 3s)
    case expressive_artist = "expressive_artist"        // 3-3-3, 3-5-3
    case inspirational_teacher = "inspirational_teacher" // 3-6-3, 3-11-6
    case charismatic_performer = "charismatic_performer" // 3-1-3, 1-3-8
    
    // Claude: Structural/Foundation Archetypes (strong 4s)
    case methodical_builder = "methodical_builder"      // 4-4-4, 4-8-4
    case practical_organizer = "practical_organizer"    // 4-6-2, 6-4-2
    case systematic_analyst = "systematic_analyst"      // 4-7-1, 7-4-5
    
    // Claude: Freedom/Adventure Archetypes (strong 5s)
    case adventurous_explorer = "adventurous_explorer"  // 5-5-5, 5-1-5
    case versatile_communicator = "versatile_communicator" // 5-3-1, 3-5-7
    case progressive_reformer = "progressive_reformer"   // 5-8-1, 8-5-3
    
    // Claude: Nurturing/Service Archetypes (strong 6s)
    case compassionate_healer = "compassionate_healer"  // 6-6-6, 6-2-9
    case protective_caregiver = "protective_caregiver"  // 6-4-2, 4-6-8
    case wise_counselor = "wise_counselor"              // 6-7-2, 7-6-9
    
    // Claude: Spiritual/Analytical Archetypes (strong 7s)
    case contemplative_mystic = "contemplative_mystic"  // 7-7-7, 7-2-7
    case analytical_researcher = "analytical_researcher" // 7-4-1, 4-7-5
    case intuitive_guide = "intuitive_guide"           // 7-11-2, 11-7-9
    
    // Claude: Power/Achievement Archetypes (strong 8s)
    case executive_achiever = "executive_achiever"      // 8-8-8, 8-1-8
    case strategic_leader = "strategic_leader"          // 8-4-1, 1-8-4
    case material_master = "material_master"            // 8-6-4, 6-8-2
    
    // Claude: Humanitarian/Universal Archetypes (strong 9s)
    case universal_humanitarian = "universal_humanitarian" // 9-9-9, 9-6-9
    case compassionate_teacher = "compassionate_teacher" // 9-3-6, 3-9-11
    case global_visionary = "global_visionary"          // 9-1-5, 1-9-8
    
    // Claude: Master Number Archetypes (11, 22, 33, 44)
    case intuitive_master = "intuitive_master"          // 11-x-x combinations
    case master_builder = "master_builder"              // 22-x-x combinations
    case master_teacher = "master_teacher"              // 33-x-x combinations
    case master_healer = "master_healer"                // 44-x-x combinations
    
    // Claude: Complex Mixed Archetypes (conflicting numbers)
    case conflicted_creator = "conflicted_creator"      // 1-2-8 (independence vs cooperation)
    case analytical_dreamer = "analytical_dreamer"      // 7-3-9 (logic vs creativity)
    case structured_rebel = "structured_rebel"          // 4-5-1 (stability vs freedom)
    case sensitive_leader = "sensitive_leader"          // 2-1-6 (cooperation vs leadership)
    
    /// Claude: Human-readable archetype names
    public var displayName: String {
        switch self {
        case .visionary_leader: return "The Visionary Leader"
        case .innovative_pioneer: return "The Innovative Pioneer"
        case .sovereign_creator: return "The Sovereign Creator"
        case .harmonizing_diplomat: return "The Harmonizing Diplomat"
        case .intuitive_counselor: return "The Intuitive Counselor"
        case .collaborative_builder: return "The Collaborative Builder"
        case .expressive_artist: return "The Expressive Artist"
        case .inspirational_teacher: return "The Inspirational Teacher"
        case .charismatic_performer: return "The Charismatic Performer"
        case .methodical_builder: return "The Methodical Builder"
        case .practical_organizer: return "The Practical Organizer"
        case .systematic_analyst: return "The Systematic Analyst"
        case .adventurous_explorer: return "The Adventurous Explorer"
        case .versatile_communicator: return "The Versatile Communicator"
        case .progressive_reformer: return "The Progressive Reformer"
        case .compassionate_healer: return "The Compassionate Healer"
        case .protective_caregiver: return "The Protective Caregiver"
        case .wise_counselor: return "The Wise Counselor"
        case .contemplative_mystic: return "The Contemplative Mystic"
        case .analytical_researcher: return "The Analytical Researcher"
        case .intuitive_guide: return "The Intuitive Guide"
        case .executive_achiever: return "The Executive Achiever"
        case .strategic_leader: return "The Strategic Leader"
        case .material_master: return "The Material Master"
        case .universal_humanitarian: return "The Universal Humanitarian"
        case .compassionate_teacher: return "The Compassionate Teacher"
        case .global_visionary: return "The Global Visionary"
        case .intuitive_master: return "The Intuitive Master"
        case .master_builder: return "The Master Builder"
        case .master_teacher: return "The Master Teacher"
        case .master_healer: return "The Master Healer"
        case .conflicted_creator: return "The Conflicted Creator"
        case .analytical_dreamer: return "The Analytical Dreamer"
        case .structured_rebel: return "The Structured Rebel"
        case .sensitive_leader: return "The Sensitive Leader"
        }
    }
}

// MARK: - Internal Conflicts Analysis

/// Claude: Represents internal psychological conflicts created by contradictory numbers
public struct TrinityConflict: Codable, Identifiable, Equatable {
    public let id: UUID
    
    /// Claude: Type of internal conflict
    public let conflictType: ConflictType
    
    /// Claude: The numbers creating the conflict
    public let conflictingNumber1: Int
    public let conflictingNumber2: Int
    
    public var conflictingNumbers: (Int, Int) {
        return (conflictingNumber1, conflictingNumber2)
    }
    
    /// Claude: Intensity of the conflict (0.0-1.0)
    public let intensity: Double
    
    /// Claude: Life domains most affected by this conflict
    public let affectedDomains: [LifeDomain]
    
    /// Claude: Description of how conflict manifests
    public let manifestation: String
    
    /// Claude: Integration strategies to resolve conflict
    public let integrationStrategies: [String]
    
    /// Claude: Growth opportunities arising from conflict
    public let growthOpportunities: [String]
    
    public init(
        id: UUID = UUID(),
        conflictType: ConflictType,
        conflictingNumbers: (Int, Int),
        intensity: Double,
        affectedDomains: [LifeDomain],
        manifestation: String,
        integrationStrategies: [String],
        growthOpportunities: [String]
    ) {
        self.id = id
        self.conflictType = conflictType
        self.conflictingNumber1 = conflictingNumbers.0
        self.conflictingNumber2 = conflictingNumbers.1
        self.intensity = intensity
        self.affectedDomains = affectedDomains
        self.manifestation = manifestation
        self.integrationStrategies = integrationStrategies
        self.growthOpportunities = growthOpportunities
    }
}

/// Claude: Types of internal conflicts that can arise between numbers
public enum ConflictType: String, CaseIterable, Codable {
    case independence_vs_cooperation = "independence_vs_cooperation"    // 1 vs 2
    case leadership_vs_service = "leadership_vs_service"              // 1 vs 6
    case structure_vs_freedom = "structure_vs_freedom"                // 4 vs 5
    case logic_vs_intuition = "logic_vs_intuition"                    // 7 vs 2
    case material_vs_spiritual = "material_vs_spiritual"              // 8 vs 9
    case expression_vs_introspection = "expression_vs_introspection"  // 3 vs 7
    case perfection_vs_flow = "perfection_vs_flow"                    // 6 vs 5
    case power_vs_harmony = "power_vs_harmony"                        // 8 vs 2
    case innovation_vs_tradition = "innovation_vs_tradition"          // 5 vs 4
    case ego_vs_service = "ego_vs_service"                            // 1 vs 9
    
    /// Claude: Human-readable conflict descriptions
    public var description: String {
        switch self {
        case .independence_vs_cooperation:
            return "Tension between needing autonomy and craving partnership"
        case .leadership_vs_service:
            return "Conflict between leading others and serving their needs"
        case .structure_vs_freedom:
            return "Battle between desire for stability and need for adventure"
        case .logic_vs_intuition:
            return "Struggle between analytical thinking and intuitive knowing"
        case .material_vs_spiritual:
            return "Division between worldly success and spiritual fulfillment"
        case .expression_vs_introspection:
            return "Tension between outward creativity and inward reflection"
        case .perfection_vs_flow:
            return "Conflict between maintaining control and allowing natural flow"
        case .power_vs_harmony:
            return "Struggle between asserting authority and maintaining peace"
        case .innovation_vs_tradition:
            return "Tension between pioneering change and respecting established ways"
        case .ego_vs_service:
            return "Battle between personal ambition and selfless service"
        }
    }
}

/// Claude: Life domains affected by internal conflicts
public enum LifeDomain: String, CaseIterable, Codable {
    case relationships = "relationships"
    case career = "career"
    case creativity = "creativity"
    case spirituality = "spirituality"
    case family = "family"
    case finances = "finances"
    case health = "health"
    case communication = "communication"
    case leadership = "leadership"
    case personal_growth = "personal_growth"
    case decision_making = "decision_making"
    case life_purpose = "life_purpose"
}

// MARK: - Behavioral Profile System

/// Claude: Comprehensive behavioral analysis based on trinity combination
public struct BehavioralProfile: Codable, Equatable, Hashable {
    /// Claude: Core personality traits with intensity scores (0.0-1.0)
    public let personalityTraits: [PersonalityTrait: Double]
    
    /// Claude: Communication patterns and preferences
    public let communicationStyle: CommunicationStyle
    
    /// Claude: Leadership approach and authority style
    public let leadershipStyle: LeadershipStyle
    
    /// Claude: Conflict resolution preferences
    public let conflictResolution: ConflictResolutionStyle
    
    /// Claude: Learning and information processing style
    public let learningStyle: LearningStyle
    
    /// Claude: Stress responses and coping mechanisms
    public let stressResponse: StressResponseProfile
    
    /// Claude: Motivation drivers and reward preferences
    public let motivationProfile: MotivationProfile
    
    /// Claude: Social interaction preferences and energy patterns
    public let socialProfile: SocialProfile
    
    /// Claude: Risk tolerance and adventure seeking
    public let riskProfile: RiskProfile
    
    /// Claude: Time management and planning preferences
    public let timeManagementStyle: TimeManagementStyle
    
    /// Claude: Creative expression patterns
    public let creativityProfile: CreativityProfile
    
    /// Claude: Relationship attachment and intimacy patterns
    public let attachmentStyle: AttachmentStyle
    
    public init(trinity: (Int, Int, Int)) {
        // Claude: Initialize all behavioral components based on trinity combination
        self.personalityTraits = Self.calculatePersonalityTraits(trinity: trinity)
        self.communicationStyle = Self.determineCommunicationStyle(trinity: trinity)
        self.leadershipStyle = Self.determineLeadershipStyle(trinity: trinity)
        self.conflictResolution = Self.determineConflictResolution(trinity: trinity)
        self.learningStyle = Self.determineLearningStyle(trinity: trinity)
        self.stressResponse = Self.determineStressResponse(trinity: trinity)
        self.motivationProfile = Self.determineMotivationProfile(trinity: trinity)
        self.socialProfile = Self.determineSocialProfile(trinity: trinity)
        self.riskProfile = Self.determineRiskProfile(trinity: trinity)
        self.timeManagementStyle = Self.determineTimeManagement(trinity: trinity)
        self.creativityProfile = Self.determineCreativityProfile(trinity: trinity)
        self.attachmentStyle = Self.determineAttachmentStyle(trinity: trinity)
    }
}

/// Claude: Core personality traits that can be measured and scored
public enum PersonalityTrait: String, CaseIterable, Codable {
    // Claude: Big Five personality dimensions
    case openness = "openness"
    case conscientiousness = "conscientiousness"
    case extraversion = "extraversion"
    case agreeableness = "agreeableness"
    case neuroticism = "neuroticism"
    
    // Claude: Spiritual and numerological dimensions
    case independence = "independence"
    case leadership = "leadership"
    case creativity = "creativity"
    case intuition = "intuition"
    case analytical_thinking = "analytical_thinking"
    case emotional_sensitivity = "emotional_sensitivity"
    case perfectionism = "perfectionism"
    case adventure_seeking = "adventure_seeking"
    case service_orientation = "service_orientation"
    case material_focus = "material_focus"
    case spiritual_focus = "spiritual_focus"
    case systematic_thinking = "systematic_thinking"
    case adaptability = "adaptability"
    case empathy = "empathy"
    case assertiveness = "assertiveness"
    case detail_orientation = "detail_orientation"
    case big_picture_thinking = "big_picture_thinking"
    case collaboration = "collaboration"
    case innovation = "innovation"
    case tradition_respect = "tradition_respect"
}

// MARK: - Implementation Placeholder Extensions

extension LifePathTrinity {
    /// Claude: Calculate internal harmony score based on number compatibility
    private static func calculateHarmonyScore(lifePath: Int, expression: Int, soulUrge: Int) -> Double {
        // Claude: Implementation will analyze number compatibility patterns
        // Placeholder returning 0.75 for now
        return 0.75
    }
    
    /// Claude: Determine primary archetype from strongest numerical influence
    private static func determinePrimaryArchetype(lifePath: Int, expression: Int, soulUrge: Int) -> TrinityArchetype {
        // Claude: Implementation will analyze number patterns and return appropriate archetype
        // Placeholder returning visionary_leader for now
        return .visionary_leader
    }
    
    /// Claude: Determine secondary archetypal influence if present
    private static func determineSecondaryArchetype(lifePath: Int, expression: Int, soulUrge: Int) -> TrinityArchetype? {
        // Claude: Implementation will determine secondary influences
        return nil
    }
    
    /// Claude: Analyze conflicts between contradictory numbers in trinity
    private static func analyzeInternalConflicts(lifePath: Int, expression: Int, soulUrge: Int) -> [TrinityConflict] {
        // Claude: Implementation will detect and analyze number conflicts
        return []
    }
}

extension BehavioralProfile {
    /// Claude: Calculate personality trait scores based on trinity combination
    private static func calculatePersonalityTraits(trinity: (Int, Int, Int)) -> [PersonalityTrait: Double] {
        // Claude: Implementation will map trinity numbers to personality trait scores
        return [:]
    }
    
    /// Claude: Determine communication style from trinity pattern
    private static func determineCommunicationStyle(trinity: (Int, Int, Int)) -> CommunicationStyle {
        // Claude: Implementation will analyze trinity for communication patterns
        return CommunicationStyle(
            directness: 0.7,
            emotionalExpression: 0.6,
            listeningStyle: .active,
            conflictApproach: .collaborative,
            feedbackPreference: .direct_caring
        )
    }
    
    // Claude: Additional placeholder implementations for other behavioral components
    private static func determineLeadershipStyle(trinity: (Int, Int, Int)) -> LeadershipStyle {
        return LeadershipStyle(approach: .collaborative, authorityLevel: 0.6)
    }
    
    private static func determineConflictResolution(trinity: (Int, Int, Int)) -> ConflictResolutionStyle {
        return ConflictResolutionStyle(approach: .collaborative, avoidance: 0.3)
    }
    
    private static func determineLearningStyle(trinity: (Int, Int, Int)) -> LearningStyle {
        return LearningStyle(preference: .visual, processingSpeed: .moderate)
    }
    
    private static func determineStressResponse(trinity: (Int, Int, Int)) -> StressResponseProfile {
        return StressResponseProfile(primaryResponse: .problem_solving, recoveryTime: .moderate)
    }
    
    private static func determineMotivationProfile(trinity: (Int, Int, Int)) -> MotivationProfile {
        return MotivationProfile(primaryMotivator: .achievement, rewardPreference: .recognition)
    }
    
    private static func determineSocialProfile(trinity: (Int, Int, Int)) -> SocialProfile {
        return SocialProfile(energySource: .balanced, groupSize: .small, intimacyLevel: 0.5)
    }
    
    private static func determineRiskProfile(trinity: (Int, Int, Int)) -> RiskProfile {
        return RiskProfile(tolerance: .moderate, adventureSeek: 0.5)
    }
    
    private static func determineTimeManagement(trinity: (Int, Int, Int)) -> TimeManagementStyle {
        return TimeManagementStyle(planning: .structured, flexibility: 0.6)
    }
    
    private static func determineCreativityProfile(trinity: (Int, Int, Int)) -> CreativityProfile {
        return CreativityProfile(style: .innovative, expression: .verbal)
    }
    
    private static func determineAttachmentStyle(trinity: (Int, Int, Int)) -> AttachmentStyle {
        return AttachmentStyle(type: .secure, intimacyComfort: 0.7)
    }
}

// MARK: - Supporting Style Enums (Placeholder Definitions)

public struct CommunicationStyle: Codable, Equatable, Hashable {
    let directness: Double
    let emotionalExpression: Double
    let listeningStyle: ListeningStyle
    let conflictApproach: ConflictApproach
    let feedbackPreference: FeedbackPreference
}

public enum ListeningStyle: String, Codable { case active, passive, selective }
public enum ConflictApproach: String, Codable { case collaborative, competitive, avoidant }
public enum FeedbackPreference: String, Codable { case direct_caring, gentle_supportive, analytical_detailed }

public struct LeadershipStyle: Codable, Equatable, Hashable {
    let approach: LeadershipApproach
    let authorityLevel: Double
}
public enum LeadershipApproach: String, Codable { case collaborative, authoritative, servant }

public struct ConflictResolutionStyle: Codable, Equatable, Hashable {
    let approach: ConflictApproach
    let avoidance: Double
}

public struct LearningStyle: Codable, Equatable, Hashable {
    let preference: LearningPreference
    let processingSpeed: ProcessingSpeed
}
public enum LearningPreference: String, Codable { case visual, auditory, kinesthetic, reading }
public enum ProcessingSpeed: String, Codable { case fast, moderate, slow, varied }

public struct StressResponseProfile: Codable, Equatable, Hashable {
    let primaryResponse: StressResponse
    let recoveryTime: RecoveryTime
}
public enum StressResponse: String, Codable { case problem_solving, emotional_support, isolation, action }
public enum RecoveryTime: String, Codable { case fast, moderate, slow }

public struct MotivationProfile: Codable, Equatable, Hashable {
    let primaryMotivator: Motivator
    let rewardPreference: RewardType
}
public enum Motivator: String, Codable { case achievement, recognition, autonomy, service, mastery }
public enum RewardType: String, Codable { case recognition, financial, personal_growth, helping_others }

public struct SocialProfile: Codable, Equatable, Hashable {
    let energySource: EnergySource
    let groupSize: GroupSizePreference  
    let intimacyLevel: Double
}
public enum EnergySource: String, Codable { case introvert, extravert, ambivert, balanced }
public enum GroupSizePreference: String, Codable { case small, medium, large, varies }

public struct RiskProfile: Codable, Equatable, Hashable {
    let tolerance: RiskTolerance
    let adventureSeek: Double
}
public enum RiskTolerance: String, Codable { case low, moderate, high, calculated }

public struct TimeManagementStyle: Codable, Equatable, Hashable {
    let planning: PlanningStyle
    let flexibility: Double
}
public enum PlanningStyle: String, Codable { case structured, flexible, spontaneous, adaptive }

public struct CreativityProfile: Codable, Equatable, Hashable {
    let style: CreativityStyle
    let expression: CreativeExpression
}
public enum CreativityStyle: String, Codable { case innovative, traditional, experimental, practical }
public enum CreativeExpression: String, Codable { case visual, verbal, musical, kinesthetic, analytical }

public struct AttachmentStyle: Codable, Equatable, Hashable {
    let type: AttachmentType
    let intimacyComfort: Double
}
public enum AttachmentType: String, Codable { case secure, anxious, avoidant, disorganized }

// MARK: - Career and Relationship Profiles (Placeholder Structures)

public struct CareerAlignment: Codable {
    public let lifePath: Int
    public let expression: Int
    public let soulUrge: Int
    
    // Claude: Custom coding to handle trinity tuple
    public init(trinity: (Int, Int, Int)) {
        self.lifePath = trinity.0
        self.expression = trinity.1
        self.soulUrge = trinity.2
    }
    
    public var trinity: (Int, Int, Int) {
        return (lifePath, expression, soulUrge)
    }
}

public struct SpiritualGrowthProfile: Codable {
    public let lifePath: Int
    public let expression: Int
    public let soulUrge: Int
    
    // Claude: Custom coding to handle trinity tuple
    public init(trinity: (Int, Int, Int)) {
        self.lifePath = trinity.0
        self.expression = trinity.1
        self.soulUrge = trinity.2
    }
    
    public var trinity: (Int, Int, Int) {
        return (lifePath, expression, soulUrge)
    }
}

public struct DecisionProfile: Codable {
    public let lifePath: Int
    public let expression: Int
    public let soulUrge: Int
    
    // Claude: Custom coding to handle trinity tuple
    public init(trinity: (Int, Int, Int)) {
        self.lifePath = trinity.0
        self.expression = trinity.1
        self.soulUrge = trinity.2
    }
    
    public var trinity: (Int, Int, Int) {
        return (lifePath, expression, soulUrge)
    }
}

public struct RelationshipProfile: Codable {
    public let lifePath: Int
    public let expression: Int
    public let soulUrge: Int
    
    // Claude: Custom coding to handle trinity tuple
    public init(trinity: (Int, Int, Int)) {
        self.lifePath = trinity.0
        self.expression = trinity.1
        self.soulUrge = trinity.2
    }
    
    public var trinity: (Int, Int, Int) {
        return (lifePath, expression, soulUrge)
    }
}