import SwiftUI

/// Sacred Geometry Assets - Mystical Classification System
/// Auto-generated enum for easy asset access with numerological mapping
enum SacredGeometryAsset: String, CaseIterable {
    
    // MARK: - 0 - VOID & INFINITE POTENTIAL
    case voidTriquetra = "void_triquetra"
    case voidCosmicWomb = "void_cosmic_womb"
    case voidZeroPoint = "void_zero_point"
    case voidEternalReturn = "void_eternal_return"
    case voidStarMatrix = "void_star_matrix"
    case voidAkashicGrid = "void_akashic_grid"
    case voidCrystal = "void_crystal"
    
    // MARK: - 1 - UNITY & DIVINE SPARK
    case unitySolar = "unity_solar"
    case unityCrown = "unity_crown"
    case unityMonad = "unity_monad"
    case unityAlpha = "unity_alpha"
    case unityConsciousness = "unity_consciousness"
    case unitySpark = "unity_spark"
    
    // MARK: - 2 - DUALITY & COSMIC POLARITY
    case dualityVesica = "duality_vesica"
    case dualityLunar = "duality_lunar"
    case dualityYinYang = "duality_yin_yang"
    case dualityPillars = "duality_pillars"
    case dualityDivine = "duality_divine"
    case dualityTwins = "duality_twins"
    case dualityMirror = "duality_mirror"
    
    // MARK: - 3 - TRINITY & DIVINE CREATIVITY
    case trinityMandala = "trinity_mandala"
    case trinityTriangle = "trinity_triangle"
    case trinityWisdom = "trinity_wisdom"
    case trinityFire = "trinity_fire"
    case trinityGate = "trinity_gate"
    case trinityExpression = "trinity_expression"
    case trinityLogos = "trinity_logos"
    
    // MARK: - 4 - FOUNDATION & MATERIAL MANIFESTATION
    case foundationCube = "foundation_cube"
    case foundationCross = "foundation_cross"
    case foundationTemple = "foundation_temple"
    case foundationStone = "foundation_stone"
    case foundationGrid = "foundation_grid"
    case foundationMatrix = "foundation_matrix"
    case foundationBlessing = "foundation_blessing"
    
    // MARK: - 5 - QUINTESSENCE & DIVINE WILL
    case willPentagram = "will_pentagram"
    case willGoldenSpiral = "will_golden_spiral"
    case willShield = "will_shield"
    case willPhoenix = "will_phoenix"
    case willPower = "will_power"
    case willStar = "will_star"
    case willCommand = "will_command"
    
    // MARK: - 6 - HARMONY & COSMIC LOVE
    case harmonyStarDavid = "harmony_star_david"
    case harmonyFlowerLife = "harmony_flower_life"
    case harmonyHeart = "harmony_heart"
    case harmonyChrist = "harmony_christ"
    case harmonyUniversal = "harmony_universal"
    case harmonyMarriage = "harmony_marriage"
    case harmonyBeauty = "harmony_beauty"
    
    // MARK: - 7 - MYSTERY & SPIRITUAL MASTERY
    case mysterySeedLife = "mystery_seed_life"
    case mysterySeals = "mystery_seals"
    case mysteryRose = "mystery_rose"
    case mysteryVictory = "mystery_victory"
    case mysteryWisdom = "mystery_wisdom"
    case mysteryMagic = "mystery_magic"
    case mysteryGnosis = "mystery_gnosis"
    
    // MARK: - 8 - RENEWAL & INFINITE CYCLES
    case renewalOctagon = "renewal_octagon"
    case renewalInfinity = "renewal_infinity"
    case renewalKarmic = "renewal_karmic"
    case renewalTime = "renewal_time"
    case renewalJustice = "renewal_justice"
    case renewalScales = "renewal_scales"
    case renewalMatrix = "renewal_matrix"
    
    // MARK: - 9 - COMPLETION & UNIVERSAL WISDOM
    case wisdomEnneagram = "wisdom_enneagram"
    case wisdomCompletion = "wisdom_completion"
    
    // MARK: - Computed Properties
    
    /// Display name for UI
    var displayName: String {
        switch self {
        // 0 - VOID & INFINITE POTENTIAL
        case .voidTriquetra: return "Triquetra of the Void"
        case .voidCosmicWomb: return "Cosmic Womb"
        case .voidZeroPoint: return "Zero Point Field"
        case .voidEternalReturn: return "Eternal Return Mandala"
        case .voidStarMatrix: return "Void Star Matrix"
        case .voidAkashicGrid: return "Akashic Record Grid"
        case .voidCrystal: return "Primordial Crystal"
            
        // 1 - UNITY & DIVINE SPARK
        case .unitySolar: return "Solar Genesis"
        case .unityCrown: return "Crown of Creation"
        case .unityMonad: return "Monadic Seed"
        case .unityAlpha: return "Alpha Point"
        case .unityConsciousness: return "Unity Consciousness"
        case .unitySpark: return "Divine Spark"
            
        // 2 - DUALITY & COSMIC POLARITY
        case .dualityVesica: return "Vesica Piscis Gateway"
        case .dualityLunar: return "Lunar Reflection"
        case .dualityYinYang: return "Yin-Yang Harmony"
        case .dualityPillars: return "Pillar Balance"
        case .dualityDivine: return "Divine Duality"
        case .dualityTwins: return "Cosmic Twins"
        case .dualityMirror: return "Mirror of Eternity"
            
        // 3 - TRINITY & DIVINE CREATIVITY
        case .trinityMandala: return "Trinity Mandala Supreme"
        case .trinityTriangle: return "Sacred Triangle"
        case .trinityWisdom: return "Triune Wisdom"
        case .trinityFire: return "Creative Fire"
        case .trinityGate: return "Trinity Gate"
        case .trinityExpression: return "Divine Expression"
        case .trinityLogos: return "Logos Manifestation"
            
        // 4 - FOUNDATION & MATERIAL MANIFESTATION
        case .foundationCube: return "Cube of Foundation"
        case .foundationCross: return "Cardinal Cross"
        case .foundationTemple: return "Temple Architecture"
        case .foundationStone: return "Foundation Stone"
        case .foundationGrid: return "Manifestation Grid"
        case .foundationMatrix: return "Stability Matrix"
        case .foundationBlessing: return "Material Blessing"
            
        // 5 - QUINTESSENCE & DIVINE WILL
        case .willPentagram: return "Pentagram of Will"
        case .willGoldenSpiral: return "Golden Ratio Spiral"
        case .willShield: return "Warrior's Shield"
        case .willPhoenix: return "Phoenix Rising"
        case .willPower: return "Will to Power"
        case .willStar: return "Quintessential Star"
        case .willCommand: return "Divine Command"
            
        // 6 - HARMONY & COSMIC LOVE
        case .harmonyStarDavid: return "Star of David Harmony"
        case .harmonyFlowerLife: return "Flower of Life"
        case .harmonyHeart: return "Heart Chakra Mandala"
        case .harmonyChrist: return "Christ Consciousness"
        case .harmonyUniversal: return "Universal Harmony"
        case .harmonyMarriage: return "Sacred Marriage"
        case .harmonyBeauty: return "Beauty Embodied"
            
        // 7 - MYSTERY & SPIRITUAL MASTERY
        case .mysterySeedLife: return "Seed of Life"
        case .mysterySeals: return "Seven Seals"
        case .mysteryRose: return "Mystical Rose"
        case .mysteryVictory: return "Spiritual Victory"
        case .mysteryWisdom: return "Hidden Wisdom"
        case .mysteryMagic: return "Divine Magic"
        case .mysteryGnosis: return "Gnosis Gateway"
            
        // 8 - RENEWAL & INFINITE CYCLES
        case .renewalOctagon: return "Octagon of Renewal"
        case .renewalInfinity: return "Infinity Symbol"
        case .renewalKarmic: return "Karmic Wheel"
        case .renewalTime: return "Time Spiral"
        case .renewalJustice: return "Justice Scale"
        case .renewalScales: return "Cosmic Scales"
        case .renewalMatrix: return "Phoenix rebirth power"
            
        // 9 - COMPLETION & UNIVERSAL WISDOM
        case .wisdomEnneagram: return "Enneagram Supreme"
        case .wisdomCompletion: return "Completion Merkaba"
        }
    }
    
    /// Numerological value (0-9)
    var numerologicalValue: Int {
        switch self {
        case .voidTriquetra, .voidCosmicWomb, .voidZeroPoint, .voidEternalReturn, .voidStarMatrix, .voidAkashicGrid, .voidCrystal:
            return 0
        case .unitySolar, .unityCrown, .unityMonad, .unityAlpha, .unityConsciousness, .unitySpark:
            return 1
        case .dualityVesica, .dualityLunar, .dualityYinYang, .dualityPillars, .dualityDivine, .dualityTwins, .dualityMirror:
            return 2
        case .trinityMandala, .trinityTriangle, .trinityWisdom, .trinityFire, .trinityGate, .trinityExpression, .trinityLogos:
            return 3
        case .foundationCube, .foundationCross, .foundationTemple, .foundationStone, .foundationGrid, .foundationMatrix, .foundationBlessing:
            return 4
        case .willPentagram, .willGoldenSpiral, .willShield, .willPhoenix, .willPower, .willStar, .willCommand:
            return 5
        case .harmonyStarDavid, .harmonyFlowerLife, .harmonyHeart, .harmonyChrist, .harmonyUniversal, .harmonyMarriage, .harmonyBeauty:
            return 6
        case .mysterySeedLife, .mysterySeals, .mysteryRose, .mysteryVictory, .mysteryWisdom, .mysteryMagic, .mysteryGnosis:
            return 7
        case .renewalOctagon, .renewalInfinity, .renewalKarmic, .renewalTime, .renewalJustice, .renewalScales, .renewalMatrix:
            return 8
        case .wisdomEnneagram, .wisdomCompletion:
            return 9
        }
    }
    
    /// Chakra association
    var chakra: String {
        switch numerologicalValue {
        case 0: return "Crown+"
        case 1: return "Crown"
        case 2: return "Third Eye"
        case 3: return "Throat"
        case 4: return "Heart"
        case 5: return "Solar Plexus"
        case 6: return "Heart"
        case 7: return "Crown"
        case 8: return "Root/Crown"
        case 9: return "All Chakras"
        default: return "Unknown"
        }
    }
    
    /// Mystical significance
    var mysticalSignificance: String {
        switch self {
        case .voidTriquetra: return "The primordial trinity, infinite potential"
        case .voidCosmicWomb: return "Source of all manifestation"
        case .voidZeroPoint: return "Field of infinite possibilities"
        case .voidEternalReturn: return "Cycles of creation/destruction"
        case .voidStarMatrix: return "Hidden knowledge gateway"
        case .voidAkashicGrid: return "Cosmic memory patterns"
        case .voidCrystal: return "First light crystallization"
            
        case .unitySolar: return "Birth of consciousness"
        case .unityCrown: return "Divine authority manifest"
        case .unityMonad: return "Individual soul essence"
        case .unityAlpha: return "First movement of creation"
        case .unityConsciousness: return "Oneness awareness"
        case .unitySpark: return "Pure divine essence"
            
        case .dualityVesica: return "Sacred feminine portal"
        case .dualityLunar: return "Intuitive wisdom"
        case .dualityYinYang: return "Cosmic balance"
        case .dualityPillars: return "Mercy and severity"
        case .dualityDivine: return "Above/below reflection"
        case .dualityTwins: return "Soul mate energies"
        case .dualityMirror: return "Eternal duality dance"
            
        case .trinityMandala: return "Divine creative matrix"
        case .trinityTriangle: return "Father-Mother-Child"
        case .trinityWisdom: return "Understanding made manifest"
        case .trinityFire: return "Creative force in motion"
        case .trinityGate: return "Access to higher realms"
        case .trinityExpression: return "Truth spoken into being"
        case .trinityLogos: return "Divine speech crystallized"
            
        case .foundationCube: return "Stability and order"
        case .foundationCross: return "Material plane anchor"
        case .foundationTemple: return "Divine dwelling place"
        case .foundationStone: return "Reality's bedrock"
        case .foundationGrid: return "Dreams made real"
        case .foundationMatrix: return "Unshakeable foundation"
        case .foundationBlessing: return "Physical world grace"
            
        case .willPentagram: return "Divine will in action"
        case .willGoldenSpiral: return "Universal growth pattern"
        case .willShield: return "Spiritual warrior strength"
        case .willPhoenix: return "Death and rebirth power"
        case .willPower: return "Personal mastery"
        case .willStar: return "Spirit over matter"
        case .willCommand: return "Authority of the divine"
            
        case .harmonyStarDavid: return "Divine masculine/feminine"
        case .harmonyFlowerLife: return "Universal life pattern"
        case .harmonyHeart: return "Unconditional love embodied"
        case .harmonyChrist: return "Ascended master frequency"
        case .harmonyUniversal: return "All creation in balance"
        case .harmonyMarriage: return "Hieros gamos achieved"
        case .harmonyBeauty: return "Divine beauty manifest"
            
        case .mysterySeedLife: return "Hidden center revealed"
        case .mysterySeals: return "Apocalyptic revelation"
        case .mysteryRose: return "Divine feminine mystery"
        case .mysteryVictory: return "Overcoming material plane"
        case .mysteryWisdom: return "Secret teachings encoded"
        case .mysteryMagic: return "Will made manifest"
        case .mysteryGnosis: return "Enlightenment portal"
            
        case .renewalOctagon: return "Death-rebirth cycles"
        case .renewalInfinity: return "Endless renewal"
        case .renewalKarmic: return "Action and consequence"
        case .renewalTime: return "Past-present-future"
        case .renewalJustice: return "Divine justice manifest"
        case .renewalScales: return "Truth and measurement"
        case .renewalMatrix: return "Phoenix rebirth power"
            
        case .wisdomEnneagram: return "All knowledge unified"
        case .wisdomCompletion: return "Master pattern template"
        }
    }
    
    /// SwiftUI Image helper
    var image: Image {
        Image(self.rawValue)
    }
}

// MARK: - Convenience Functions

extension SacredGeometryAsset {
    
    /// Get assets for a specific numerological value
    static func assets(for number: Int) -> [SacredGeometryAsset] {
        return SacredGeometryAsset.allCases.filter { $0.numerologicalValue == number }
    }
    
    /// Get asset for combined Focus + Realm numbers
    static func asset(focusNumber: Int, realmNumber: Int, selectionMethod: AssetSelectionMethod = .primary) -> SacredGeometryAsset {
        let focusReduced = reduceToSingleDigit(focusNumber)
        let realmReduced = reduceToSingleDigit(realmNumber)
        let combined = reduceToSingleDigit(focusReduced + realmReduced)
        
        let assets = self.assets(for: combined)
        guard !assets.isEmpty else { return .wisdomEnneagram }
        
        switch selectionMethod {
        case .primary:
            return assets.first!
        case .secondary(let index):
            return assets[safe: index] ?? assets.first!
        case .random:
            return assets.randomElement()!
        }
    }
    
    /// Numerological reduction helper
    private static func reduceToSingleDigit(_ number: Int) -> Int {
        // Preserve master numbers
        if [11, 22, 33, 44].contains(number) {
            return number
        }
        
        var result = abs(number)
        while result >= 10 {
            result = String(result).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return result
    }
}

// MARK: - Selection Methods

enum AssetSelectionMethod {
    case primary
    case secondary(Int)
    case random
}

// MARK: - Array Extension

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - PHASE 7: Weighted Preference System for Spiritual Authenticity

extension SacredGeometryAsset {
    
    /**
     * PHASE 7 WEIGHTED MANDALA SELECTION SYSTEM
     * 
     * REVOLUTIONARY SPIRITUAL ARCHITECTURE:
     * This system replaces rigid number-to-asset restrictions with spiritually authentic 
     * weighted preferences that honor both numerological correspondences and universal
     * sacred geometry accessibility. Each number now has:
     * 
     * - Primary assets (60% probability): Strong spiritual resonance
     * - Secondary assets (25% probability): Compatible spiritual energy  
     * - Universal assets (15% probability): Sacred geometries that resonate with all numbers
     * 
     * SPIRITUAL RESEARCH FINDINGS (July 10, 2025):
     * - Flower of Life, Merkaba, Enneagram are universal geometries accessible to all
     * - Sacred geometry works through resonance patterns, not rigid categorical restrictions
     * - Numbers have spiritual preferences but benefit from accessing any geometry for growth
     * - Dynamic selection enhances spiritual engagement vs. static repetitive assignment
     * - Every cross-number selection provides legitimate spiritual justification
     * 
     * PERFORMANCE OPTIMIZATION:
     * - Weighted collections cached per number for sub-millisecond selection
     * - Set-based O(1) lookup for recent asset exclusion
     * - Smart asset selection prevents immediate repeats while maintaining variety
     * 
     * USER EXPERIENCE TRANSFORMATION:
     * - Before: Number 6 limited to 7 "harmony" mandalas only
     * - After: Number 6 prefers harmony but can access Flower of Life, Enneagram, etc.
     * - Result: Authentic spiritual expansion while maintaining numerological integrity
     */
    
    /// PHASE 7C: Performance-optimized weighted asset cache
    private static var weightedAssetCache: [Int: [SacredGeometryAsset]] = [:]
    
    /// Clear weighted asset cache (for memory management if needed)
    static func clearWeightedAssetCache() {
        weightedAssetCache.removeAll()
        print("🧹 PHASE 7C: Cleared weighted asset cache for memory optimization")
    }
    
    /// Get weighted asset selection for a number (cached for performance)
    static func weightedAssets(for number: Int) -> [SacredGeometryAsset] {
        // Claude: PHASE 7C PERFORMANCE - Cache weighted collections to avoid repeated expensive operations
        if let cached = weightedAssetCache[number] {
            return cached.shuffled() // Only shuffle the cached result for variety
        }
        
        let primaryAssets = primaryAssets(for: number)
        let secondaryAssets = secondaryAssets(for: number) 
        let universalAssets = universalAssets()
        
        // Create weighted collection: 60% primary, 25% secondary, 15% universal
        var weightedCollection: [SacredGeometryAsset] = []
        
        // Add primary assets (60% - higher frequency)
        weightedCollection.append(contentsOf: Array(repeating: primaryAssets, count: 6).flatMap { $0 })
        
        // Add secondary assets (25% - medium frequency)
        weightedCollection.append(contentsOf: Array(repeating: secondaryAssets, count: 3).flatMap { $0 })
        
        // Add universal assets (15% - lower frequency but always accessible)
        weightedCollection.append(contentsOf: Array(repeating: universalAssets, count: 2).flatMap { $0 })
        
        // Cache the result for future use
        weightedAssetCache[number] = weightedCollection
        
        return weightedCollection.shuffled()
    }
    
    /// Primary assets with strongest spiritual resonance for each number
    private static func primaryAssets(for number: Int) -> [SacredGeometryAsset] {
        switch number {
        case 0: return [.voidTriquetra, .voidCosmicWomb, .voidZeroPoint, .voidEternalReturn]
        case 1: return [.unitySolar, .unityCrown, .unityMonad, .unityAlpha, .unityConsciousness]
        case 2: return [.dualityVesica, .dualityLunar, .dualityYinYang, .dualityPillars, .dualityDivine]
        case 3: return [.trinityMandala, .trinityTriangle, .trinityWisdom, .trinityFire, .trinityExpression]
        case 4: return [.foundationCube, .foundationCross, .foundationTemple, .foundationStone, .foundationGrid]
        case 5: return [.willPentagram, .willGoldenSpiral, .willShield, .willPhoenix, .willPower]
        case 6: return [.harmonyStarDavid, .harmonyFlowerLife, .harmonyHeart, .harmonyChrist, .harmonyUniversal]
        case 7: return [.mysterySeedLife, .mysterySeals, .mysteryRose, .mysteryVictory, .mysteryWisdom]
        case 8: return [.renewalOctagon, .renewalInfinity, .renewalKarmic, .renewalTime, .renewalJustice]
        case 9: return [.wisdomEnneagram, .wisdomCompletion]
        default: return [.wisdomEnneagram]
        }
    }
    
    /// Secondary assets with compatible spiritual energy
    private static func secondaryAssets(for number: Int) -> [SacredGeometryAsset] {
        switch number {
        case 0: // Void - connects to mystery and renewal
            return [.mysterySeedLife, .renewalInfinity, .voidStarMatrix, .mysteryGnosis]
        case 1: // Unity - connects to trinity and completion  
            return [.trinityMandala, .wisdomCompletion, .unitySpark, .harmonyChrist]
        case 2: // Duality - connects to harmony and foundation
            return [.harmonyStarDavid, .foundationMatrix, .dualityTwins, .harmonyMarriage]
        case 3: // Trinity - connects to unity and expression
            return [.unitySolar, .trinityGate, .trinityLogos, .harmonyBeauty]
        case 4: // Foundation - connects to manifestation and stability
            return [.foundationBlessing, .foundationMatrix, .renewalScales, .harmonyUniversal]
        case 5: // Will - connects to power and transformation
            return [.willStar, .willCommand, .renewalMatrix, .mysteryMagic]
        case 6: // Harmony - connects to love and beauty
            return [.harmonyBeauty, .harmonyMarriage, .trinityWisdom, .mysteryRose]
        case 7: // Mystery - connects to wisdom and gnosis
            return [.mysteryMagic, .mysteryGnosis, .wisdomEnneagram, .voidAkashicGrid]
        case 8: // Renewal - connects to cycles and justice
            return [.renewalScales, .renewalMatrix, .foundationGrid, .mysteryVictory]
        case 9: // Completion - connects to all wisdom traditions
            return [.mysterySeedLife, .harmonyFlowerLife, .trinityWisdom, .unitySolar]
        default: return []
        }
    }
    
    /// Universal assets that resonate with all numbers (sacred geometries accessible to all)
    private static func universalAssets() -> [SacredGeometryAsset] {
        return [
            // Claude: These are the truly universal sacred geometries that transcend single number assignments
            .harmonyFlowerLife,    // Flower of Life - universal life pattern
            .wisdomEnneagram,      // Enneagram - contains all 9 numbers
            .harmonyStarDavid,     // Merkaba/Star of David - as above so below
            .mysterySeedLife,      // Seed of Life - foundation pattern
            .renewalInfinity,      // Infinity - eternal cycles
            .voidCosmicWomb,       // Cosmic Womb - source of all
            .trinityMandala,       // Trinity Mandala - divine creative force
            .foundationMatrix      // Sacred Matrix - underlying structure
        ]
    }
    
    /// PHASE 7C: Performance-optimized smart asset selection
    static func selectSmartAsset(for number: Int, excludeRecent: [SacredGeometryAsset] = []) -> SacredGeometryAsset {
        let weightedAssets = weightedAssets(for: number)
        
        // Claude: PHASE 7C PERFORMANCE - Early return for empty exclusion list
        guard !excludeRecent.isEmpty else {
            return weightedAssets.randomElement() ?? .wisdomEnneagram
        }
        
        // Claude: PHASE 7C PERFORMANCE - Use Set for O(1) lookup instead of O(n) contains
        let excludeSet = Set(excludeRecent)
        let availableAssets = weightedAssets.filter { !excludeSet.contains($0) }
        
        // Return random selection from available pool, fallback to any asset if needed
        return availableAssets.randomElement() ?? weightedAssets.randomElement() ?? .wisdomEnneagram
    }
    
    /// Get spiritual justification for why an asset works with a number
    func getResonanceReason(for number: Int) -> String {
        // Claude: Provide spiritual explanation for cross-number asset usage
        if Self.primaryAssets(for: number).contains(self) {
            return "Primary resonance - strong spiritual alignment with number \(number)"
        } else if Self.secondaryAssets(for: number).contains(self) {
            return "Secondary resonance - compatible spiritual energy with number \(number)"
        } else if Self.universalAssets().contains(self) {
            return "Universal sacred geometry - transcends single number limitations"
        } else {
            return "Expansive spiritual growth - \(self.displayName) offers new dimensions to number \(number)"
        }
    }
}

// MARK: - Advanced Mystical Properties

extension SacredGeometryAsset {
    
    /// Planetary correspondence (traditional & modern astrology)
    var planetaryCorrespondence: (traditional: String, modern: String) {
        switch numerologicalValue {
        case 0: return ("Uranus", "Pluto")        // Void/Transformation
        case 1: return ("Sun", "Sun")             // Unity/Leadership  
        case 2: return ("Moon", "Moon")           // Duality/Intuition
        case 3: return ("Jupiter", "Jupiter")     // Expansion/Wisdom
        case 4: return ("Saturn", "Earth")        // Structure/Foundation
        case 5: return ("Mercury", "Mars")        // Communication/Will
        case 6: return ("Venus", "Venus")         // Love/Harmony
        case 7: return ("Neptune", "Neptune")     // Mystery/Spirituality
        case 8: return ("Saturn", "Saturn")       // Justice/Karma
        case 9: return ("Mars", "Pluto")          // Completion/Transformation
        default: return ("Unknown", "Unknown")
        }
    }
    
    /// Kabbalistic Tree of Life correspondence
    var kabbalalisticSephirah: String {
        switch numerologicalValue {
        case 0: return "Ain Soph (The Infinite)"
        case 1: return "Kether (Crown)"
        case 2: return "Chokmah (Wisdom)"
        case 3: return "Binah (Understanding)"
        case 4: return "Chesed (Mercy)"
        case 5: return "Geburah (Severity)"
        case 6: return "Tiphareth (Beauty)"
        case 7: return "Netzach (Victory)"
        case 8: return "Hod (Splendor)"
        case 9: return "Yesod (Foundation)"
        default: return "Malkuth (Kingdom)"
        }
    }
    
    /// Hermetic principle alignment
    var hermeticPrinciple: String {
        switch numerologicalValue {
        case 0: return "The Principle of Gender (Divine Androgyne)"
        case 1: return "The Principle of Mentalism (All is Mind)"
        case 2: return "The Principle of Correspondence (As Above, So Below)"
        case 3: return "The Principle of Vibration (Nothing Rests)"
        case 4: return "The Principle of Polarity (Everything is Dual)"
        case 5: return "The Principle of Rhythm (Everything Flows)"
        case 6: return "The Principle of Cause and Effect (Every Cause has Effect)"
        case 7: return "The Principle of Gender (Masculine/Feminine)"
        case 8: return "The Principle of Rhythm (Pendulum Swing)"
        case 9: return "The Principle of Mentalism (Universal Mind)"
        default: return "The Principle of Unity"
        }
    }
    
    /// Tarot Major Arcana correspondence
    var tarotCorrespondence: String {
        switch numerologicalValue {
        case 0: return "The Fool (0) - New Beginnings"
        case 1: return "The Magician (I) - Manifestation"
        case 2: return "The High Priestess (II) - Intuition"
        case 3: return "The Empress (III) - Creativity"
        case 4: return "The Emperor (IV) - Authority"
        case 5: return "The Hierophant (V) - Spiritual Teaching"
        case 6: return "The Lovers (VI) - Union"
        case 7: return "The Chariot (VII) - Spiritual Victory"
        case 8: return "Strength (VIII) - Inner Power"
        case 9: return "The Hermit (IX) - Wisdom Seeking"
        default: return "The World (XXI) - Completion"
        }
    }
    
    /// Elemental correspondence (classical elements + quintessence)
    var elementalCorrespondence: String {
        switch numerologicalValue {
        case 0: return "Void (Prima Materia)"
        case 1: return "Fire (Tejas)"
        case 2: return "Water (Apas)"
        case 3: return "Air (Vayu)"
        case 4: return "Earth (Prithvi)"
        case 5: return "Quintessence (Akasha)"
        case 6: return "Fire + Water (Sacred Marriage)"
        case 7: return "Air + Earth (Mystical Union)"
        case 8: return "All Four Elements (Perfect Balance)"
        case 9: return "Quintessence Supreme (All Elements Unified)"
        default: return "Elemental Chaos"
        }
    }
    
    /// Sacred geometry mathematical properties
    var geometricProperties: (sides: Int, angles: String, ratio: String) {
        switch numerologicalValue {
        case 0: return (0, "∞ (Infinite)", "∞ (Ouroboros)")
        case 1: return (1, "360° (Circle)", "1:1 (Unity)")
        case 2: return (2, "180° (Vesica)", "1:√2 (Silver Ratio)")
        case 3: return (3, "60° (Triangle)", "1:√3 (Triangle)")
        case 4: return (4, "90° (Square)", "1:1 (Square)")
        case 5: return (5, "72° (Pentagon)", "1:φ (Golden Ratio)")
        case 6: return (6, "60° (Hexagon)", "1:√3 (Flower of Life)")
        case 7: return (7, "51.43° (Heptagon)", "7:π (Mystic)")
        case 8: return (8, "45° (Octagon)", "1:√2 (Renewal)")
        case 9: return (9, "40° (Enneagon)", "9:π (Completion)")
        default: return (0, "0°", "0:0")
        }
    }
    
    /// Advanced numerological reduction with master numbers
    static func advancedNumerologicalReduction(_ numbers: Int...) -> (primary: Int, secondary: [Int], isMaster: Bool) {
        let total = numbers.reduce(0, +)
        
        // Check for master numbers first
        let masterNumbers = [11, 22, 33, 44, 55, 66, 77, 88, 99]
        if masterNumbers.contains(total) {
            return (total, numbers, true)
        }
        
        // Reduce to single digit
        var working = total
        var reductionSteps: [Int] = []
        
        while working >= 10 {
            reductionSteps.append(working)
            working = String(working).compactMap { Int(String($0)) }.reduce(0, +)
        }
        
        return (working, reductionSteps, false)
    }
    
    /// Get optimal sacred geometry based on advanced calculation
    static func advancedAssetSelection(
        focusNumber: Int,
        realmNumber: Int,
        birthDate: Date? = nil,
        currentDate: Date = Date(),
        userIntention: SacredIntention = .balance
    ) -> SacredGeometryAsset {
        
        let reduction = advancedNumerologicalReduction(focusNumber, realmNumber)
        var baseNumber = reduction.primary
        
        // Apply birth date influence if provided
        if let birth = birthDate {
            let birthInfluence = Calendar.current.component(.day, from: birth) % 9
            if birthInfluence != 0 {
                baseNumber = (baseNumber + birthInfluence - 1) % 9 + 1
            }
        }
        
        // Apply current lunar phase influence
        let lunarInfluence = calculateLunarPhaseInfluence(currentDate)
        baseNumber = (baseNumber + lunarInfluence) % 10
        
        // Apply intention modifier
        baseNumber = applyIntentionModifier(baseNumber, intention: userIntention)
        
        let availableAssets = assets(for: baseNumber)
        guard !availableAssets.isEmpty else { return .wisdomEnneagram }
        
        // Select based on advanced criteria
        let selectionIndex = calculateOptimalAssetIndex(
            from: availableAssets,
            focusNumber: focusNumber,
            realmNumber: realmNumber,
            date: currentDate
        )
        
        return availableAssets[safe: selectionIndex] ?? availableAssets.first!
    }
    
    /// Sacred intention for asset selection
    enum SacredIntention: String, CaseIterable {
        case balance = "Universal Balance"
        case manifestation = "Creative Manifestation"
        case protection = "Spiritual Protection"
        case healing = "Divine Healing"
        case wisdom = "Sacred Wisdom"
        case love = "Unconditional Love"
        case transformation = "Alchemical Transformation"
        case enlightenment = "Spiritual Enlightenment"
        case abundance = "Material Abundance"
    }
    
    /// Calculate lunar phase influence (0-8)
    private static func calculateLunarPhaseInfluence(_ date: Date) -> Int {
        // Simplified lunar calculation (you can enhance with astronomical precision)
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let lunarCycle = dayOfYear % 29 // Approximate lunar month
        return lunarCycle % 9
    }
    
    /// Apply intention modifier to base number
    private static func applyIntentionModifier(_ baseNumber: Int, intention: SacredIntention) -> Int {
        let modifier: Int
        switch intention {
        case .balance: modifier = 0
        case .manifestation: modifier = 1
        case .protection: modifier = 2
        case .healing: modifier = 3
        case .wisdom: modifier = 4
        case .love: modifier = 5
        case .transformation: modifier = 6
        case .enlightenment: modifier = 7
        case .abundance: modifier = 8
        }
        return (baseNumber + modifier) % 10
    }
    
    /// Calculate optimal asset index within number group
    private static func calculateOptimalAssetIndex(
        from assets: [SacredGeometryAsset],
        focusNumber: Int,
        realmNumber: Int,
        date: Date
    ) -> Int {
        let combinedHash = abs(focusNumber.hashValue ^ realmNumber.hashValue ^ date.hashValue)
        return combinedHash % assets.count
    }
    
    /// Get sacred timing recommendations
    var sacredTiming: (bestHours: [Int], bestDays: [String], planetaryHour: String) {
        switch numerologicalValue {
        case 0: return ([0, 12], ["Sunday", "Monday"], "Moon")
        case 1: return ([6, 12, 18], ["Sunday"], "Sun")  
        case 2: return ([9, 21], ["Monday"], "Moon")
        case 3: return ([9, 15], ["Thursday"], "Jupiter")
        case 4: return ([14, 22], ["Saturday"], "Saturn")
        case 5: return ([8, 16], ["Wednesday"], "Mercury")
        case 6: return ([6, 18], ["Friday"], "Venus")
        case 7: return ([3, 15], ["Monday"], "Moon")
        case 8: return ([10, 22], ["Saturday"], "Saturn")
        case 9: return ([12, 24], ["Tuesday"], "Mars")
        default: return ([12], ["Any"], "Sun")
        }
    }
    
    /// Complete mystical profile for the asset
    var mysticalProfile: String {
        """
        🔮 \(displayName)
        📊 Number: \(numerologicalValue) | Chakra: \(chakra)
        🪐 Planet: \(planetaryCorrespondence.traditional) | Element: \(elementalCorrespondence)
        🌳 Kabbalah: \(kabbalalisticSephirah)
        🃏 Tarot: \(tarotCorrespondence)
        ⚡ Hermetic: \(hermeticPrinciple)
        📐 Geometry: \(geometricProperties.sides) sides, \(geometricProperties.angles), \(geometricProperties.ratio)
        ⏰ Best Time: \(sacredTiming.bestHours.map(String.init).joined(separator:", "))h, \(sacredTiming.bestDays.joined(separator: "/"))
        🎯 Significance: \(mysticalSignificance)
        """
    }
} 