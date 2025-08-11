//
//  RichContentValidator.swift
//  VybeMVP
//
//  KASPER MLX Runtime Validation System v2.1.4
//  Bulletproof spiritual content validation with real-time guardrails
//
//  Created by KASPER MLX Team on 8/10/25.
//

import Foundation
import os.log

// MARK: - Content Structure Models

/// Represents a single behavioral insight with validation-ready structure
struct RichInsight: Decodable {
    let category: String
    let insight: String
    let intensity: Double
    let triggers: [String]?
    let supports: [String]?
    let challenges: [String]?
}

/// Metadata section with flexible additional properties for master numbers
struct RichMeta: Decodable {
    let type: String        // "single" or "master"
    let archetype: String   // Core spiritual archetype (snake_case)
    let keywords: [String]  // Descriptive keywords
    let affirmations: [String]
    let rituals: [String]

    // Tolerate additional properties (base_number, master_vibration, etc.)
    // This allows master numbers to have extended metadata
}

/// Complete rich content file structure matching our JSON schema
struct RichNumberFile: Decodable {
    let number: Int
    let title: String
    let source: String
    let persona: String
    let behavioral_category: String
    let intensity_scoring: [String: Double]
    let behavioral_insights: [RichInsight]
    let meta: RichMeta
}

// MARK: - Validation Errors

/// Comprehensive validation errors with detailed descriptions
enum RichValidationError: Error, CustomStringConvertible {
    case intensityOutOfRange(Double, context: String)
    case badSnakeCase(String, context: String)
    case missingInsights(count: Int)
    case invalidNumberRange(Int)
    case emptyInsightText
    case invalidPersona(String)
    case invalidSource(String)

    var description: String {
        switch self {
        case .intensityOutOfRange(let value, let context):
            return "❌ Intensity \(value) outside valid range [0.0, 1.0] in \(context)"
        case .badSnakeCase(let token, let context):
            return "❌ Non-snake_case token '\(token)' in \(context)"
        case .missingInsights(let count):
            return "❌ Insufficient behavioral insights: found \(count), expected 20"
        case .invalidNumberRange(let num):
            return "❌ Invalid number \(num): must be 1-9, 11, 22, 33, or 44"
        case .emptyInsightText:
            return "❌ Empty insight text found"
        case .invalidPersona(let persona):
            return "❌ Invalid persona '\(persona)': must be one of the approved spiritual personas"
        case .invalidSource(let source):
            return "❌ Invalid source '\(source)': must be 'single_numbers', 'master_numbers', or 'behavioral'"
        }
    }
}

// MARK: - Main Validator

/// KASPER MLX Content Validator - Bulletproof runtime validation system
///
/// Ensures all spiritual content meets quality standards before use in AI generation.
/// Provides detailed error reporting and safe fallback recommendations.
struct RichContentValidator {

    // MARK: - Constants

    /// Valid numerological numbers for VybeMVP
    private static let validNumbers: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]

    /// Approved spiritual personas for content generation
    private static let validPersonas: Set<String> = [
        "NumerologyMaster", "MasterTeacher", "Oracle", "Psychologist",
        "MindfulnessCoach", "NumerologyScholar", "Philosopher"
    ]

    /// Valid content sources
    private static let validSources: Set<String> = ["single_numbers", "master_numbers", "behavioral"]

    /// Snake_case validation regex (lowercase letters, numbers, underscores only)
    private static let snakeRegex: NSRegularExpression = {
        do {
            return try NSRegularExpression(pattern: #"^[a-z0-9_]+$"#)
        } catch {
            fatalError("Invalid regex pattern for snake_case validation: \(error)")
        }
    }()

    // MARK: - Main Validation Entry Point

    /// Validates a complete rich content file against all quality standards
    /// - Parameter file: The decoded rich content file to validate
    /// - Throws: RichValidationError with detailed error information
    static func validate(_ file: RichNumberFile) throws {

        // 1. Validate number is in acceptable range
        guard validNumbers.contains(file.number) else {
            throw RichValidationError.invalidNumberRange(file.number)
        }

        // 2. Validate persona is approved
        guard validPersonas.contains(file.persona) else {
            throw RichValidationError.invalidPersona(file.persona)
        }

        // 3. Validate source is recognized
        guard validSources.contains(file.source) else {
            throw RichValidationError.invalidSource(file.source)
        }

        // 4. Validate we have exactly 20 behavioral insights (our standard)
        let insightCount = file.behavioral_insights.count
        guard insightCount == 20 else {
            throw RichValidationError.missingInsights(count: insightCount)
        }

        // 5. Validate intensity scoring bounds
        if let minRange = file.intensity_scoring["min_range"],
           let maxRange = file.intensity_scoring["max_range"] {
            guard (0.0...1.0).contains(minRange) else {
                throw RichValidationError.intensityOutOfRange(minRange, context: "intensity_scoring.min_range")
            }
            guard (0.0...1.0).contains(maxRange) else {
                throw RichValidationError.intensityOutOfRange(maxRange, context: "intensity_scoring.max_range")
            }

            // 6. Validate individual insights against intensity bounds
            try validateInsights(file.behavioral_insights, minRange: minRange, maxRange: maxRange)
        }

        // 7. Validate meta section structure
        try validateMetaSection(file.meta)

        // 8. Validate snake_case compliance
        try validateSnakeCaseCompliance(file)
    }

    // MARK: - Detailed Validation Methods

    /// Validates individual behavioral insights for content quality
    private static func validateInsights(_ insights: [RichInsight], minRange: Double, maxRange: Double) throws {
        for (index, insight) in insights.enumerated() {
            let context = "behavioral_insights[\(index)]"

            // Check intensity is within [0.0, 1.0] bounds
            guard (0.0...1.0).contains(insight.intensity) else {
                throw RichValidationError.intensityOutOfRange(insight.intensity, context: "\(context).intensity")
            }

            // Check insight text is not empty
            guard !insight.insight.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw RichValidationError.emptyInsightText
            }

            // Validate snake_case in array fields
            if let triggers = insight.triggers {
                for trigger in triggers {
                    guard matchesSnakeCase(trigger) else {
                        throw RichValidationError.badSnakeCase(trigger, context: "\(context).triggers")
                    }
                }
            }

            if let supports = insight.supports {
                for support in supports {
                    guard matchesSnakeCase(support) else {
                        throw RichValidationError.badSnakeCase(support, context: "\(context).supports")
                    }
                }
            }

            if let challenges = insight.challenges {
                for challenge in challenges {
                    guard matchesSnakeCase(challenge) else {
                        throw RichValidationError.badSnakeCase(challenge, context: "\(context).challenges")
                    }
                }
            }
        }
    }

    /// Validates meta section completeness and structure
    private static func validateMetaSection(_ meta: RichMeta) throws {
        // Validate meta keywords are snake_case
        for keyword in meta.keywords {
            guard matchesSnakeCase(keyword) else {
                throw RichValidationError.badSnakeCase(keyword, context: "meta.keywords")
            }
        }

        // Validate archetype is snake_case
        guard matchesSnakeCase(meta.archetype) else {
            throw RichValidationError.badSnakeCase(meta.archetype, context: "meta.archetype")
        }

        // Validate type is valid
        guard ["single", "master"].contains(meta.type) else {
            throw RichValidationError.invalidSource(meta.type) // Reusing error type
        }
    }

    /// Validates snake_case compliance across all relevant fields
    private static func validateSnakeCaseCompliance(_ file: RichNumberFile) throws {
        // Validate behavioral_category
        guard matchesSnakeCase(file.behavioral_category) else {
            throw RichValidationError.badSnakeCase(file.behavioral_category, context: "behavioral_category")
        }

        // Validate insight categories
        for (index, insight) in file.behavioral_insights.enumerated() {
            guard matchesSnakeCase(insight.category) else {
                throw RichValidationError.badSnakeCase(insight.category, context: "behavioral_insights[\(index)].category")
            }
        }
    }

    /// Checks if a string matches snake_case pattern (lowercase + underscores only)
    private static func matchesSnakeCase(_ string: String) -> Bool {
        let range = NSRange(string.startIndex..., in: string)
        return snakeRegex.firstMatch(in: string, options: [], range: range) != nil
    }
}

// MARK: - Usage Extensions

extension OSLog {
    /// Dedicated log category for content validation
    static let contentValidation = OSLog(subsystem: "app.vybe", category: "content.validation")
}

/// Convenience extension for safe content loading with validation
extension RichNumberFile {

    /// Safely loads and validates rich content from JSON data
    /// - Parameter data: Raw JSON data to decode and validate
    /// - Returns: Validated RichNumberFile ready for use
    /// - Throws: Decoding or validation errors with detailed context
    static func loadAndValidate(from data: Data) throws -> RichNumberFile {
        // 1. Decode JSON structure
        let decoded = try JSONDecoder().decode(RichNumberFile.self, from: data)

        // 2. Validate content quality
        try RichContentValidator.validate(decoded)

        // 3. Log successful validation
        os_log("✅ Validated rich content for number %d (%@)",
               log: .contentValidation, type: .info,
               decoded.number, decoded.source)

        return decoded
    }

    /// Safe loading with fallback strategy for production resilience
    /// - Parameters:
    ///   - data: Primary content data to attempt loading
    ///   - fallbackHandler: Called if validation fails, should provide safe fallback
    /// - Returns: Either validated content or safe fallback
    static func loadWithFallback(
        from data: Data,
        number: Int,
        fallbackHandler: (Error) -> RichNumberFile?
    ) -> RichNumberFile? {
        do {
            return try loadAndValidate(from: data)
        } catch {
            os_log("❌ Rich content validation failed for number %d: %{public}@",
                   log: .contentValidation, type: .error,
                   number, error.localizedDescription)

            // Record fallback for telemetry
            recordFallback(number: "\(number)", kind: .validationError)

            return fallbackHandler(error)
        }
    }
}

// MARK: - Fallback Telemetry

/// Types of fallback scenarios for telemetry tracking
enum FallbackKind: String, CaseIterable {
    case masterToBase = "master_to_base"
    case legacySingle = "legacy_single"
    case decodeError = "decode_error"
    case validationError = "validation_error"
}

/// Records fallback events for monitoring and improvement
/// - Parameters:
///   - number: The numerological number that required fallback
///   - kind: The type of fallback scenario
func recordFallback(number: String, kind: FallbackKind) {
    os_log("🔄 Fallback %{public}@ for number %{public}@",
           log: .contentValidation, type: .info,
           kind.rawValue, number)

    // TODO: Pipe to analytics SDK when available
    // Analytics.track("content_fallback", properties: ["number": number, "kind": kind.rawValue])
}
