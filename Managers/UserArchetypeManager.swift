/*
 * ========================================
 * 🌟 USER ARCHETYPE MANAGER - SPIRITUAL IDENTITY CALCULATOR
 * ========================================
 *
 * CORE PURPOSE:
 * Advanced spiritual archetype calculation engine combining numerology, astrology,
 * and planetary mappings to create comprehensive spiritual identity profiles.
 * Generates Life Path numbers, zodiac alignments, elemental associations, and
 * planetary archetypal influences from user birthdates.
 *
 * SPIRITUAL CALCULATION SYSTEMS:
 * - Life Path Numerology: Birthdate digit reduction with master number preservation
 * - Zodiac Astrology: Date-based zodiac sign determination with precise boundaries
 * - Elemental Mapping: Four-element system (Fire, Earth, Air, Water) from zodiac
 * - Planetary Archetypes: Sacred planetary mappings for conscious/subconscious influences
 * - Master Numbers: Special preservation of 11, 22, 33 in numerological calculations
 *
 * NUMEROLOGY ALGORITHM:
 * 1. Extract year, month, day components from birthdate
 * 2. Sum all digits in each component using sumDigits() function
 * 3. Add component sums together for total sum
 * 4. Reduce using reduceToLifePath() preserving master numbers (11, 22, 33)
 * 5. Return final Life Path number (1-9, 11, 22, 33)
 *
 * ZODIAC DETERMINATION:
 * - Aries: March 21 - April 19 (Fire)
 * - Taurus: April 20 - May 20 (Earth)
 * - Gemini: May 21 - June 20 (Air)
 * - Cancer: June 21 - July 22 (Water)
 * - Leo: July 23 - August 22 (Fire)
 * - Virgo: August 23 - September 22 (Earth)
 * - Libra: September 23 - October 22 (Air)
 * - Scorpio: October 23 - November 21 (Water)
 * - Sagittarius: November 22 - December 21 (Fire)
 * - Capricorn: December 22 - January 19 (Earth)
 * - Aquarius: January 20 - February 18 (Air)
 * - Pisces: February 19 - March 20 (Water)
 *
 * PLANETARY MAPPING TABLE:
 * - 1: Sun/Saturn (Leadership/Structure)
 * - 2: Moon/Mars (Intuition/Action)
 * - 3: Jupiter/Mercury (Expansion/Communication)
 * - 4: Uranus/Moon (Innovation/Emotion)
 * - 5: Mercury/Neptune (Communication/Spirituality)
 * - 6: Venus/Pluto (Love/Transformation)
 * - 7: Neptune/Jupiter (Mysticism/Wisdom)
 * - 8: Saturn/Sun (Authority/Power)
 * - 9: Mars/Venus (Action/Harmony)
 * - 11: Moon/Uranus (Master Intuition/Innovation)
 * - 22: Earth/Mercury (Master Builder/Messenger)
 * - 33: Venus/Mars (Master Teacher/Warrior)
 *
 * STATE MANAGEMENT:
 * - @Published currentArchetype: Currently loaded archetype for UI binding
 * - @Published isCalculating: Boolean flag for calculation loading states
 * - Singleton Pattern: UserArchetypeManager.shared for app-wide access
 * - UserDefaults Persistence: Cached archetype data with JSON encoding
 * - ObservableObject: SwiftUI reactive updates for archetype changes
 *
 * INTEGRATION POINTS:
 * - BirthdateInputView: Primary calculation trigger during onboarding
 * - ArchetypeDisplayView: Displays calculated archetype with detailed breakdown
 * - OnboardingView: Archetype completion validation for flow progression
 * - UserProfileService: Profile integration for spiritual preference alignment
 * - NotificationCenter: Posts .archetypeCalculated for flow coordination
 *
 * CACHING & PERSISTENCE:
 * - UserDefaults Storage: JSON-encoded archetype data for offline access
 * - Cache Key: "user_archetype" for consistent data retrieval
 * - Automatic Caching: All calculated archetypes automatically persisted
 * - Cache Validation: hasStoredArchetype() for onboarding completion checks
 * - Data Cleanup: clearArchetype() for logout and user data removal
 *
 * CALCULATION PERFORMANCE:
 * - Efficient Algorithms: Optimized digit summing and reduction operations
 * - Master Number Logic: Proper preservation without unnecessary reduction
 * - Date Component Extraction: Calendar-based component parsing
 * - Error Handling: Comprehensive guards for invalid date components
 * - Debugging Support: Detailed calculation logging for verification
 *
 * ARCHETYPE COMPOSITION:
 * - UserArchetype Struct: Complete spiritual profile data structure
 * - Life Path Integration: Primary numerological identity number
 * - Zodiac Properties: Sign, element, and date range information
 * - Planetary Influences: Primary and subconscious planetary archetypes
 * - Calculation Timestamp: Date tracking for archetype generation
 *
 * ERROR HANDLING & VALIDATION:
 * - Date Component Guards: Ensures valid year, month, day extraction
 * - Planetary Mapping Validation: Fatal error for missing life path mappings
 * - JSON Encoding/Decoding: Graceful handling of persistence failures
 * - Fallback Mechanisms: Default zodiac sign (Capricorn) for edge cases
 * - Master Number Validation: Proper identification and preservation
 *
 * DEBUGGING & DEVELOPMENT:
 * - Comprehensive Logging: Detailed calculation step tracking
 * - Test Archetype Creation: createTestArchetype() for development
 * - Debug Analysis: debugArchetype() for detailed profile inspection
 * - Stored Archetype Access: storedArchetype property for testing
 * - Calculation Tracing: Step-by-step numerology calculation logging
 *
 * TECHNICAL NOTES:
 * - Thread Safety: Main queue updates for @Published properties
 * - Memory Efficiency: Minimal state storage with UserDefaults persistence
 * - Algorithm Accuracy: Mathematically precise numerological calculations
 * - Zodiac Precision: Exact date boundaries for accurate sign determination
 * - Master Number Integrity: Proper preservation of sacred numerological values
 */

//
//  UserArchetypeManager.swift
//  VybeMVP
//
//  Created by Corey Davis on 1/12/25.
//

import Foundation

/**
 * Manager responsible for calculating and managing user spiritual archetypes.
 *
 * This manager creates a comprehensive spiritual identity profile by combining:
 * - Life Path numerology (from birthdate)
 * - Zodiac sign astrology (from birth month/day)
 * - Elemental alignment (derived from zodiac)
 * - Planetary mappings (mapped from life path)
 *
 * The archetype is calculated once during onboarding and cached for
 * fast access throughout the app experience.
 */
class UserArchetypeManager: ObservableObject {

    // MARK: - Singleton Instance
    static let shared = UserArchetypeManager()
    private init() {}

    // MARK: - Published Properties
    @Published private(set) var currentArchetype: UserArchetype?
    @Published private(set) var isCalculating: Bool = false

    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let archetypeKey = "user_archetype"

    // MARK: - Planetary Mapping Table
    /**
     * Sacred planetary mappings based on life path numbers.
     * This table represents the symbolic relationship between numerological
     * life paths and their corresponding planetary archetypes.
     */
    private let planetaryMappings: [Int: (primary: Planet, subconscious: Planet)] = [
        1: (.sun, .saturn),
        2: (.moon, .mars),
        3: (.jupiter, .mercury),
        4: (.uranus, .moon),
        5: (.mercury, .neptune),
        6: (.venus, .pluto),
        7: (.neptune, .jupiter),
        8: (.saturn, .sun),
        9: (.mars, .venus),
        11: (.moon, .uranus),     // Master number: Moon/Uranus hybrid
        22: (.earth, .mercury),   // Master number: Earth/Mercury hybrid
        33: (.venus, .mars)       // Master number: Venus/Mars hybrid
    ]

    // MARK: - Public Methods

    /**
     * Calculates the complete spiritual archetype from a birthdate.
     *
     * - Parameter birthdate: The user's birth date
     * - Returns: Complete UserArchetype profile
     *
     * This method performs the full archetypal calculation including:
     * 1. Life path number calculation using numerological reduction
     * 2. Zodiac sign determination from birth month/day
     * 3. Elemental assignment from zodiac sign
     * 4. Planetary mapping from life path number
     */
    func calculateArchetype(from birthdate: Date) -> UserArchetype {
        // Ensure UI updates happen on main thread
        Task { @MainActor in
            isCalculating = true
        }
        defer {
            Task { @MainActor in
                isCalculating = false
            }
        }

        print("\n🌟 ===============================")
        print("🌟   USER ARCHETYPE CALCULATION  ")
        print("🌟 ===============================")

        // 1. Calculate Life Path Number
        let lifePath = calculateLifePath(from: birthdate)
        print("📊 Life Path Number: \(lifePath)")

        // 2. Determine Zodiac Sign
        let zodiacSign = calculateZodiacSign(from: birthdate)
        print("♈ Zodiac Sign: \(zodiacSign.rawValue)")

        // 3. Derive Element from Zodiac
        let element = zodiacSign.element
        print("🔥 Element: \(element.rawValue.capitalized)")

        // 4. Map Planetary Archetypes
        guard let planetMapping = planetaryMappings[lifePath] else {
            // Claude: Graceful fallback for unexpected life path numbers
            assertionFailure("No planetary mapping found for life path \(lifePath)")
            print("🌀 Cosmic alignment unavailable for life path \(lifePath). Using default mapping.")
            // Use Sun/Moon as default spiritual archetype
            let fallbackMapping = (primary: Planet.sun, subconscious: Planet.moon)
            print("✨ Using universal archetype: Sun (conscious) / Moon (subconscious)")
            // Store the fallback mapping for consistent use
            let archetype = UserArchetype(
                lifePath: lifePath,
                zodiacSign: zodiacSign,
                element: element,
                primaryPlanet: fallbackMapping.primary,
                subconsciousPlanet: fallbackMapping.subconscious,
                calculatedDate: Date()
            )
            cacheArchetype(archetype)
            DispatchQueue.main.async {
                self.currentArchetype = archetype
            }
            return archetype
        }

        let primaryPlanet = planetMapping.primary
        let subconsciousPlanet = planetMapping.subconscious

        print("🪐 Primary Planet: \(primaryPlanet.rawValue.capitalized)")
        print("🌙 Subconscious Planet: \(subconsciousPlanet.rawValue.capitalized)")

        // 5. Create Archetype
        let archetype = UserArchetype(
            lifePath: lifePath,
            zodiacSign: zodiacSign,
            element: element,
            primaryPlanet: primaryPlanet,
            subconsciousPlanet: subconsciousPlanet,
            calculatedDate: Date()
        )

        print("✨ Archetype Created Successfully")
        print("🌟 ===============================\n")

        // Cache the result
        cacheArchetype(archetype)

        DispatchQueue.main.async {
            self.currentArchetype = archetype
        }

        return archetype
    }

    /**
     * Loads cached archetype from UserDefaults.
     *
     * - Returns: Cached UserArchetype if available, nil otherwise
     */
    func loadCachedArchetype() -> UserArchetype? {
        guard let data = userDefaults.data(forKey: archetypeKey),
              let archetype = try? JSONDecoder().decode(UserArchetype.self, from: data) else {
            return nil
        }

        DispatchQueue.main.async {
            self.currentArchetype = archetype
        }

        return archetype
    }

    /**
     * Clears the stored archetype data.
     * Used during logout to remove user-specific data.
     */
    func clearArchetype() {
        userDefaults.removeObject(forKey: archetypeKey)
        DispatchQueue.main.async {
            self.currentArchetype = nil
        }
        print("🗑️ Cleared stored archetype data")
    }

    /**
     * Checks if there is a stored archetype for the current user.
     * Used to determine if onboarding has been completed.
     *
     * - Returns: True if archetype data exists, false otherwise
     */
    func hasStoredArchetype() -> Bool {
        return userDefaults.object(forKey: archetypeKey) != nil
    }

    /**
     * Returns the currently stored archetype without loading it into currentArchetype.
     * Used for debugging and testing purposes.
     *
     * - Returns: Stored UserArchetype if available, nil otherwise
     */
    var storedArchetype: UserArchetype? {
        guard let data = userDefaults.data(forKey: archetypeKey),
              let archetype = try? JSONDecoder().decode(UserArchetype.self, from: data) else {
            return nil
        }
        return archetype
    }

    // MARK: - Private Calculation Methods

    /**
     * Calculates the Life Path number from a birthdate using numerological reduction.
     *
     * - Parameter birthdate: The birth date to calculate from
     * - Returns: Life Path number (1-9, 11, 22, 33)
     *
     * Algorithm:
     * 1. Extract year, month, day components
     * 2. Sum all digits in each component
     * 3. Add all components together
     * 4. Reduce to single digit, preserving master numbers (11, 22, 33)
     */
    private func calculateLifePath(from birthdate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthdate)

        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
            // Claude: Graceful handling of invalid date components
            assertionFailure("Could not extract date components from birthdate")
            print("🌀 Birthdate energy temporarily misaligned. Using default Life Path 1.")
            // Return Life Path 1 (Sun energy) as a safe default
            return 1
        }

        print("\n📅 Birth Date Components:")
        print("   Year: \(year)")
        print("   Month: \(month)")
        print("   Day: \(day)")

        // Sum digits in each component
        let yearSum = sumDigits(year)
        let monthSum = sumDigits(month)
        let daySum = sumDigits(day)

        print("\n🧮 Component Digit Sums:")
        print("   Year \(year) → \(yearSum)")
        print("   Month \(month) → \(monthSum)")
        print("   Day \(day) → \(daySum)")

        // Add all components
        let totalSum = yearSum + monthSum + daySum
        print("   Total: \(yearSum) + \(monthSum) + \(daySum) = \(totalSum)")

        // Reduce to life path, preserving master numbers
        let lifePath = reduceToLifePath(totalSum)
        print("   Life Path: \(totalSum) → \(lifePath)")

        return lifePath
    }

    /**
     * Determines zodiac sign from birth date.
     *
     * - Parameter birthdate: The birth date
     * - Returns: ZodiacSign enum value
     */
    private func calculateZodiacSign(from birthdate: Date) -> ZodiacSign {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: birthdate)
        let day = calendar.component(.day, from: birthdate)

        switch (month, day) {
        case (3, 21...), (4, ...19):
            return .aries
        case (4, 20...), (5, ...20):
            return .taurus
        case (5, 21...), (6, ...20):
            return .gemini
        case (6, 21...), (7, ...22):
            return .cancer
        case (7, 23...), (8, ...22):
            return .leo
        case (8, 23...), (9, ...22):
            return .virgo
        case (9, 23...), (10, ...22):
            return .libra
        case (10, 23...), (11, ...21):
            return .scorpio
        case (11, 22...), (12, ...21):
            return .sagittarius
        case (12, 22...), (1, ...19):
            return .capricorn
        case (1, 20...), (2, ...18):
            return .aquarius
        case (2, 19...), (3, ...20):
            return .pisces
        default:
            return .capricorn // Default fallback
        }
    }

    /**
     * Sums all digits in a number.
     *
     * - Parameter number: Number to sum digits for
     * - Returns: Sum of all digits
     */
    private func sumDigits(_ number: Int) -> Int {
        return String(abs(number))
            .compactMap { Int(String($0)) }
            .reduce(0, +)
    }

    /**
     * Reduces a number to a life path, preserving master numbers.
     *
     * - Parameter number: Number to reduce
     * - Returns: Life Path number (1-9, 11, 22, 33)
     *
     * Master numbers (11, 22, 33) are preserved and not reduced further.
     * All other numbers are reduced to single digits (1-9).
     */
    private func reduceToLifePath(_ number: Int) -> Int {
        var num = abs(number)

        while num > 9 {
            // Check for master numbers before reducing
            if num == 11 || num == 22 || num == 33 {
                return num
            }

            // Reduce by summing digits
            num = sumDigits(num)
        }

        return num
    }

    /**
     * Caches archetype to UserDefaults for persistence.
     *
     * - Parameter archetype: UserArchetype to cache
     */
    private func cacheArchetype(_ archetype: UserArchetype) {
        do {
            let data = try JSONEncoder().encode(archetype)
            userDefaults.set(data, forKey: archetypeKey)
            print("💾 Archetype cached successfully")
        } catch {
            print("❌ Failed to cache archetype: \(error)")
        }
    }
}

// MARK: - Debug Extensions

extension UserArchetypeManager {
    /**
     * Creates a test archetype for development purposes.
     * This method should only be used during development and testing.
     */
    func createTestArchetype() -> UserArchetype {
        let testBirthdate = Calendar.current.date(from: DateComponents(year: 1990, month: 6, day: 15)) ?? Date()
        return calculateArchetype(from: testBirthdate)
    }

    /**
     * Prints detailed archetype information for debugging.
     *
     * - Parameter archetype: UserArchetype to analyze
     */
    func debugArchetype(_ archetype: UserArchetype) {
        print("\n🔍 ===============================")
        print("🔍       ARCHETYPE DEBUG         ")
        print("🔍 ===============================")
        print("Life Path: \(archetype.lifePath)")
        print("Zodiac: \(archetype.zodiacDescription)")
        print("Element: \(archetype.elementDescription)")
        print("Planets: \(archetype.planetaryDescription)")
        print("Primary Planet Archetype: \(archetype.primaryPlanet.archetype)")
        print("Subconscious Planet Archetype: \(archetype.subconsciousPlanet.archetype)")
        print("Calculated: \(archetype.calculatedDate)")
        print("🔍 ===============================\n")
    }
}
