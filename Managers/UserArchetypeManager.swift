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
        isCalculating = true
        defer { isCalculating = false }
        
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
            fatalError("No planetary mapping found for life path \(lifePath)")
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
            fatalError("Could not extract date components from birthdate")
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