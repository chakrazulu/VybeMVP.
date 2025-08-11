//
//  NumberRichContent.swift
//  VybeMVP
//
//  Created by KASPER MLX Team on August 2025.
//  Copyright © 2025 Vybe. All rights reserved.
//
//  PURPOSE:
//  Flexible, forward-compatible decoding model for rich number content
//  from the KASPERMLXRuntimeBundle. Matches actual behavioral insight schema
//  with spiritual categories, intensity scoring, and persona-based content.
//
//  SCHEMA EVOLUTION STORY:
//  - v1.0: Simple overview/symbolism/correspondences/practices structure
//  - v2.1.5: Rich behavioral insights with intensity scoring and persona guides
//  - Current: Supports both schemas for backward compatibility
//
//  DATA SOURCE: KASPERMLXRuntimeBundle/RichNumberMeanings/{number}_rich.json
//  CONTENT: 20+ behavioral insights per number with 70-90% intensity scoring
//

import Foundation

/// Comprehensive model for rich spiritual number content from RuntimeBundle
/// Supports both new behavioral insights schema and legacy format for maximum compatibility
struct NumberRichContent: Decodable, Equatable {

    // MARK: - Primary Schema (v2.1.5) - Behavioral Insights Format

    /// The spiritual number (1-9, 11, 22, 33, 44)
    let number: Int?

    /// Rich descriptive title (e.g., "Number 7: The Mystic Seeker")
    let title: String?

    /// Content source identifier for tracking and validation
    let source: String?

    /// Spiritual guide persona (NumerologyMaster, Oracle, etc.)
    /// Used to provide context about the spiritual authority behind the insights
    let persona: String?

    /// High-level behavioral category (e.g., "spiritual_seeking", "creative_expression")
    /// Helps categorize the primary spiritual archetype of this number
    let behavioral_category: String?

    /// Intensity scoring system for spiritual energy levels
    /// Provides quantified energy ranges and explanatory notes
    let intensity_scoring: IntensityScoring?

    /// Array of detailed behavioral insights with categories, intensities, and triggers
    /// This is the heart of the rich content - 20+ insights per number
    let behavioral_insights: [BehavioralInsight]?

    // MARK: - Nested Data Structures

    /// Quantified spiritual energy intensity for this number
    /// Provides min/max ranges (e.g., 0.7-0.9) with explanatory context
    struct IntensityScoring: Decodable, Equatable {
        /// Minimum intensity range (0.0-1.0) - baseline spiritual energy
        let min_range: Double?

        /// Maximum intensity range (0.0-1.0) - peak spiritual energy
        let max_range: Double?

        /// Human-readable explanation of the intensity scoring
        /// e.g., "Number 7 operates with deep, introspective energy focused on spiritual seeking"
        let note: String?
    }

    /// Individual behavioral insight with category, content, and metadata
    /// Each number has 20+ of these providing comprehensive spiritual guidance
    struct BehavioralInsight: Decodable, Equatable {
        /// Insight category (e.g., "core_essence", "spiritual_growth", "relationships")
        /// Helps organize insights into meaningful groups for UI display
        let category: String?

        /// The actual spiritual insight text - rich, detailed guidance
        /// Often contains markdown formatting and deep spiritual wisdom
        let insight: String?

        /// Intensity level for this specific insight (0.0-1.0)
        /// Higher values indicate more intense or impactful insights
        let intensity: Double?

        /// Array of trigger words/phrases that activate this insight
        /// Used for contextual display and user experience personalization
        let triggers: [String]?

        /// Array of supportive practices, activities, or contexts that enhance this insight
        /// e.g., ["meditation_practice", "spiritual_study", "contemplative_activities"]
        /// Critical for providing actionable spiritual guidance to users
        let supports: [String]?

        /// Array of challenging situations or obstacles that can hinder this insight
        /// e.g., ["superficial_interactions", "material_focus", "social_pressure"]
        /// Essential for helping users recognize and navigate spiritual challenges
        let challenges: [String]?
    }

    // MARK: - Legacy Schema Support (v1.0) - Backward Compatibility

    /// Legacy section structure for old schema format
    /// Contains title, bullet points, and body text - simpler than behavioral insights
    struct Section: Decodable, Equatable {
        /// Section title (e.g., "Overview", "Symbolism")
        let title: String?

        /// Array of bullet-point strings for structured content
        let bullets: [String]?

        /// Main body text content for this section
        let body: String?
    }

    /// Legacy metadata structure for old schema format
    /// Primarily used for master number identification and base number references
    struct Meta: Decodable, Equatable {
        /// String representation of the number (legacy format)
        let number: String?

        /// Number type - "master" for 11/22/33/44, nil for single digits
        let type: String?

        /// Base number for master numbers (e.g., "1" for 11, "2" for 22)
        let base_number: String?
    }

    // MARK: - Legacy Schema Fields (Backward Compatibility Only)

    /// Legacy metadata - only present in old format files
    /// Kept for backward compatibility but new files use title/persona/behavioral_category instead
    let meta: Meta?

    /// Legacy overview section - basic introductory content
    /// New format uses behavioral_insights array with "core_essence" category instead
    let overview: Section?

    /// Legacy symbolism section - spiritual symbols and meanings
    /// New format integrates symbolism into behavioral insights with richer context
    let symbolism: Section?

    /// Legacy correspondences - simple key-value pairs (chakra, planet, color, etc.)
    /// New format uses triggers array for more sophisticated associations
    let correspondences: [String: String]?

    /// Legacy practices - array of spiritual practices and rituals
    /// New format integrates practices into behavioral insights with intensity scores
    let practices: [Section]?
}
