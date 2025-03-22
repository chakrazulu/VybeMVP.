/**
 * Filename: NumberMatchInsight.swift
 * 
 * Purpose: Defines the model for insights displayed when focus and realm numbers match.
 * These insights are used in push notifications and in-app displays to provide users
 * with meaningful information about their number matches.
 *
 * Key components:
 * - NumberMatchInsight struct: Represents the insight for a specific number match
 * - NumberMatchInsightManager: Manages the collection of insights and provides access
 *
 * Dependencies: Foundation
 */

import Foundation

/**
 * Represents an insight for a specific number match
 *
 * When a user's focus number matches the calculated realm number, this model
 * provides the content for the notification and detailed explanation to be shown.
 */
struct NumberMatchInsight: Codable, Identifiable, Hashable {
    /// Unique identifier for the insight
    var id: UUID = UUID()
    
    /// The number that matched (focus number = realm number)
    let matchNumber: Int
    
    /// Brief title shown in the notification
    let title: String
    
    /// Short message shown in the notification body
    let summary: String
    
    /// Detailed explanation of the match significance
    let detailedInsight: String
    
    /// Additional notes or context about this match (optional)
    var notes: [String] = []
}

/**
 * Manages the collection of number match insights
 *
 * This singleton class provides access to insights for each possible number match.
 * It initializes with predefined insights but can be extended with dynamic or AI-generated
 * content in future iterations.
 */
class NumberMatchInsightManager {
    /// Shared singleton instance for app-wide access
    static let shared = NumberMatchInsightManager()
    
    /// Collection of insights for each number (0-9)
    private var insights: [NumberMatchInsight] = []
    
    /// Flag to track if insights have been initialized
    private var initialized = false
    
    /// Default fallback insight used when a specific number insight isn't found
    private var fallbackInsight: NumberMatchInsight {
        return NumberMatchInsight(
            matchNumber: -1,
            title: "Number Match Found!",
            summary: "Your focus number has aligned with the realm number.",
            detailedInsight: "When your focus number matches the realm number, it creates a moment of synchronicity. This alignment suggests you're in flow with the universal energy."
        )
    }
    
    /// Private initializer to enforce singleton pattern
    private init() {
        setupInitialInsights()
    }
    
    /**
     * Initialize predefined insights for each number
     *
     * These initial insights provide meaningful content for number match notifications.
     * In future iterations, these could be dynamically generated or personalized.
     */
    private func setupInitialInsights() {
        print("📚 Setting up number match insights...")
        
        // Number 0 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 0,
            title: "Void Match - The All",
            summary: "Your focus on Zero aligns with today's realm energy!",
            detailedInsight: "When Zero appears as both your focus and realm number, you're experiencing the energy of infinite potential. This rare alignment invites you to contemplate the void from which all creation emerges. It's a powerful time for meditation, resetting intentions, and connecting with the vastness of universal consciousness."
        ))
        
        // Number 1 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 1,
            title: "Unity Match - The Beginning",
            summary: "Your focus on One aligns with today's realm energy!",
            detailedInsight: "The alignment of One as both your focus and realm number signifies a powerful moment of initiation and self-awareness. This is an optimal time for starting new projects, setting intentions, and stepping into your authentic self. The unified energy of One amplifies your individual power and clarity of purpose."
        ))
        
        // Number 2 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 2,
            title: "Duality Match - The Balance",
            summary: "Your focus on Two aligns with today's realm energy!",
            detailedInsight: "With Two as both your focus and realm number, you're experiencing a harmonious balance of duality. This alignment enhances your ability to see multiple perspectives and find equilibrium in relationships. It's an excellent time for diplomatic endeavors, partnership work, and reconciling opposing forces in your life."
        ))
        
        // Number 3 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 3,
            title: "Harmony Match - Creative Expression",
            summary: "Your focus on Three aligns with today's realm energy!",
            detailedInsight: "The alignment of Three in both your focus and realm numbers amplifies your creative energy and expressiveness. This synchronicity brings a flow of inspiration and communicative power. Embrace artistic projects, social connections, and the joy of self-expression during this harmonious alignment."
        ))
        
        // Number 4 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 4,
            title: "Foundation Match - Stability",
            summary: "Your focus on Four aligns with today's realm energy!",
            detailedInsight: "With Four matching in both focus and realm, you're experiencing a powerful grounding energy. This alignment strengthens your ability to build stable foundations and implement practical systems. Use this time for organizing, planning, and establishing reliable structures in your life and work."
        ))
        
        // Number 5 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 5,
            title: "Freedom Match - Adaptation",
            summary: "Your focus on Five aligns with today's realm energy!",
            detailedInsight: "The alignment of Five in both focus and realm numbers creates a dynamic energy of freedom and change. This synchronicity enhances your adaptability and amplifies opportunities for positive transformation. Embrace adventure, sensory experiences, and constructive change during this exciting alignment."
        ))
        
        // Number 6 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 6,
            title: "Harmony Match - Responsibility",
            summary: "Your focus on Six aligns with today's realm energy!",
            detailedInsight: "With Six matching in both focus and realm, you're experiencing a beautiful harmony of nurturing energy. This alignment enhances your capacity for responsibility, care, and balanced relationships. It's an ideal time for family connections, healing work, and bringing beauty into your environment."
        ))
        
        // Number 7 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 7,
            title: "Wisdom Match - Inner Truth",
            summary: "Your focus on Seven aligns with today's realm energy!",
            detailedInsight: "The alignment of Seven in both focus and realm creates a powerful portal for spiritual insight and deep wisdom. This synchronicity enhances your intuitive abilities and connection to higher knowledge. Embrace meditation, research, and contemplative practices during this mystical alignment."
        ))
        
        // Number 8 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 8,
            title: "Power Match - Manifestation",
            summary: "Your focus on Eight aligns with today's realm energy!",
            detailedInsight: "With Eight matching in both focus and realm, you're experiencing a powerful alignment of abundance and manifestation energy. This synchronicity enhances your ability to create material success and wield personal power effectively. It's an optimal time for business decisions, investments, and bringing your visions into reality."
        ))
        
        // Number 9 Match
        addOrUpdateInsight(NumberMatchInsight(
            matchNumber: 9,
            title: "Completion Match - Transcendence",
            summary: "Your focus on Nine aligns with today's realm energy!",
            detailedInsight: "The alignment of Nine in both focus and realm numbers creates a transcendent energy of completion and universal love. This synchronicity enhances your capacity for compassion, letting go, and embracing the bigger picture. It's a powerful time for humanitarian efforts, completing cycles, and spiritual awakening."
        ))
        
        initialized = true
        print("✅ Initialized \(insights.count) number match insights")
    }
    
    /**
     * Get the insight for a specific match number
     *
     * @param number The number (0-9) to retrieve the insight for
     * @return The NumberMatchInsight if found, a fallback insight otherwise
     */
    func getInsight(for number: Int) -> NumberMatchInsight {
        // Ensure insights are initialized
        if !initialized {
            print("⚠️ Insights were not initialized, initializing now...")
            setupInitialInsights()
        }
        
        // Check if the insight is available
        if let insight = insights.first(where: { $0.matchNumber == number }) {
            print("✅ Found insight for number \(number): \(insight.title)")
            return insight
        }
        
        // Log the missing insight and return a fallback
        print("⚠️ No insight found for number \(number), using fallback insight")
        return fallbackInsight
    }
    
    /**
     * Add a new insight or update an existing one
     *
     * @param insight The NumberMatchInsight to add or update
     */
    func addOrUpdateInsight(_ insight: NumberMatchInsight) {
        if let index = insights.firstIndex(where: { $0.matchNumber == insight.matchNumber }) {
            insights[index] = insight
        } else {
            insights.append(insight)
        }
    }
    
    /**
     * Get all insights in numerical order
     *
     * @return Array of NumberMatchInsight objects sorted by match number
     */
    func getAllInsights() -> [NumberMatchInsight] {
        // Ensure insights are initialized
        if !initialized {
            print("⚠️ Insights were not initialized, initializing now...")
            setupInitialInsights()
        }
        
        return insights.sorted { $0.matchNumber < $1.matchNumber }
    }
    
    /**
     * Force reinitialization of insights
     * Useful for ensuring insights are fresh before background operations
     */
    func reinitializeInsights() {
        print("🔄 Reinitializing number match insights...")
        insights.removeAll()
        initialized = false
        setupInitialInsights()
    }
} 