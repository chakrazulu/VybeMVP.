/**
 * KASPERContentImporter.swift
 *
 * 🎯 PHASE 0: CONTENT IMPORT SYSTEM
 *
 * ✅ PURPOSE: Import existing Claude Rich and Grok content for KASPER training and NumberMeaningView
 * ✅ ARCHITECTURE: Bridge between existing spiritual content and KASPER MLX ecosystem
 * ✅ INTEGRATION: Feeds NumberMeaningView and KASPERTrainingExporter
 *
 * CONTENT SOURCES:
 * - Claude Rich (CR1-CR44): Deep academic spiritual analysis (~10,000 words per number)
 * - Grok Structured: JSON with 180+ insights across 12 categories per number
 *
 * DATA FLOW:
 * ImportedContent → ContentImporter → NumberMeaningContent → UI Display + MLX Training
 *
 * WHY THIS IS REVOLUTIONARY:
 * - Instant access to 4,500+ existing spiritual insights
 * - Bootstrap KASPER training with high-quality content
 * - Populate NumberMeaningView with rich spiritual guidance
 * - Bridge gap between manual content and automated MLX generation
 */

import Foundation
import Combine
import os.log

/// Claude: Content types from different AI sources
public enum KASPERContentSource: String, CaseIterable, Codable {
    case claudeRich = "claude_rich"
    case grokOracle = "grok_oracle"
    case grokPsychologist = "grok_psychologist"
    case grokMindfulnessCoach = "grok_mindfulness_coach"
    case grokPhilosopher = "grok_philosopher"
    case grokNumerologyScholar = "grok_numerology_scholar"
    case kasperGenerated = "kasper_generated"
    case userFeedback = "user_feedback"

    var displayName: String {
        switch self {
        case .claudeRich: return "Claude Academic Analysis"
        case .grokOracle: return "Grok Oracle Insights"
        case .grokPsychologist: return "Grok Psychological Guidance"
        case .grokMindfulnessCoach: return "Grok Mindfulness Practices"
        case .grokPhilosopher: return "Grok Philosophical Wisdom"
        case .grokNumerologyScholar: return "Grok Numerology Scholar"
        case .kasperGenerated: return "KASPER AI Generated"
        case .userFeedback: return "User Enhanced Content"
        }
    }

    var spiritualVoice: String {
        switch self {
        case .claudeRich: return "Academic Scholar"
        case .grokOracle: return "Mystical Oracle"
        case .grokPsychologist: return "Compassionate Guide"
        case .grokMindfulnessCoach: return "Present Moment Teacher"
        case .grokPhilosopher: return "Wisdom Keeper"
        case .grokNumerologyScholar: return "Precision Numerologist"
        case .kasperGenerated: return "AI Companion"
        case .userFeedback: return "Community Voice"
        }
    }
}

/// Claude: Grok persona types for structured content
public enum GrokPersona: String, CaseIterable, Codable {
    case oracle = "Oracle"
    case psychologist = "Psychologist"
    case mindfulnessCoach = "MindfulnessCoach"
    case philosopher = "Philosopher"
    case numerologyScholar = "NumerologyScholar"

    var contentSource: KASPERContentSource {
        switch self {
        case .oracle: return .grokOracle
        case .psychologist: return .grokPsychologist
        case .mindfulnessCoach: return .grokMindfulnessCoach
        case .philosopher: return .grokPhilosopher
        case .numerologyScholar: return .grokNumerologyScholar
        }
    }

    var folderName: String {
        return rawValue
    }
}

/// Claude: Structured spiritual content for NumberMeaningView and training
public struct NumberMeaningContent: Codable, Identifiable {
    public let id: UUID
    public let number: Int
    public let sources: [KASPERContentSource]
    public let createdDate: Date
    public let lastUpdated: Date

    /// Claude: Rich academic content from Claude
    public let claudeContent: ClaudeRichContent?

    /// Claude: Multi-persona insights from Grok
    public let grokPersonaContent: [GrokPersona: GrokStructuredContent]

    /// Claude: Combined summary for quick access
    public let combinedSummary: String

    /// Claude: Ready-to-display categorized content
    public let displayContent: NumberDisplayContent

    /// Claude: Training-ready pairs for MLX
    public let trainingPairs: [KASPERTrainingPair]

    public init(
        id: UUID = UUID(),
        number: Int,
        sources: [KASPERContentSource],
        claudeContent: ClaudeRichContent? = nil,
        grokPersonaContent: [GrokPersona: GrokStructuredContent] = [:],
        combinedSummary: String,
        displayContent: NumberDisplayContent,
        trainingPairs: [KASPERTrainingPair]
    ) {
        self.id = id
        self.number = number
        self.sources = sources
        self.createdDate = Date()
        self.lastUpdated = Date()
        self.claudeContent = claudeContent
        self.grokPersonaContent = grokPersonaContent
        self.combinedSummary = combinedSummary
        self.displayContent = displayContent
        self.trainingPairs = trainingPairs
    }
}

/// Claude: Academic content structure from Claude Rich files
public struct ClaudeRichContent: Codable {
    public let coreEssence: String
    public let mysticalSignificance: String
    public let archetypes: String
    public let lifePathPersonality: String
    public let spiritualLessons: String
    public let shadowAspects: String
    public let manifestationPower: String
    public let relationshipDynamics: String
    public let careerGuidance: String
    public let healingJourney: String
    public let cosmicConnection: String
    public let practicalApplication: String

    /// Claude: Extract key themes for display
    public var keyThemes: [String] {
        // Will extract main themes from each section
        []
    }
}

/// Claude: Structured insights from Grok JSON format
public struct GrokStructuredContent: Codable {
    public let insights: [String]           // 180 spiritual guidance messages
    public let reflections: [String]        // Introspective prompts
    public let contemplations: [String]     // Meditation practices
    public let manifestations: [String]     // Affirmations to embody energy
    public let challenges: [String]         // Growth opportunities
    public let gifts: [String]              // Natural talents and abilities
    public let relationships: [String]      // Connection guidance
    public let career: [String]            // Professional spiritual alignment
    public let health: [String]            // Wellness and vitality
    public let creativity: [String]        // Creative expression
    public let spirituality: [String]      // Sacred practices
    public let wisdom: [String]            // Ancient knowledge

    /// Claude: Total content count across all categories
    public var totalContentCount: Int {
        insights.count + reflections.count + contemplations.count + manifestations.count +
        challenges.count + gifts.count + relationships.count + career.count +
        health.count + creativity.count + spirituality.count + wisdom.count
    }
}

/// Claude: UI-ready content for NumberMeaningView display
public struct NumberDisplayContent: Codable {
    public let title: String                // "The Leader" or "The Diplomat"
    public let essence: String             // Core spiritual meaning
    public let keyInsights: [String]       // Top 5-7 insights for quick display
    public let dailyGuidance: [String]     // Practical daily applications
    public let meditation: String          // Focused meditation guidance
    public let affirmation: String         // Powerful manifestation statement
    public let challenge: String           // Growth opportunity
    public let gift: String               // Natural talent to develop

    /// Claude: For UI preview and quick access
    public var preview: String {
        "\(title): \(essence)"
    }
}

/// Claude: Training pairs for KASPER MLX model learning
public struct KASPERTrainingPair: Codable, Identifiable {
    public let id: UUID
    public let context: String      // Spiritual question or scenario
    public let response: String     // Appropriate spiritual guidance
    public let source: KASPERContentSource
    public let quality: Float       // Quality score (0.0-1.0)
    public let domain: String       // Spiritual domain (insight, reflection, etc.)

    public init(
        id: UUID = UUID(),
        context: String,
        response: String,
        source: KASPERContentSource,
        quality: Float = 1.0,
        domain: String
    ) {
        self.id = id
        self.context = context
        self.response = response
        self.source = source
        self.quality = quality
        self.domain = domain
    }
}

/**
 * KASPER CONTENT IMPORTER
 *
 * Orchestrates the import and processing of existing spiritual content
 * from Claude Rich files and Grok structured JSON into KASPER-ready format.
 */
@MainActor
public final class KASPERContentImporter: ObservableObject {

    // MARK: - Singleton

    public static let shared = KASPERContentImporter()

    // MARK: - Published Properties

    @Published public private(set) var isImporting: Bool = false
    @Published public private(set) var importProgress: Float = 0.0
    @Published public private(set) var importedNumbers: Set<Int> = []
    @Published public private(set) var availableContent: [Int: NumberMeaningContent] = [:]
    @Published public private(set) var importErrors: [ImportError] = []

    // MARK: - Private Properties

    private let logger = Logger(subsystem: "com.VybeMVP.KASPERContentImporter", category: "import")

    /// Claude: File system paths
    private let importedContentURL: URL
    private let claudeRichURL: URL
    private let grokStructuredURL: URL

    /// Claude: Persona-specific URLs
    private let grokOracleURL: URL
    private let grokPsychologistURL: URL
    private let grokMindfulnessCoachURL: URL
    private let grokPhilosopherURL: URL
    private let grokNumerologyScholarURL: URL

    /// Claude: Content cache for performance
    private var contentCache: [Int: NumberMeaningContent] = [:]

    // MARK: - Initialization

    private init() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let projectURL = documentsURL.appendingPathComponent("../../../Documents/XcodeProjects/VybeMVP", isDirectory: true)

        // 🆕 V2.1: Use the Approved folder with all converted JSON content!
        let contentRefineryURL = projectURL.appendingPathComponent("KASPERMLX/MLXTraining/ContentRefinery")
        self.importedContentURL = contentRefineryURL.appendingPathComponent("Approved")
        self.claudeRichURL = importedContentURL  // All Claude JSON files are in Approved
        self.grokStructuredURL = importedContentURL  // All Grok JSON files are in Approved

        // Persona-specific paths
        self.grokOracleURL = grokStructuredURL.appendingPathComponent("Oracle")
        self.grokPsychologistURL = grokStructuredURL.appendingPathComponent("Psychologist")
        self.grokMindfulnessCoachURL = grokStructuredURL.appendingPathComponent("MindfulnessCoach")
        self.grokPhilosopherURL = grokStructuredURL.appendingPathComponent("Philosopher")
        self.grokNumerologyScholarURL = grokStructuredURL.appendingPathComponent("NumerologyScholar")

        logger.info("🎯 KASPERContentImporter initialized with multi-persona support")

        // Load any existing imported content
        loadExistingContent()
    }

    // MARK: - Public Import Interface

    /**
     * Import all available content from Claude Rich and Grok files
     */
    public func importAllContent() async throws {
        guard !isImporting else {
            throw ImportError.importAlreadyActive
        }

        logger.info("🎯 Starting complete content import...")

        isImporting = true
        importProgress = 0.0
        importErrors.removeAll()

        do {
            // Import Claude Rich content (CR1-CR44)
            try await importClaudeRichContent()

            // Import Grok structured content (when available)
            try await importGrokStructuredContent()

            // Generate combined content and training pairs
            try await generateCombinedContent()

            importProgress = 1.0
            logger.info("🎯 Content import completed successfully")

        } catch {
            logger.error("🎯 Content import failed: \(error.localizedDescription)")
            importErrors.append(ImportError.importFailed(error.localizedDescription))
            throw error
        }

        isImporting = false
    }

    /**
     * Import content for a specific number
     */
    public func importContent(for number: Int) async throws -> NumberMeaningContent {
        logger.info("🎯 Importing content for number \(number)")

        // Check cache first
        if let cachedContent = contentCache[number] {
            return cachedContent
        }

        // Import from files
        let claudeContent = try await loadClaudeRichContent(for: number)
        let grokPersonaContent = try await loadAllGrokPersonaContent(for: number)

        // Generate display content
        let displayContent = try await generateDisplayContent(
            number: number,
            claudeContent: claudeContent,
            grokPersonaContent: grokPersonaContent
        )

        // Generate training pairs
        let trainingPairs = try await generateTrainingPairs(
            number: number,
            claudeContent: claudeContent,
            grokPersonaContent: grokPersonaContent
        )

        // Create combined content
        let combinedSummary = generateCombinedSummary(
            claudeContent: claudeContent,
            grokPersonaContent: grokPersonaContent
        )

        var sources: [KASPERContentSource] = []
        if claudeContent != nil { sources.append(.claudeRich) }
        sources.append(contentsOf: grokPersonaContent.keys.map { $0.contentSource })

        let content = NumberMeaningContent(
            number: number,
            sources: sources,
            claudeContent: claudeContent,
            grokPersonaContent: grokPersonaContent,
            combinedSummary: combinedSummary,
            displayContent: displayContent,
            trainingPairs: trainingPairs
        )

        // Cache and store
        contentCache[number] = content
        availableContent[number] = content
        importedNumbers.insert(number)

        logger.info("🎯 Successfully imported content for number \(number)")
        return content
    }

    /**
     * Get content for NumberMeaningView display
     */
    public func getDisplayContent(for number: Int) async throws -> NumberDisplayContent {
        if let existingContent = availableContent[number] {
            return existingContent.displayContent
        }

        let content = try await importContent(for: number)
        return content.displayContent
    }

    /**
     * Get training pairs for KASPER MLX training
     */
    public func getTrainingPairs() -> [KASPERTrainingPair] {
        return availableContent.values.flatMap { $0.trainingPairs }
    }

    // MARK: - Unified Insight Decoder

    /// Claude: Unified structure for parsing all JSON formats
    private struct RawInsight: Codable {
        let category: String?
        let insight: String?
        let intensity: Double?
        let triggers: [String]?
        let supports: [String]?
        let challenges: [String]?
    }

    /// Claude: Single parser to handle all JSON formats - behavioral_insights, spiritual_categories, legacy insights
    private func decodeBehavioralInsights(from data: Data, sourceTag: String) -> [RawInsight] {
        // Try fast path via JSONSerialization to verify keys + log shape
        guard let obj = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
            logger.error("🚑 KASPER V2.1: ❌ JSON not a top-level object (\(sourceTag))")
            return []
        }

        // 💡 Canonical path: behavioral_insights (post-conversion format)
        if let arr = obj["behavioral_insights"] as? [[String: Any]] {
            let items: [RawInsight] = arr.compactMap { dict in
                RawInsight(
                    category: dict["category"] as? String,
                    insight: dict["insight"] as? String,
                    intensity: (dict["intensity"] as? NSNumber)?.doubleValue,
                    triggers: dict["triggers"] as? [String],
                    supports: dict["supports"] as? [String],
                    challenges: dict["challenges"] as? [String]
                )
            }
            logger.info("🚀 KASPER V2.1: ✅ behavioral_insights count=\(items.count) [\(sourceTag)]")
            return items
        }

        // 🔥 Legacy Grok fallback (kept for safety; should rarely run now)
        if let sc = obj["spiritual_categories"] as? [String: Any] {
            let prim = (sc["primary_insights"] as? [String]) ?? []
            let items = prim
                .filter { $0.count > 20 && !$0.lowercased().contains("batch_size") }
                .map { RawInsight(category: "spiritual_guidance", insight: $0, intensity: 0.7, triggers: nil, supports: nil, challenges: nil) }
            logger.warning("🚑 KASPER V2.1: ⚠️ legacy spiritual_categories used; count=\(items.count) [\(sourceTag)]")
            return items
        }

        // 🚑 Old "insights" shape (final belt & suspenders)
        if let arr = obj["insights"] as? [[String: Any]] {
            let items: [RawInsight] = arr.compactMap { d in
                let text = (d["insight"] as? String) ?? (d["content"] as? String)
                return RawInsight(
                    category: d["category"] as? String ?? "personal_growth",
                    insight: text,
                    intensity: (d["intensity"] as? NSNumber)?.doubleValue,
                    triggers: d["triggers"] as? [String],
                    supports: d["supports"] as? [String],
                    challenges: d["challenges"] as? [String]
                )
            }
            logger.warning("🚑 KASPER V2.1: ⚠️ legacy insights[] used; count=\(items.count) [\(sourceTag)]")
            return items
        }

        // 🔍 Debug: show top-level keys so we can see why it failed
        logger.error("🚑 KASPER V2.1: ❌ No behavioral_insights/legacy keys found. keys=\(Array(obj.keys)) [\(sourceTag)]")
        return []
    }

    /// Claude: Safe insight text extractor with bounds checking
    private func insightText(_ insights: [RawInsight], _ index: Int) -> String {
        guard insights.indices.contains(index), let text = insights[index].insight else { return "" }
        return text
    }

// MARK: - Private Implementation

    /**
     * Import all Claude Rich files (CR1-CR44)
     */
    private func importClaudeRichContent() async throws {
        logger.info("🎯 Importing Claude Rich content...")

        let claudeFiles = try FileManager.default.contentsOfDirectory(at: claudeRichURL, includingPropertiesForKeys: nil)
        let crFiles = claudeFiles.filter { $0.lastPathComponent.hasPrefix("CR") && $0.pathExtension == "md" }

        for (index, file) in crFiles.enumerated() {
            // Extract number from filename (CR1.md, CR2.md, etc.)
            let filename = file.lastPathComponent
            let numberString = filename.replacingOccurrences(of: "CR", with: "").replacingOccurrences(of: ".md", with: "")

            if let number = Int(numberString) {
                _ = try await importContent(for: number)
                importProgress = Float(index + 1) / Float(crFiles.count) * 0.5 // First 50% for Claude
            }
        }

        logger.info("🎯 Claude Rich content imported: \(crFiles.count) files")
    }

    /**
     * Import all Grok persona-structured JSON files
     */
    private func importGrokStructuredContent() async throws {
        logger.info("🎯 Importing Grok multi-persona structured content...")

        guard FileManager.default.fileExists(atPath: grokStructuredURL.path) else {
            logger.info("🎯 Grok structured content directory not found - skipping")
            return
        }

        var totalFiles = 0
        var processedFiles = 0

        // Count total files across all personas
        for persona in GrokPersona.allCases {
            let personaURL = grokStructuredURL.appendingPathComponent(persona.folderName)
            if FileManager.default.fileExists(atPath: personaURL.path) {
                let files = try FileManager.default.contentsOfDirectory(at: personaURL, includingPropertiesForKeys: nil)
                totalFiles += files.filter { $0.pathExtension == "json" || $0.pathExtension == "md" }.count
            }
        }

        // Process each persona's content
        for persona in GrokPersona.allCases {
            let personaURL = grokStructuredURL.appendingPathComponent(persona.folderName)

            guard FileManager.default.fileExists(atPath: personaURL.path) else {
                logger.info("🎯 \(persona.rawValue) directory not found - skipping")
                continue
            }

            let personaFiles = try FileManager.default.contentsOfDirectory(at: personaURL, includingPropertiesForKeys: nil)
            let contentFiles = personaFiles.filter { $0.pathExtension == "json" || $0.pathExtension == "md" }

            for _ in contentFiles {
                // Process individual persona content files (JSON or MD)
                processedFiles += 1
                importProgress = 0.5 + (Float(processedFiles) / Float(totalFiles) * 0.5) // Second 50% for Grok
            }

            logger.info("🎯 \(persona.rawValue) content imported: \(contentFiles.count) files")
        }

        logger.info("🎯 Total Grok structured content imported: \(processedFiles) files across \(GrokPersona.allCases.count) personas")
    }

    /**
     * Load Claude Rich content for a specific number
     */
    private func loadClaudeRichContent(for number: Int) async throws -> ClaudeRichContent? {
        // 🆕 V2.1: Load from converted JSON files in Approved folder
        let paddedNumber = String(format: "%02d", number)
        let jsonFile = claudeRichURL.appendingPathComponent("claude_\(paddedNumber)_academic_converted.json")

        guard FileManager.default.fileExists(atPath: jsonFile.path) else {
            // Try without padding
            let jsonFileNoPad = claudeRichURL.appendingPathComponent("claude_\(number)_academic_converted.json")
            guard FileManager.default.fileExists(atPath: jsonFileNoPad.path) else {
                return nil
            }
            let data = try Data(contentsOf: jsonFileNoPad)
            return try await parseClaudeJSON(data)
        }

        let data = try Data(contentsOf: jsonFile)
        return try await parseClaudeJSON(data)
    }

    /**
     * Parse Claude JSON content using unified decoder
     */
    private func parseClaudeJSON(_ data: Data) async throws -> ClaudeRichContent {
        // 🚀 Use unified decoder for all Claude content
        let insights = decodeBehavioralInsights(from: data, sourceTag: "Claude")

        // Use different insights for different sections with safe bounds checking
        return ClaudeRichContent(
            coreEssence: insightText(insights, 0),
            mysticalSignificance: insightText(insights, 1),
            archetypes: insightText(insights, 2),
            lifePathPersonality: insightText(insights, 3),
            spiritualLessons: insightText(insights, 4),
            shadowAspects: insightText(insights, 5),
            manifestationPower: insightText(insights, 6),
            relationshipDynamics: insightText(insights, 7),
            careerGuidance: insightText(insights, 8),
            healingJourney: insightText(insights, 9),
            cosmicConnection: insightText(insights, 10),
            practicalApplication: insightText(insights, 11)
        )
    }

    /**
     * Parse Claude Rich markdown into structured content
     */
    private func parseClaudeRichMarkdown(_ markdown: String) async throws -> ClaudeRichContent {
        // This will parse the markdown sections into structured content
        // For now, we'll create a basic structure

        return ClaudeRichContent(
            coreEssence: extractSection(from: markdown, header: "# Core Essence") ?? "",
            mysticalSignificance: extractSection(from: markdown, header: "# Mystical Significance") ?? "",
            archetypes: extractSection(from: markdown, header: "# Archetypes") ?? "",
            lifePathPersonality: extractSection(from: markdown, header: "# Life Path Personality") ?? "",
            spiritualLessons: extractSection(from: markdown, header: "# Spiritual Lessons") ?? "",
            shadowAspects: extractSection(from: markdown, header: "# Shadow Aspects") ?? "",
            manifestationPower: extractSection(from: markdown, header: "# Manifestation Power") ?? "",
            relationshipDynamics: extractSection(from: markdown, header: "# Relationship Dynamics") ?? "",
            careerGuidance: extractSection(from: markdown, header: "# Career Guidance") ?? "",
            healingJourney: extractSection(from: markdown, header: "# Healing Journey") ?? "",
            cosmicConnection: extractSection(from: markdown, header: "# Cosmic Connection") ?? "",
            practicalApplication: extractSection(from: markdown, header: "# Practical Application") ?? ""
        )
    }

    /**
     * Extract section content from markdown
     */
    private func extractSection(from markdown: String, header: String) -> String? {
        let lines = markdown.components(separatedBy: .newlines)
        var inSection = false
        var sectionContent: [String] = []

        for line in lines {
            if line.starts(with: header) {
                inSection = true
                continue
            } else if inSection && line.starts(with: "# ") && line != header {
                break
            } else if inSection {
                sectionContent.append(line)
            }
        }

        return sectionContent.isEmpty ? nil : sectionContent.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /**
     * Load all Grok persona content for a specific number
     */
    private func loadAllGrokPersonaContent(for number: Int) async throws -> [GrokPersona: GrokStructuredContent] {
        var personaContent: [GrokPersona: GrokStructuredContent] = [:]

        for persona in GrokPersona.allCases {
            if let content = try await loadGrokPersonaContent(for: number, persona: persona) {
                personaContent[persona] = content
            }
        }

        return personaContent
    }

    /**
     * Load Grok content for a specific persona and number
     */
    private func loadGrokPersonaContent(for number: Int, persona: GrokPersona) async throws -> GrokStructuredContent? {
        // 🆕 V2.1: Load from converted JSON files in Approved folder
        let paddedNumber = String(format: "%02d", number)
        let personaPrefix = "grok_\(persona.rawValue.lowercased())"
        let jsonFile = grokStructuredURL.appendingPathComponent("\(personaPrefix)_\(paddedNumber)_converted.json")

        if FileManager.default.fileExists(atPath: jsonFile.path) {
            let data = try Data(contentsOf: jsonFile)
            return try await parseGrokJSON(data)
        }

        // Try without padding
        let jsonFileNoPad = grokStructuredURL.appendingPathComponent("\(personaPrefix)_\(number)_converted.json")
        if FileManager.default.fileExists(atPath: jsonFileNoPad.path) {
            let data = try Data(contentsOf: jsonFileNoPad)
            return try await parseGrokJSON(data)
        }

        return nil
    }

    /**
     * Parse Grok JSON content using unified decoder
     */
    private func parseGrokJSON(_ data: Data) async throws -> GrokStructuredContent {
        // 🚀 Use unified decoder for all Grok content
        let rawInsights = decodeBehavioralInsights(from: data, sourceTag: "Grok")

        // Sort insights into appropriate categories based on KASPER category names
        var allInsights: [String] = []
        var reflections: [String] = []
        var contemplations: [String] = []
        var manifestations: [String] = []
        var challenges: [String] = []
        var gifts: [String] = []
        var relationships: [String] = []
        var career: [String] = []
        var health: [String] = []
        var creativity: [String] = []
        var spirituality: [String] = []
        var wisdom: [String] = []

        for rawInsight in rawInsights {
            guard let content = rawInsight.insight, !content.isEmpty,
                  let category = rawInsight.category else { continue }

            switch category.lowercased() {
            case "spiritual_guidance", "insight", "guidance":
                allInsights.append(content)
            case "inner_wisdom", "reflection":
                reflections.append(content)
            case "contemplation", "meditation":
                contemplations.append(content)
            case "manifestation", "affirmation":
                manifestations.append(content)
            case "challenges", "challenge", "growth":
                challenges.append(content)
            case "gifts", "gift", "talent":
                gifts.append(content)
            case "relationships", "relationship", "connection":
                relationships.append(content)
            case "career_path", "career", "purpose":
                career.append(content)
            case "healing", "health", "wellness":
                health.append(content)
            case "creativity", "creative", "expression":
                creativity.append(content)
            case "spirituality", "spiritual":
                spirituality.append(content)
            case "wisdom", "knowledge":
                wisdom.append(content)
            case "personal_growth":
                allInsights.append(content) // Map personal_growth to insights
            case "life_purpose":
                allInsights.append(content) // Map life_purpose to insights
            case "service":
                spirituality.append(content) // Map service to spirituality
            default:
                allInsights.append(content) // Default to insights
            }
        }

        return GrokStructuredContent(
            insights: allInsights,
            reflections: reflections,
            contemplations: contemplations,
            manifestations: manifestations,
            challenges: challenges,
            gifts: gifts,
            relationships: relationships,
            career: career,
            health: health,
            creativity: creativity,
            spirituality: spirituality,
            wisdom: wisdom
        )
    }

    /**
     * Parse Grok persona markdown into structured content
     */
    private func parseGrokMarkdown(_ markdown: String, persona: GrokPersona) async throws -> GrokStructuredContent {
        // Parse the 12-category structure from Grok markdown
        // This will extract insights, reflections, contemplations, etc. based on your format

        let insights = extractGrokSection(from: markdown, category: "insight") ?? []
        let reflections = extractGrokSection(from: markdown, category: "reflection") ?? []
        let contemplations = extractGrokSection(from: markdown, category: "contemplation") ?? []
        let manifestations = extractGrokSection(from: markdown, category: "manifestation") ?? []
        let challenges = extractGrokSection(from: markdown, category: "challenge") ?? []
        let gifts = extractGrokSection(from: markdown, category: "gift") ?? []
        let relationships = extractGrokSection(from: markdown, category: "relationship") ?? []
        let career = extractGrokSection(from: markdown, category: "career") ?? []
        let health = extractGrokSection(from: markdown, category: "health") ?? []
        let creativity = extractGrokSection(from: markdown, category: "creativity") ?? []
        let spirituality = extractGrokSection(from: markdown, category: "spirituality") ?? []
        let wisdom = extractGrokSection(from: markdown, category: "wisdom") ?? []

        return GrokStructuredContent(
            insights: insights,
            reflections: reflections,
            contemplations: contemplations,
            manifestations: manifestations,
            challenges: challenges,
            gifts: gifts,
            relationships: relationships,
            career: career,
            health: health,
            creativity: creativity,
            spirituality: spirituality,
            wisdom: wisdom
        )
    }

    /**
     * Extract specific category content from Grok markdown
     */
    private func extractGrokSection(from markdown: String, category: String) -> [String]? {
        let lines = markdown.components(separatedBy: .newlines)
        var inSection = false
        var sectionContent: [String] = []

        // Look for category headers (flexible matching)
        let categoryHeaders = [
            "# \(category.capitalized)",
            "## \(category.capitalized)",
            "### \(category.capitalized)",
            "# \(category)s", // plural form
            "## \(category)s",
            "### \(category)s"
        ]

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

            // Check if we're entering our target section
            if categoryHeaders.contains(where: { trimmedLine.lowercased().contains($0.lowercased()) }) {
                inSection = true
                continue
            }
            // Check if we're entering a different section (exit our section)
            else if inSection && (trimmedLine.hasPrefix("#") || trimmedLine.hasPrefix("##") || trimmedLine.hasPrefix("###")) {
                break
            }
            // Collect content within our section
            else if inSection && !trimmedLine.isEmpty {
                // Handle both bullet points and numbered lists
                if trimmedLine.hasPrefix("- ") || trimmedLine.hasPrefix("* ") {
                    sectionContent.append(String(trimmedLine.dropFirst(2)).trimmingCharacters(in: .whitespacesAndNewlines))
                } else if trimmedLine.range(of: #"^\d+\.\s"#, options: .regularExpression) != nil {
                    // Remove number prefix (1. 2. etc.)
                    let content = trimmedLine.replacingOccurrences(of: #"^\d+\.\s"#, with: "", options: .regularExpression)
                    sectionContent.append(content.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    // Regular paragraph content
                    sectionContent.append(trimmedLine)
                }
            }
        }

        return sectionContent.isEmpty ? nil : sectionContent
    }

    /// Claude: Centralized rich content availability check with detailed logging
    private func validateRichContentAvailability(
        number: Int,
        claudeContent: ClaudeRichContent?,
        grokPersonaContent: [GrokPersona: GrokStructuredContent]
    ) -> Int {
        var totalInsights = 0

        // Count Claude insights
        var claudeInsights = 0
        if let claude = claudeContent {
            let sections = [claude.coreEssence, claude.mysticalSignificance, claude.archetypes,
                           claude.lifePathPersonality, claude.spiritualLessons, claude.shadowAspects,
                           claude.manifestationPower, claude.relationshipDynamics, claude.careerGuidance,
                           claude.healingJourney, claude.cosmicConnection, claude.practicalApplication]
            claudeInsights = sections.filter { !$0.isEmpty }.count
            totalInsights += claudeInsights
        }

        // Count Grok persona insights
        var grokTotals: [String: Int] = [:]
        for (persona, content) in grokPersonaContent {
            let count = content.totalContentCount
            grokTotals[persona.rawValue] = count
            totalInsights += count
        }

        // 🚀 Log detailed availability for debugging
        if totalInsights == 0 {
            logger.error("🚨 KASPER V2.1: ❌ NO rich content available - falling back to templates [Number \(number)]")
            logger.info("   Claude insights: \(claudeInsights)")
            logger.info("   Grok totals: \(grokTotals)")
        } else {
            logger.info("🚀 KASPER V2.1: ✅ Using RICH content - insights available: \(totalInsights) [Number \(number)]")
            logger.info("   Claude insights: \(claudeInsights)")
            for (persona, count) in grokTotals {
                logger.info("   \(persona): \(count) insights")
            }
        }

        return totalInsights
    }

    /**
     * Generate display content for NumberMeaningView
     */
    private func generateDisplayContent(
        number: Int,
        claudeContent: ClaudeRichContent?,
        grokPersonaContent: [GrokPersona: GrokStructuredContent]
    ) async throws -> NumberDisplayContent {

        // 🔍 Validate and log rich content availability
        let totalInsights = validateRichContentAvailability(
            number: number,
            claudeContent: claudeContent,
            grokPersonaContent: grokPersonaContent
        )

        // Generate from available content
        let title = getTitleForNumber(number)
        let essence = claudeContent?.coreEssence.prefix(200).appending("...") ?? "Spiritual essence of number \(number)"

        // Combine insights from all personas
        var allInsights: [String] = []
        for content in grokPersonaContent.values {
            allInsights.append(contentsOf: content.insights)
        }

        var keyInsights = Array(allInsights.prefix(5))
        if keyInsights.isEmpty {
            // Fallback insights
            keyInsights = [
                "Spiritual guidance for number \(number)",
                "Growth opportunities await",
                "Trust your inner wisdom",
                "Cosmic alignment supports you",
                "Embrace your authentic path"
            ]
        }

        // Get content from different personas for variety
        let oracleContent = grokPersonaContent[.oracle]
        let mindfulnessContent = grokPersonaContent[.mindfulnessCoach]
        let psychologistContent = grokPersonaContent[.psychologist]
        let philosopherContent = grokPersonaContent[.philosopher]

        return NumberDisplayContent(
            title: title,
            essence: String(essence),
            keyInsights: keyInsights,
            dailyGuidance: oracleContent?.insights.prefix(3).map { String($0) } ?? ["Daily practice brings clarity"],
            meditation: mindfulnessContent?.contemplations.first ?? claudeContent?.spiritualLessons ?? "Focus on your breath and inner wisdom",
            affirmation: oracleContent?.manifestations.first ?? "I am aligned with my highest purpose",
            challenge: psychologistContent?.challenges.first ?? "Growth comes through mindful awareness",
            gift: philosopherContent?.gifts.first ?? "Your authentic self is your greatest gift"
        )
    }

    /**
     * Generate training pairs for MLX learning
     */
    private func generateTrainingPairs(
        number: Int,
        claudeContent: ClaudeRichContent?,
        grokPersonaContent: [GrokPersona: GrokStructuredContent]
    ) async throws -> [KASPERTrainingPair] {

        var pairs: [KASPERTrainingPair] = []

        // Generate pairs from each Grok persona
        for (persona, content) in grokPersonaContent {
            let source = persona.contentSource
            let voice = source.spiritualVoice

            // Add insights with persona context
            for insight in content.insights.prefix(5) {
                pairs.append(KASPERTrainingPair(
                    context: "As a \(voice), what spiritual guidance can you share about number \(number)?",
                    response: insight,
                    source: source,
                    domain: "insight"
                ))
            }

            // Add reflections
            for reflection in content.reflections.prefix(3) {
                pairs.append(KASPERTrainingPair(
                    context: "What reflective questions about number \(number) can help someone grow?",
                    response: reflection,
                    source: source,
                    domain: "reflection"
                ))
            }

            // Add contemplations
            for contemplation in content.contemplations.prefix(2) {
                pairs.append(KASPERTrainingPair(
                    context: "Share a contemplative insight about number \(number)",
                    response: contemplation,
                    source: source,
                    domain: "contemplation"
                ))
            }

            // Add manifestations/affirmations
            for manifestation in content.manifestations.prefix(2) {
                pairs.append(KASPERTrainingPair(
                    context: "What affirmation can help someone embody the energy of number \(number)?",
                    response: manifestation,
                    source: source,
                    domain: "manifestation"
                ))
            }
        }

        // Generate pairs from Claude content with academic voice
        if let claudeContent = claudeContent {
            pairs.append(KASPERTrainingPair(
                context: "What is the core essence of number \(number) from an academic perspective?",
                response: claudeContent.coreEssence,
                source: .claudeRich,
                domain: "essence"
            ))

            pairs.append(KASPERTrainingPair(
                context: "What are the mystical aspects of number \(number)?",
                response: claudeContent.mysticalSignificance,
                source: .claudeRich,
                domain: "mystical"
            ))

            pairs.append(KASPERTrainingPair(
                context: "How does number \(number) influence relationships?",
                response: claudeContent.relationshipDynamics,
                source: .claudeRich,
                domain: "relationships"
            ))
        }

        return pairs
    }

    /**
     * Generate combined summary
     */
    private func generateCombinedSummary(
        claudeContent: ClaudeRichContent?,
        grokPersonaContent: [GrokPersona: GrokStructuredContent]
    ) -> String {
        var summary = ""

        if let claudeContent = claudeContent {
            summary += "🎓 Academic Analysis: \(claudeContent.coreEssence.prefix(100))...\n\n"
        }

        if !grokPersonaContent.isEmpty {
            summary += "🎭 Multi-Persona Insights:\n"

            var totalContent = 0
            for (persona, content) in grokPersonaContent {
                let count = content.totalContentCount
                totalContent += count
                summary += "• \(persona.contentSource.spiritualVoice): \(count) insights\n"
            }

            summary += "\n📊 Total: \(totalContent) structured spiritual guidance messages across \(grokPersonaContent.count) personas"
        }

        return summary
    }

    /**
     * Get title for number
     */
    private func getTitleForNumber(_ number: Int) -> String {
        switch number {
        case 1: return "The Leader"
        case 2: return "The Diplomat"
        case 3: return "The Communicator"
        case 4: return "The Builder"
        case 5: return "The Freedom Seeker"
        case 6: return "The Nurturer"
        case 7: return "The Seeker"
        case 8: return "The Achiever"
        case 9: return "The Humanitarian"
        case 11: return "The Intuitive"
        case 22: return "The Master Builder"
        case 33: return "The Master Teacher"
        case 44: return "The Master Healer"
        default: return "The Guide"
        }
    }

    /**
     * Load any existing imported content
     */
    private func loadExistingContent() {
        // Implementation for loading previously imported content
        logger.info("🎯 Loading existing imported content...")
    }

    /**
     * Generate combined content from all sources
     */
    private func generateCombinedContent() async throws {
        logger.info("🎯 Generating combined content and training pairs...")
        // Implementation for final processing and combination
    }
}

// MARK: - Supporting Types

/// Claude: Import errors
public enum ImportError: LocalizedError, Identifiable {
    case importAlreadyActive
    case fileNotFound(String)
    case parseError(String)
    case importFailed(String)

    public var id: String {
        switch self {
        case .importAlreadyActive: return "import_active"
        case .fileNotFound(let file): return "file_not_found_\(file)"
        case .parseError(let error): return "parse_error_\(error)"
        case .importFailed(let error): return "import_failed_\(error)"
        }
    }

    public var errorDescription: String? {
        switch self {
        case .importAlreadyActive:
            return "Content import is already in progress."
        case .fileNotFound(let file):
            return "File not found: \(file)"
        case .parseError(let error):
            return "Failed to parse content: \(error)"
        case .importFailed(let error):
            return "Import failed: \(error)"
        }
    }
}
