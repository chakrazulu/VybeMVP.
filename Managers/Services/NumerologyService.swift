/*
 * ========================================
 * 🔢 NUMEROLOGY SERVICE
 * ========================================
 *
 * DIVINE PURPOSE:
 * Specialized service for all numerological calculations within the Divine Triangle.
 * Handles Life Path, Soul Urge, and Expression number computations with proper
 * master number preservation and spiritual accuracy.
 *
 * SACRED MATHEMATICS:
 * - Preserves master numbers (11, 22, 33, 44) during reduction
 * - Maintains numerological integrity through proper letter-to-number mappings
 * - Provides accurate birth date calculations with date component handling
 * - Supports international characters and name variations
 *
 * ARCHITECTURE BENEFITS:
 * - Centralized numerology logic eliminates scope issues
 * - Consistent calculation methods across all views
 * - Easy testing and validation of spiritual mathematics
 * - Thread-safe operations for concurrent access
 */

import Foundation

/// Claude: Specialized service for Divine Triangle numerology calculations
final class NumerologyService {

    // MARK: - Singleton
    static let shared = NumerologyService()

    // MARK: - Letter to Number Mappings
    private let letterValues: [Character: Int] = [
        "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9,
        "J": 1, "K": 2, "L": 3, "M": 4, "N": 5, "O": 6, "P": 7, "Q": 8, "R": 9,
        "S": 1, "T": 2, "U": 3, "V": 4, "W": 5, "X": 6, "Y": 7, "Z": 8
    ]

    private let vowels: Set<Character> = ["A", "E", "I", "O", "U", "Y"]

    // MARK: - Initialization
    private init() {}

    // MARK: - 🌟 Life Path Number Calculation

    /// Claude: Calculate life path number from birth date with master number preservation
    /// Uses proper date component reduction while preserving master numbers
    func calculateLifePathNumber(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate)

        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
            print("⚠️ NumerologyService: Invalid date components")
            return 1 // Default fallback
        }

        // Calculate each component separately to check for master numbers
        let yearSum = digitSum(year)
        let monthSum = digitSum(month)
        let daySum = digitSum(day)

        // Check if any component reduces to a master number before final reduction
        let intermediateNumbers = [yearSum, monthSum, daySum]
        for number in intermediateNumbers {
            if isMasterNumber(number) {
                print("🔮 NumerologyService: Intermediate master number detected: \(number)")
            }
        }

        // Calculate total and reduce with master number preservation
        let totalSum = yearSum + monthSum + daySum
        return reduceToSingleDigitOrMaster(totalSum)
    }

    // MARK: - 💫 Soul Urge Number Calculation

    /// Claude: Calculate soul urge number from name vowels with spiritual accuracy
    /// Extracts vowels and applies proper numerological reduction
    func calculateSoulUrgeNumber(from fullName: String) -> Int {
        guard !fullName.isEmpty else { return 0 }

        let cleanName = fullName.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let vowelSum = cleanName.compactMap { char in
            if vowels.contains(char) {
                return letterValues[char]
            }
            return nil
        }.reduce(0, +)

        guard vowelSum > 0 else { return 0 }

        return reduceToSingleDigitOrMaster(vowelSum)
    }

    // MARK: - ⚡ Expression Number Calculation

    /// Claude: Calculate expression number from full name with complete letter analysis
    /// Uses all letters (vowels and consonants) for comprehensive numerological insight
    func calculateExpressionNumber(from fullName: String) -> Int {
        guard !fullName.isEmpty else { return 0 }

        let cleanName = fullName.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let letterSum = cleanName.compactMap { char in
            if char.isLetter {
                return letterValues[char]
            }
            return nil
        }.reduce(0, +)

        guard letterSum > 0 else { return 0 }

        return reduceToSingleDigitOrMaster(letterSum)
    }

    // MARK: - 🔮 Master Number Detection

    /// Claude: Check if a number is a master number that should be preserved
    func isMasterNumber(_ number: Int) -> Bool {
        return [11, 22, 33, 44].contains(number)
    }

    /// Claude: Determine if a calculated number should be treated as master
    /// Considers both the number value and its spiritual significance
    func shouldTreatAsMaster(_ number: Int, context: String = "") -> Bool {
        guard isMasterNumber(number) else { return false }

        // Additional logic can be added here for context-specific master number handling
        // For example, some traditions only recognize 11, 22, 33 as true masters
        switch number {
        case 11, 22, 33:
            return true
        case 44:
            return true // Include 44 as master for modern numerology
        default:
            return false
        }
    }

    // MARK: - 🧮 Mathematical Utilities

    /// Claude: Calculate digit sum of a number (e.g., 1985 -> 1+9+8+5 = 23)
    private func digitSum(_ number: Int) -> Int {
        return abs(number).description.compactMap { $0.wholeNumberValue }.reduce(0, +)
    }

    /// Claude: Reduce number to single digit while preserving master numbers
    /// The core of numerological reduction with spiritual integrity
    private func reduceToSingleDigitOrMaster(_ number: Int) -> Int {
        var current = abs(number)

        // If already a master number, preserve it
        if isMasterNumber(current) {
            return current
        }

        // If single digit, return as-is
        if current < 10 {
            return current
        }

        // Iteratively reduce while checking for master numbers
        while current >= 10 {
            current = digitSum(current)

            // If we hit a master number during reduction, preserve it
            if isMasterNumber(current) {
                return current
            }
        }

        return current
    }

    // MARK: - 🔤 Name Processing Utilities

    /// Claude: Extract and validate name components for numerology
    /// Handles international characters and name formatting
    func processNameForNumerology(_ name: String) -> String {
        return name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "  ", with: " ") // Remove double spaces
            .uppercased()
    }

    /// Claude: Get vowels from a name for soul urge calculation
    func extractVowels(from name: String) -> String {
        let processedName = processNameForNumerology(name)
        return String(processedName.filter { vowels.contains($0) })
    }

    /// Claude: Get consonants from a name for specialized calculations
    func extractConsonants(from name: String) -> String {
        let processedName = processNameForNumerology(name)
        return String(processedName.filter { $0.isLetter && !vowels.contains($0) })
    }

    // MARK: - 📊 Calculation Validation

    /// Claude: Validate numerology calculation with detailed breakdown
    /// Useful for debugging and educational purposes
    func validateCalculation(name: String, birthDate: Date) -> NumerologyValidation {
        let lifePathNumber = calculateLifePathNumber(from: birthDate)
        let soulUrgeNumber = calculateSoulUrgeNumber(from: name)
        let expressionNumber = calculateExpressionNumber(from: name)

        return NumerologyValidation(
            name: name,
            birthDate: birthDate,
            lifePathNumber: lifePathNumber,
            isLifePathMaster: isMasterNumber(lifePathNumber),
            soulUrgeNumber: soulUrgeNumber,
            isSoulUrgeMaster: isMasterNumber(soulUrgeNumber),
            expressionNumber: expressionNumber,
            isExpressionMaster: isMasterNumber(expressionNumber),
            vowelsExtracted: extractVowels(from: name),
            consonantsExtracted: extractConsonants(from: name)
        )
    }
}

// MARK: - 📋 Validation Structure

/// Claude: Comprehensive validation result for numerology calculations
struct NumerologyValidation {
    let name: String
    let birthDate: Date
    let lifePathNumber: Int
    let isLifePathMaster: Bool
    let soulUrgeNumber: Int
    let isSoulUrgeMaster: Bool
    let expressionNumber: Int
    let isExpressionMaster: Bool
    let vowelsExtracted: String
    let consonantsExtracted: String

    /// Claude: Generate human-readable summary of the calculation
    var summary: String {
        return """
        🔮 Numerology Analysis for \(name):

        📅 Life Path: \(lifePathNumber) \(isLifePathMaster ? "(Master Number)" : "")
        💫 Soul Urge: \(soulUrgeNumber) \(isSoulUrgeMaster ? "(Master Number)" : "")
        ⚡ Expression: \(expressionNumber) \(isExpressionMaster ? "(Master Number)" : "")

        🔤 Vowels: \(vowelsExtracted)
        🔤 Consonants: \(consonantsExtracted)
        """
    }
}
