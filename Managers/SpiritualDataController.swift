import Foundation
import SwiftData

/**
 * SpiritualDataController
 * 
 * Manages the SwiftData stack for spiritual content (replacing MegaCorpus JSON)
 * Handles:
 * - Model container setup
 * - Initial data migration from JSON
 * - Query operations for spiritual insights
 * - Cache management
 */
@MainActor
final class SpiritualDataController: ObservableObject {
    
    // MARK: - Properties
    
    /// The SwiftData model container
    let container: ModelContainer
    
    /// Main context for data operations
    var context: ModelContext {
        container.mainContext
    }
    
    /// Migration status
    @Published var isMigrationComplete: Bool = false
    @Published var migrationProgress: Double = 0.0
    @Published var migrationStatus: String = ""
    
    // In-memory cache for hot paths
    private var archetypeCache: [Int: String] = [:]
    
    // MARK: - Singleton
    
    static let shared = SpiritualDataController()
    
    // MARK: - Initialization
    
    private init() {
        // Configure the model schema with all SwiftData models
        let schema = Schema([
            // Numerology and basic spiritual data
            NumberMeaning.self,
            ZodiacMeaning.self,
            PersonalizedInsightTemplate.self,
            
            // Astrological models
            AstrologicalAspect.self,
            AstrologicalElement.self,
            AstrologicalHouse.self,
            AstrologicalMode.self,
            AstrologicalPlanet.self,
            
            // Planetary and lunar data
            ApparentMotion.self,
            MoonPhase.self
        ])
        
        // Configure model container
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            // Check if migration is needed
            Task {
                await checkAndPerformMigration()
            }
            
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    // MARK: - Migration
    
    /// Checks if data migration from JSON is needed and performs it
    private func checkAndPerformMigration() async {
        // Check if we already have data
        let descriptor = FetchDescriptor<NumberMeaning>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        
        if existingCount > 0 {
            // Data already migrated
            isMigrationComplete = true
            await loadHotCache()
            return
        }
        
        // Perform migration
        await performJSONMigration()
    }
    
    /// Migrates MegaCorpus JSON data to SwiftData
    private func performJSONMigration() async {
        migrationStatus = "Starting migration..."
        
        do {
            // Migrate number meanings
            migrationStatus = "Migrating number meanings..."
            try await migrateNumberMeanings()
            migrationProgress = 0.5
            
            // Migrate zodiac meanings
            migrationStatus = "Migrating zodiac signs..."
            try await migrateZodiacMeanings()
            migrationProgress = 1.0
            
            // Save context
            try context.save()
            
            // Load hot cache
            await loadHotCache()
            
            migrationStatus = "Migration complete!"
            isMigrationComplete = true
            
            print("✅ SwiftData migration complete")
            
        } catch {
            migrationStatus = "Migration failed: \(error.localizedDescription)"
            print("❌ SwiftData migration failed: \(error)")
        }
    }
    
    /// Migrates number meanings from JSON using your actual MegaCorpus structure
    private func migrateNumberMeanings() async throws {
        // Get the numerology data from MegaCorpus
        let sanctumManager = SanctumDataManager.shared
        guard let numerologyData = sanctumManager.getRawData(for: "numerology"),
              let focusNumbers = numerologyData["focusNumbers"] as? [String: Any] else {
            print("⚠️ Could not load numerology data from MegaCorpus")
            return
        }
        
        // Migrate numbers 1-9 from your actual JSON structure
        for number in 1...9 {
            if let numberData = focusNumbers[String(number)] as? [String: Any] {
                let meaning = NumberMeaning(
                    number: number,
                    archetype: numberData["archetype"] as? String ?? "The Seeker",
                    title: "Number \(number)", // You can add title field to JSON if needed
                    element: numberData["element"] as? String ?? "Universal",
                    keywords: numberData["keywords"] as? [String] ?? [],
                    strengths: numberData["strengths"] as? [String] ?? [],
                    legacyChallenges: numberData["challenges"] as? [String] ?? [],
                    spiritualDescription: numberData["description"] as? String ?? "A path of spiritual growth.",
                    planetaryCorrespondence: numberData["planetaryCorrespondence"] as? String,
                    signCorrespondence: numberData["signCorrespondence"] as? String,
                    color: numberData["color"] as? String
                )
                
                context.insert(meaning)
                print("✅ Migrated Number \(number): \(meaning.archetype)")
            }
        }
        
        // TODO: Add master numbers (11, 22, 33, 44) when you add them to JSON
    }
    
    /// Migrates zodiac meanings from your actual Signs.json structure
    private func migrateZodiacMeanings() async throws {
        // Get the signs data from MegaCorpus
        let sanctumManager = SanctumDataManager.shared
        guard let signsData = sanctumManager.getRawData(for: "signs"),
              let signs = signsData["signs"] as? [String: Any] else {
            print("⚠️ Could not load signs data from MegaCorpus")
            return
        }
        
        // Migrate all zodiac signs from your JSON
        for (signKey, signValue) in signs {
            if let signData = signValue as? [String: Any] {
                // Extract numerology nested object
                let numerologyData = signData["numerology"] as? [String: Any]
                
                let zodiacMeaning = ZodiacMeaning(
                    name: signData["name"] as? String ?? signKey.capitalized,
                    glyph: signData["glyph"] as? String ?? "♈︎",
                    dateRange: signData["dateRange"] as? String ?? "",
                    symbol: signData["symbol"] as? String ?? "",
                    ruler: signData["ruler"] as? String ?? "",
                    house: signData["house"] as? String ?? "",
                    element: signData["element"] as? String ?? "",
                    mode: signData["mode"] as? String ?? "",
                    keyword: signData["keyword"] as? String ?? "",
                    signDescription: signData["description"] as? String ?? "",
                    signOrderNumber: numerologyData?["signOrderNumber"] as? Int ?? 1,
                    rulerVibration: numerologyData?["rulerVibration"] as? Int ?? 1,
                    elementNumber: numerologyData?["elementNumber"] as? Int ?? 1,
                    modeNumber: numerologyData?["modeNumber"] as? Int ?? 1,
                    resonantNumbers: numerologyData?["resonantNumbers"] as? [Int] ?? [],
                    keyTraits: signData["keyTraits"] as? [String] ?? [],
                    spiritualGuidance: signData["spiritualGuidance"] as? String,
                    challenges: signData["challenges"] as? [String] ?? [],
                    strengths: signData["strengths"] as? [String] ?? []
                )
                
                context.insert(zodiacMeaning)
                print("✅ Migrated Zodiac Sign: \(zodiacMeaning.name)")
            }
        }
    }
    
    // MARK: - Hot Cache
    
    /// Loads frequently accessed data into memory cache
    private func loadHotCache() async {
        let descriptor = FetchDescriptor<NumberMeaning>()
        if let meanings = try? context.fetch(descriptor) {
            for meaning in meanings {
                archetypeCache[meaning.number] = meaning.archetype
            }
        }
    }
    
    // MARK: - Query Methods
    
    /// Gets a number meaning from the database
    func getNumberMeaning(_ number: Int) async throws -> NumberMeaning? {
        let descriptor = FetchDescriptor<NumberMeaning>(
            predicate: #Predicate { $0.number == number }
        )
        return try context.fetch(descriptor).first
    }
    
    /// Gets archetype for a number (uses hot cache)
    func getArchetype(for number: Int) -> String {
        if let cached = archetypeCache[number] {
            return cached
        }
        
        // Fallback to database query
        Task {
            if let meaning = try? await getNumberMeaning(number) {
                archetypeCache[number] = meaning.archetype
            }
        }
        
        return "The Seeker" // Default fallback
    }
    
    /// Searches for number meanings by keyword
    func searchNumberMeanings(keyword: String) async throws -> [NumberMeaning] {
        let descriptor = FetchDescriptor<NumberMeaning>(
            predicate: #Predicate { meaning in
                meaning.keywords.contains(keyword) ||
                meaning.spiritualDescription.contains(keyword)
            }
        )
        return try context.fetch(descriptor)
    }
    
    /// Gets a zodiac sign meaning by name
    func getZodiacMeaning(_ signName: String) async throws -> ZodiacMeaning? {
        // SwiftData predicates don't support lowercased(), so fetch all and filter
        let descriptor = FetchDescriptor<ZodiacMeaning>()
        let allSigns = try context.fetch(descriptor)
        return allSigns.first { $0.name.lowercased() == signName.lowercased() }
    }
    
    /// Gets all zodiac signs
    func getAllZodiacSigns() async throws -> [ZodiacMeaning] {
        let descriptor = FetchDescriptor<ZodiacMeaning>(
            sortBy: [SortDescriptor(\.signOrderNumber)]
        )
        return try context.fetch(descriptor)
    }
    
    // MARK: - Helper Methods for Number Migration
    
    private func getArchetypeForNumber(_ number: Int) -> String {
        switch number {
        case 0: return "Void"
        case 1: return "Pioneer"
        case 2: return "Peacemaker"
        case 3: return "Creator"
        case 4: return "Builder"
        case 5: return "Explorer"
        case 6: return "Nurturer"
        case 7: return "Mystic"
        case 8: return "Achiever"
        case 9: return "Humanitarian"
        default: return "Seeker"
        }
    }
    
    private func getElementForNumber(_ number: Int) -> String {
        switch number {
        case 1, 5, 9: return "Fire"
        case 2, 6: return "Water"
        case 3, 7: return "Air"
        case 4, 8: return "Earth"
        default: return "Universal"
        }
    }
    
    private func getKeywordsForNumber(_ number: Int) -> [String] {
        switch number {
        case 0: return ["Potential", "Void", "Infinite"]
        case 1: return ["Leadership", "Independence", "Initiative"]
        case 2: return ["Cooperation", "Balance", "Harmony"]
        case 3: return ["Creativity", "Expression", "Joy"]
        case 4: return ["Stability", "Hard work", "Foundation"]
        case 5: return ["Freedom", "Adventure", "Change"]
        case 6: return ["Nurturing", "Responsibility", "Healing"]
        case 7: return ["Spirituality", "Analysis", "Wisdom"]
        case 8: return ["Material success", "Authority", "Power"]
        case 9: return ["Universal love", "Completion", "Service"]
        default: return ["Growth", "Learning"]
        }
    }
    
    private func getStrengthsForNumber(_ number: Int) -> [String] {
        switch number {
        case 1: return ["Natural leader", "Independent", "Pioneering spirit"]
        case 2: return ["Diplomatic", "Cooperative", "Intuitive"]
        case 3: return ["Creative", "Optimistic", "Communicative"]
        default: return ["Resilient", "Adaptable"]
        }
    }
    
    private func getLegacyChallengesForNumber(_ number: Int) -> [String] {
        switch number {
        case 1: return ["Impatience", "Self-centeredness"]
        case 2: return ["Over-sensitivity", "Indecision"]
        case 3: return ["Scattered energy", "Superficiality"]
        default: return ["Self-doubt", "Resistance to change"]
        }
    }
    
    private func getPlanetaryCorrespondence(_ number: Int) -> String? {
        switch number {
        case 1: return "Sun"
        case 2: return "Moon"
        case 3: return "Jupiter"
        case 4: return "Uranus"
        case 5: return "Mercury"
        case 6: return "Venus"
        case 7: return "Neptune"
        case 8: return "Saturn"
        case 9: return "Mars"
        default: return nil
        }
    }
    
    private func getSignCorrespondence(_ number: Int) -> String? {
        switch number {
        case 1: return "Aries"
        case 2: return "Cancer"
        case 3: return "Sagittarius"
        case 4: return "Aquarius"
        case 5: return "Gemini"
        case 6: return "Taurus"
        case 7: return "Pisces"
        case 8: return "Capricorn"
        case 9: return "Leo"
        default: return nil
        }
    }
    
    private func getColorForNumber(_ number: Int) -> String? {
        switch number {
        case 1: return "Red"
        case 2: return "Orange"
        case 3: return "Yellow"
        case 4: return "Green"
        case 5: return "Blue"
        case 6: return "Indigo"
        case 7: return "Violet"
        case 8: return "Pink"
        case 9: return "Gold"
        default: return nil
        }
    }
}

// MARK: - Data Transfer Objects

/// Temporary struct for decoding personalized template JSON
private struct PersonalizedTemplateData: Codable {
    let id: String
    let lifePath: Int
    let spiritualMode: String
    let tone: String
    let themes: [String]
    let text: String
}