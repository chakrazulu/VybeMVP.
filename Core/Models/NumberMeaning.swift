import Foundation

/// Represents the meaning and symbolism of a number in transcendental theory
struct NumberMeaning {
    /// The number being described (0-9)
    let number: Int
    
    /// The primary title/concept of the number (e.g., "The Void / The All" for 0)
    let title: String
    
    /// The core essence of the number's meaning
    let essence: String
    
    /// The symbolic representation and meaning
    let symbolism: String
    
    /// How the number is applied in transcendental theory
    let application: String
    
    /// Additional notes or interpretations
    var notes: [String] = []
}

/// Manages the documentation of transcendental number meanings
class NumberMeaningManager {
    static let shared = NumberMeaningManager()
    
    private var meanings: [NumberMeaning] = []
    
    private init() {
        setupInitialMeanings()
    }
    
    func setupInitialMeanings() {
        // 0 - The Void / The All
        addOrUpdateMeaning(NumberMeaning(
            number: 0,
            title: "The Void / The All",
            essence: "Zero represents the infinite potential before manifestation. It is the raw, boundless energy of creation—the unformed, formless source of all things, embodying the concept of the \"All\" as an eternal void from which all possibilities emerge.",
            symbolism: "Zero holds the energy of totality and emptiness, symbolizing both absence and infinite possibility, an essential paradox at the heart of transcendental theory.",
            application: "Within Transcendental Math, 0 represents the \"silent space\" or foundational pause—a reset point from which calculations and manifestations begin."
        ))

        // 1 - Unity / The Beginning
        addOrUpdateMeaning(NumberMeaning(
            number: 1,
            title: "Unity / The Beginning",
            essence: "The number one signifies unity, initiation, and individuality. It's the first spark of creation, the embodiment of \"I Am,\" the foundation of identity and personal will.",
            symbolism: "One is both singular and the origin of all multiplicity, symbolizing the conscious mind, self-awareness, and the journey of manifestation from thought into form.",
            application: "It's the starting point, a reference for action and the beginning of manifestation, grounding ideas into the material."
        ))

        // 2 - Duality / Reflection
        addOrUpdateMeaning(NumberMeaning(
            number: 2,
            title: "Duality / Reflection",
            essence: "Two represents duality and balance, the interplay of opposites—light and dark, positive and negative, material and spiritual. It's a number that teaches the importance of contrast and relationship.",
            symbolism: "As the mirror, two invites reflection and connection, serving as a reminder that all experiences are shaped by their opposites.",
            application: "In transcendental theory, 2 reflects the need to hold opposing forces in balance, understanding how contrasts define reality."
        ))

        // 3 - Harmony / The Triad
        addOrUpdateMeaning(NumberMeaning(
            number: 3,
            title: "Harmony / The Triad",
            essence: "Three is synthesis, the number of creativity, growth, and harmony. It represents the completion of a cycle, the blending of dualities, and the emergence of new forms.",
            symbolism: "In the physical realm, three represents the creation of stability, similar to a tripod. It's the fusion of opposites, yielding a new dimension—a harmonious whole.",
            application: "Within Transcendental Math, 3 brings understanding to the power of creative thought, where mind and matter meet and new ideas flourish."
        ))

        // 4 - Foundation / Structure
        addOrUpdateMeaning(NumberMeaning(
            number: 4,
            title: "Foundation / Structure",
            essence: "Four is stability, structure, and physicality. It represents the material world and the foundational elements of existence—earth, air, fire, and water. It's the energy of practicality and building.",
            symbolism: "The square or the cube represents four's physicality. In transcendental theory, four embodies the grounding force, the laws that govern form and structure.",
            application: "It's the number of establishing boundaries and frameworks. Four grounds transcendental concepts into form, manifesting ideas with precision."
        ))

        // 5 - Freedom / Adaptation
        addOrUpdateMeaning(NumberMeaning(
            number: 5,
            title: "Freedom / Adaptation",
            essence: "Five is the number of change, freedom, and adaptability. It's dynamic and represents the balance between stability and movement, between control and exploration.",
            symbolism: "Represented by the five senses, five signifies humanity's interaction with the world, embodying curiosity, freedom, and the drive for exploration.",
            application: "Within Transcendental Math, 5 teaches the art of flow—adjusting, transforming, and evolving as energies shift."
        ))

        // 6 - Harmony / Responsibility
        addOrUpdateMeaning(NumberMeaning(
            number: 6,
            title: "Harmony / Responsibility",
            essence: "Six is the number of balance within relationships, responsibility, and nurturing. It's a harmonizing force that emphasizes cooperation, empathy, and service.",
            symbolism: "Represented by the hexagon or the concept of a balanced family, six invites us to connect with others, bringing balance and harmony.",
            application: "Six in transcendental theory embodies the need to balance personal needs with those of others, highlighting the importance of equilibrium in connection."
        ))

        // 7 - Wisdom / Inner Understanding
        addOrUpdateMeaning(NumberMeaning(
            number: 7,
            title: "Wisdom / Inner Understanding",
            essence: "Seven represents introspection, spiritual awareness, and the quest for knowledge. It's a sacred number associated with wisdom, intuition, and the search for hidden truths.",
            symbolism: "Represented by the seven chakras, seven connects us to mystical truths and inner knowledge, illuminating pathways beyond the material.",
            application: "In transcendental theory, seven teaches that reality is as much internal as external, leading us to seek wisdom through introspection and universal laws."
        ))

        // 8 - Power / Manifestation
        addOrUpdateMeaning(NumberMeaning(
            number: 8,
            title: "Power / Manifestation",
            essence: "Eight symbolizes mastery, power, and abundance. It's the number of manifestation, where intentions and actions bear fruit in material form, creating cycles of growth and decay.",
            symbolism: "The infinity symbol (∞) is eight turned sideways, emphasizing cyclical power, balance, and karmic returns.",
            application: "In transcendental theory, eight represents the achievement of balance and mastery over one's world, the art of manifesting intentions into tangible results."
        ))

        // 9 - Completion / Transcendence
        addOrUpdateMeaning(NumberMeaning(
            number: 9,
            title: "Completion / Transcendence",
            essence: "Nine is the culmination, the number of enlightenment, compassion, and higher understanding. It embodies completion, universal love, and the transcendence of ego.",
            symbolism: "Represented as the end of the numerical cycle before returning to zero, nine symbolizes the full circle and the wisdom gained through experience.",
            application: "In transcendental theory, nine is the ultimate \"singularity,\" a number that returns all things to unity, embodying the transcendence of personal desires for universal truths."
        ))

        // Add integration note to all numbers
        let integrationNote = "In transcendental theory, each number acts as a stepping stone in the journey from void (0) to transcendence (9), forming a complete cycle where all experiences and manifestations can be mapped."
        for number in 0...9 {
            addNote(to: number, note: integrationNote)
        }
    }
    
    /// Get the meaning for a specific number
    func getMeaning(for number: Int) -> NumberMeaning? {
        return meanings.first { $0.number == number }
    }
    
    /// Add a new meaning or update existing
    func addOrUpdateMeaning(_ meaning: NumberMeaning) {
        if let index = meanings.firstIndex(where: { $0.number == meaning.number }) {
            meanings[index] = meaning
        } else {
            meanings.append(meaning)
        }
    }
    
    /// Add a note to a specific number's meaning
    func addNote(to number: Int, note: String) {
        if let index = meanings.firstIndex(where: { $0.number == number }) {
            meanings[index].notes.append(note)
        }
    }
    
    /// Get all documented meanings
    func getAllMeanings() -> [NumberMeaning] {
        return meanings.sorted { $0.number < $1.number }
    }
} 