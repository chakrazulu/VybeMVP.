/*
 * ========================================
 * 🔢 NUMEROLOGY SERVICE - SACRED CALCULATION ENGINE
 * ========================================
 * 
 * CORE PURPOSE:
 * Master numerological calculation engine implementing authentic Pythagorean numerology
 * algorithms with precise digit reduction, master number preservation, and sacred
 * letter-to-number mappings. Powers all spiritual calculations throughout VybeMVP
 * including Life Path, Soul Urge, and Expression number derivations.
 * 
 * SPIRITUAL CALCULATION ALGORITHMS:
 * 
 * === LIFE PATH NUMBER CALCULATION ===
 * Algorithm: Three-stage reduction with master number preservation
 * 1. Extract birthdate components (year, month, day)
 * 2. Reduce each component individually using reduceToSingleDigitOrMaster()
 * 3. Sum all reduced components
 * 4. Final reduction preserving master numbers (11, 22, 33)
 * 5. Return tuple: (finalNumber: Int, isMaster: Bool)
 * 
 * Example: Born December 29, 1985
 * - Year: 1985 → 1+9+8+5 = 23 → 2+3 = 5
 * - Month: 12 → 1+2 = 3  
 * - Day: 29 → 2+9 = 11 (Master Number - preserved)
 * - Sum: 5 + 3 + 11 = 19 → 1+9 = 10 → 1+0 = 1
 * - Result: (1, false)
 * 
 * === SOUL URGE NUMBER CALCULATION ===
 * Algorithm: Vowel-only extraction with Pythagorean mapping
 * 1. Extract vowels only: A, E, I, O, U (case insensitive)
 * 2. Filter non-alphabetic characters
 * 3. Map each vowel using letterToNumberPythagorean()
 * 4. Sum all vowel values
 * 5. Reduce with master number preservation
 * 6. Return tuple: (finalNumber: Int, isMaster: Bool) or nil if no vowels
 * 
 * Example: "Sarah Ellen Vaughn"
 * - Vowels: a, a, E, e, a, u
 * - Values: 1+1+5+5+1+3 = 16 → 1+6 = 7
 * - Result: (7, false)
 * 
 * === EXPRESSION NUMBER CALCULATION ===
 * Algorithm: Full name letter mapping with complete reduction
 * 1. Extract all alphabetic characters (consonants + vowels)
 * 2. Convert to uppercase for consistent mapping
 * 3. Map each letter using Pythagorean system
 * 4. Sum all letter values
 * 5. Reduce with master number preservation
 * 6. Return tuple: (finalNumber: Int, isMaster: Bool) or nil if no letters
 * 
 * === PYTHAGOREAN LETTER-TO-NUMBER MAPPING ===
 * Sacred correspondence system used throughout all calculations:
 * 
 * 1: A, J, S - Leadership, Independence, New Beginnings
 * 2: B, K, T - Cooperation, Balance, Partnerships  
 * 3: C, L, U - Creativity, Expression, Communication
 * 4: D, M, V - Foundation, Stability, Hard Work
 * 5: E, N, W - Freedom, Adventure, Change
 * 6: F, O, X - Love, Harmony, Responsibility
 * 7: G, P, Y - Spirituality, Mystery, Introspection
 * 8: H, Q, Z - Material Success, Power, Achievement
 * 9: I, R - Universal Love, Completion, Wisdom
 * 
 * === MASTER NUMBER PRESERVATION SYSTEM ===
 * Sacred Numbers: 11, 22, 33 (Master Numbers)
 * - Never reduced to single digits during calculations
 * - Preserved at intermediate and final stages
 * - Carry special spiritual significance and power
 * - 11: Master Intuition, Spiritual Messenger
 * - 22: Master Builder, Practical Visionary  
 * - 33: Master Teacher, Spiritual Healer
 * 
 * === DIGIT REDUCTION ALGORITHM ===
 * Function: reduceToSingleDigitOrMaster(_ number: Int) -> Int
 * 1. Convert to absolute value (positive)
 * 2. Check if already single digit (1-9) or master number → return
 * 3. While number > 9 and not master number:
 *    a. Convert to string
 *    b. Split into individual digits  
 *    c. Sum all digits
 *    d. Check if result is master number → break if true
 * 4. Handle edge case: if final result is 0 → return 9
 * 5. Return reduced number
 * 
 * === INTEGRATION POINTS ===
 * • UserArchetypeManager: Life Path calculations for spiritual profiles
 * • OnboardingViewModel: Full numerological profile creation
 * • AIInsightManager: Number-based insight generation
 * • ResonanceEngine: Numerological harmony detection
 * • VybeMatchManager: Cosmic synchronicity calculations
 * 
 * === PERFORMANCE CHARACTERISTICS ===
 * • Singleton pattern: NumerologyService.shared
 * • Thread-safe: Pure calculation functions
 * • Memory efficient: No retained state between calculations
 * • Fast execution: O(log n) digit reduction complexity
 * • Error handling: Graceful nil returns for invalid inputs
 * 
 * === SPIRITUAL SIGNIFICANCE ===
 * This service implements authentic numerological principles from the Pythagorean
 * tradition, maintaining the sacred mathematical relationships that reveal spiritual
 * insights about personality, life purpose, and soul evolution through numbers.
 * Each calculation preserves the mystical integrity of the ancient system while
 * providing modern computational efficiency.
 */

// Managers/NumerologyService.swift
import Foundation

/**
 * NumerologyService: A centralized service for performing various numerological calculations.
 *
 * This service encapsulates the logic for calculating Life Path, Soul Urge, Expression numbers,
 * and other numerological values, including the correct handling of Master Numbers.
 */
class NumerologyService {
    static let shared = NumerologyService() // Singleton instance

    private init() {} // Private initializer for singleton

    private let masterNumbers: Set<Int> = [11, 22, 33]

    // MARK: - Life Path Number Calculation
    /**
     * Calculates the Life Path number from a given birth date.
     * The Life Path number is derived from the sum of the digits of the birth year, month, and day.
     * Master Numbers (11, 22, 33) are preserved and not reduced further.
     *
     * - Parameter date: The user's date of birth.
     * - Returns: A tuple containing the calculated Life Path number and a boolean indicating if it's a Master Number. Returns (0, false) if date components are invalid.
     */
    func calculateLifePathNumber(from date: Date) -> (number: Int, isMaster: Bool) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        guard let year = components.year, let month = components.month, let day = components.day else {
            print("Error: Invalid date components for Life Path calculation.")
            return (0, false) // Indicate error or invalid input
        }

        // Reduce year, month, and day components individually first.
        // This is a common numerological practice.
        let reducedYear = reduceToSingleDigitOrMaster(year)
        let reducedMonth = reduceToSingleDigitOrMaster(month)
        let reducedDay = reduceToSingleDigitOrMaster(day)
        
        var totalSum = reducedYear + reducedMonth + reducedDay
        
        // Now, reduce the sum of these reduced components.
        totalSum = reduceToSingleDigitOrMaster(totalSum)
        
        let isMaster = masterNumbers.contains(totalSum)
        return (totalSum, isMaster)
    }

    // MARK: - Soul Urge Number Calculation (Vowels)
    /**
     * Calculates the Soul Urge (Heart's Desire) number from the vowels in a given name.
     * Uses the Pythagorean letter-to-number system.
     *
     * - Parameter fullName: The user's full name at birth.
     * - Returns: A tuple containing the calculated Soul Urge number and a boolean indicating if it's a Master Number. Returns nil if the name is empty or contains no vowels.
     */
    func calculateSoulUrgeNumber(from fullName: String) -> (number: Int, isMaster: Bool)? {
        guard !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        
        let vowels = "AEIOUaeiou"
        // Filter out non-alphabetic characters before processing
        let onlyLettersName = fullName.filter { $0.isLetter }
        let vowelChars = onlyLettersName.filter { vowels.contains($0) }
        
        // If no vowels are found, some numerology systems have specific rules.
        // For now, returning 0 or nil might be appropriate. Let's return nil if no vowels.
        guard !vowelChars.isEmpty else { return nil }

        let sumOfVowels = vowelChars.reduce(0) { sum, char -> Int in
            sum + letterToNumberPythagorean(char)
        }

        let finalNumber = reduceToSingleDigitOrMaster(sumOfVowels)
        let isMaster = masterNumbers.contains(finalNumber)
        return (finalNumber, isMaster)
    }

    // MARK: - Expression Number Calculation (All Letters)
    /**
     * Calculates the Expression (Personality/Destiny) number from all letters in a given name.
     * Uses the Pythagorean letter-to-number system.
     *
     * - Parameter fullName: The user's full name at birth.
     * - Returns: A tuple containing the calculated Expression number and a boolean indicating if it's a Master Number. Returns nil if the name is empty or contains no letters.
     */
    func calculateExpressionNumber(from fullName: String) -> (number: Int, isMaster: Bool)? {
        guard !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }

        // Filter out non-alphabetic characters and convert to uppercase
        let onlyLettersName = fullName.uppercased().filter { $0.isLetter }
        
        guard !onlyLettersName.isEmpty else { return nil }

        let sumOfAllLetters = onlyLettersName.reduce(0) { sum, char -> Int in
            sum + letterToNumberPythagorean(char)
        }
        
        let finalNumber = reduceToSingleDigitOrMaster(sumOfAllLetters)
        let isMaster = masterNumbers.contains(finalNumber)
        return (finalNumber, isMaster)
    }

    // MARK: - Helper Functions
    /**
     * Reduces a number by summing its digits until it's a single digit (1-9) or a Master Number (11, 22, 33).
     * If the initial number itself is a Master Number or a single digit (1-9), it's returned directly.
     * A sum reducing to 0 will be converted to 9, as per some numerological practices.
     *
     * - Parameter number: The number to reduce.
     * - Returns: The reduced number.
     */
    private func reduceToSingleDigitOrMaster(_ number: Int) -> Int {
        var currentSum = abs(number) // Ensure we are working with a positive number

        // If currentSum is already a master number, or a single digit (1-9), return it.
        if masterNumbers.contains(currentSum) || (currentSum >= 1 && currentSum <= 9) {
            return currentSum
        }
        // If currentSum is 0 initially (e.g. from an empty input that wasn't guarded), return 0 or handle as error.
        // For intermediate sums, this check is less likely.
        if currentSum == 0 { return 0 } // Or handle as an error/invalid state

        // Loop to reduce the number if it's greater than 9 and not a master number
        while currentSum > 9 && !masterNumbers.contains(currentSum) {
            currentSum = String(currentSum).compactMap { Int(String($0)) }.reduce(0, +)
            // After summing digits, if the new sum is a master number, we stop.
            if masterNumbers.contains(currentSum) {
                break
            }
        }
        
        // If, after all reductions, the number is 0 (and wasn't a master number path),
        // some numerology systems convert 0 to 9.
        if currentSum == 0 {
            return 9
        }

        return currentSum
    }
    
    /**
     * Converts a letter to its Pythagorean numerological value (1-9).
     * Non-alphabetic characters return 0.
     * - Parameter letter: The character to convert.
     * - Returns: The numerological value (1-9), or 0 for non-alphabetic characters.
     */
    private func letterToNumberPythagorean(_ letter: Character) -> Int {
        switch letter.uppercased() {
            case "A", "J", "S": return 1
            case "B", "K", "T": return 2
            case "C", "L", "U": return 3
            case "D", "M", "V": return 4
            case "E", "N", "W": return 5
            case "F", "O", "X": return 6
            case "G", "P", "Y": return 7
            case "H", "Q", "Z": return 8
            case "I", "R": return 9
            default: return 0 // For spaces, numbers, punctuation within the name string
        }
    }
} 