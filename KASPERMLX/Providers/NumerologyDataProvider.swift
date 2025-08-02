/**
 * Numerology Data Provider for KASPER MLX
 * 
 * Provides async access to numerological data including life path numbers,
 * current realm numbers, focus numbers, and sacred correspondences.
 */

import Foundation

actor NumerologyDataProvider: SpiritualDataProvider {
    
    // MARK: - Properties
    
    let id = "numerology"
    private var contextCache: [KASPERFeature: ProviderContext] = [:]
    
    // References to existing managers
    private weak var realmNumberManager: RealmNumberManager?
    private weak var focusNumberManager: FocusNumberManager?
    
    // MARK: - Initialization
    
    init(
        realmNumberManager: RealmNumberManager? = nil,
        focusNumberManager: FocusNumberManager? = nil
    ) {
        self.realmNumberManager = realmNumberManager
        self.focusNumberManager = focusNumberManager
    }
    
    // MARK: - SpiritualDataProvider Implementation
    
    func isDataAvailable() async -> Bool {
        // Check if we have access to core numerology data
        return realmNumberManager != nil && focusNumberManager != nil
    }
    
    func provideContext(for feature: KASPERFeature) async throws -> ProviderContext {
        // Check cache first
        if let cached = contextCache[feature], !cached.isExpired {
            print("🔢 KASPER MLX: Using cached numerology context for \(feature)")
            return cached
        }
        
        // Build context based on feature needs
        let context = try await buildContext(for: feature)
        
        // Cache the context
        contextCache[feature] = context
        
        return context
    }
    
    func clearCache() async {
        contextCache.removeAll()
        print("🔢 KASPER MLX: Numerology provider cache cleared")
    }
    
    // MARK: - Private Methods
    
    private func buildContext(for feature: KASPERFeature) async throws -> ProviderContext {
        var data: [String: Any] = [:]
        
        // Get core numbers from managers
        let realmNumber: Int
        let focusNumber: Int
        
        if let realmManager = realmNumberManager {
            realmNumber = await MainActor.run {
                realmManager.currentRealmNumber
            }
        } else {
            realmNumber = 1
        }
        
        if let focusManager = focusNumberManager {
            focusNumber = await MainActor.run {
                focusManager.selectedFocusNumber
            }
        } else {
            focusNumber = 3
        }
        
        // Get user profile if available
        let userProfile = await getUserProfile()
        
        switch feature {
        case .journalInsight:
            // Journal needs personal numbers and current vibration
            data["focusNumber"] = focusNumber
            data["realmNumber"] = realmNumber
            data["personalVibration"] = getPersonalVibration(focus: focusNumber, realm: realmNumber)
            data["numericalGuidance"] = getNumericalGuidance(for: focusNumber)
            
            if let profile = userProfile {
                data["lifePathNumber"] = profile.lifePathNumber
                data["expressionNumber"] = profile.expressionNumber
                data["soulUrgeNumber"] = profile.soulUrgeNumber
            }
            
        case .dailyCard:
            // Daily card needs today's active numbers
            data["realmNumber"] = realmNumber
            data["focusNumber"] = focusNumber
            data["dayNumber"] = getDayNumber()
            data["personalYear"] = getPersonalYear(userProfile: userProfile)
            data["universalDay"] = getUniversalDay()
            
        case .sanctumGuidance:
            // Sanctum needs complete numerological profile
            data["realmNumber"] = realmNumber
            data["focusNumber"] = focusNumber
            data["masterNumbers"] = getMasterNumbers(userProfile: userProfile)
            data["karmaNumbers"] = getKarmaNumbers(userProfile: userProfile)
            data["pinnacleNumbers"] = getPinnacleNumbers(userProfile: userProfile)
            
        case .focusIntention:
            // Focus needs intention-specific data
            data["focusNumber"] = focusNumber
            data["focusArchetype"] = getFocusArchetype(focusNumber)
            data["focusEnergy"] = getFocusEnergy(focusNumber)
            data["supportingNumbers"] = getSupportingNumbers(focusNumber)
            
        case .realmInterpretation:
            // Realm needs environmental numerology
            data["realmNumber"] = realmNumber
            data["realmArchetype"] = getRealmArchetype(realmNumber)
            data["realmChallenges"] = getRealmChallenges(realmNumber)
            data["realmOpportunities"] = getRealmOpportunities(realmNumber)
            
        case .matchCompatibility:
            // Match needs compatibility calculations
            if let profile = userProfile {
                data["lifePathNumber"] = profile.lifePathNumber
                data["expressionNumber"] = profile.expressionNumber
                data["compatibilityFactors"] = getCompatibilityFactors(profile)
            }
            data["currentVibration"] = getCurrentVibration(focus: focusNumber, realm: realmNumber)
            
        case .cosmicTiming:
            // Cosmic timing needs cyclical numbers
            data["personalDay"] = getPersonalDay(userProfile: userProfile)
            data["personalMonth"] = getPersonalMonth(userProfile: userProfile)
            data["personalYear"] = getPersonalYear(userProfile: userProfile)
            data["universalYear"] = getUniversalYear()
        }
        
        // Add common numerological metadata
        data["timestamp"] = Date().timeIntervalSince1970
        data["dataSource"] = "NumerologyProviders"
        data["calculationDate"] = getCurrentNumerologyDate()
        
        return ProviderContext(
            providerId: id,
            feature: feature,
            data: data,
            cacheExpiry: getCacheExpiry(for: feature)
        )
    }
    
    // MARK: - Helper Methods
    
    private func getUserProfile() async -> UserProfile? {
        // Try to get cached user profile
        await MainActor.run {
            guard let userID = AuthenticationManager.shared.userID else { return nil }
            return UserProfileService.shared.getCurrentUserProfileFromUserDefaults(for: userID)
        }
    }
    
    private func getPersonalVibration(focus: Int, realm: Int) -> Int {
        // Combine focus and realm for current personal vibration
        return reduceToSingleDigit(focus + realm)
    }
    
    private func getNumericalGuidance(for number: Int) -> String {
        let guidance = [
            1: "Leadership and new beginnings flow through you",
            2: "Cooperation and harmony guide your path",
            3: "Creative expression illuminates your journey",
            4: "Practical foundation-building serves your purpose",
            5: "Freedom and adventure call your spirit",
            6: "Nurturing and service fulfill your heart",
            7: "Spiritual wisdom deepens your understanding",
            8: "Material mastery aligns with your goals",
            9: "Humanitarian service completes your cycle"
        ]
        return guidance[number] ?? "Divine guidance flows through your unique path"
    }
    
    private func getDayNumber() -> Int {
        let day = Calendar.current.component(.day, from: Date())
        return reduceToSingleDigit(day)
    }
    
    private func getUniversalDay() -> Int {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let sum = (components.day ?? 0) + (components.month ?? 0) + (components.year ?? 0)
        return reduceToSingleDigit(sum)
    }
    
    private func getPersonalYear(userProfile: UserProfile?) -> Int? {
        guard let profile = userProfile else { return nil }
        
        let birthDate = profile.birthdate
        
        let birthComponents = Calendar.current.dateComponents([.day, .month], from: birthDate)
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let sum = (birthComponents.day ?? 0) + (birthComponents.month ?? 0) + currentYear
        return reduceToSingleDigit(sum)
    }
    
    private func getPersonalDay(userProfile: UserProfile?) -> Int? {
        guard let personalYear = getPersonalYear(userProfile: userProfile) else { return nil }
        let today = Calendar.current.dateComponents([.day, .month], from: Date())
        let sum = personalYear + (today.day ?? 0) + (today.month ?? 0)
        return reduceToSingleDigit(sum)
    }
    
    private func getPersonalMonth(userProfile: UserProfile?) -> Int? {
        guard let personalYear = getPersonalYear(userProfile: userProfile) else { return nil }
        let currentMonth = Calendar.current.component(.month, from: Date())
        return reduceToSingleDigit(personalYear + currentMonth)
    }
    
    private func getUniversalYear() -> Int {
        let year = Calendar.current.component(.year, from: Date())
        return reduceToSingleDigit(year)
    }
    
    private func getMasterNumbers(userProfile: UserProfile?) -> [Int] {
        guard let profile = userProfile else { return [] }
        var masterNumbers: [Int] = []
        
        if isMasterNumber(profile.lifePathNumber) {
            masterNumbers.append(profile.lifePathNumber)
        }
        if let expression = profile.expressionNumber, isMasterNumber(expression) {
            masterNumbers.append(expression)
        }
        if let soulUrge = profile.soulUrgeNumber, isMasterNumber(soulUrge) {
            masterNumbers.append(soulUrge)
        }
        
        return masterNumbers
    }
    
    private func getKarmaNumbers(userProfile: UserProfile?) -> [Int] {
        // Simplified karma number detection
        return [13, 14, 16, 19]
    }
    
    private func getPinnacleNumbers(userProfile: UserProfile?) -> [Int] {
        // Simplified pinnacle calculation
        guard let profile = userProfile else { return [] }
        return [profile.lifePathNumber, (profile.lifePathNumber + 1) % 9 + 1]
    }
    
    private func getFocusArchetype(_ number: Int) -> String {
        let archetypes = [
            1: "The Leader",
            2: "The Diplomat",
            3: "The Creative",
            4: "The Builder",
            5: "The Explorer",
            6: "The Nurturer",
            7: "The Mystic",
            8: "The Executive",
            9: "The Humanitarian"
        ]
        return archetypes[number] ?? "The Unique Path"
    }
    
    private func getFocusEnergy(_ number: Int) -> String {
        let energies = [
            1: "pioneering",
            2: "harmonizing",
            3: "expressing",
            4: "building",
            5: "expanding",
            6: "caring",
            7: "contemplating",
            8: "achieving",
            9: "completing"
        ]
        return energies[number] ?? "flowing"
    }
    
    private func getSupportingNumbers(_ number: Int) -> [Int] {
        // Numbers that harmonize with the focus number
        switch number {
        case 1: return [3, 5, 9]
        case 2: return [4, 6, 8]
        case 3: return [1, 5, 7]
        case 4: return [2, 6, 8]
        case 5: return [1, 3, 7]
        case 6: return [2, 4, 9]
        case 7: return [3, 5, 9]
        case 8: return [2, 4, 6]
        case 9: return [1, 6, 7]
        default: return []
        }
    }
    
    private func getRealmArchetype(_ number: Int) -> String {
        return getFocusArchetype(number) // Same archetype system
    }
    
    private func getRealmChallenges(_ number: Int) -> [String] {
        let challenges = [
            1: ["impatience", "aggression", "isolation"],
            2: ["indecision", "over-sensitivity", "dependency"],
            3: ["scattered energy", "superficiality", "criticism"],
            4: ["rigidity", "limitation", "stubbornness"],
            5: ["restlessness", "irresponsibility", "addiction"],
            6: ["martyrdom", "interference", "perfectionism"],
            7: ["isolation", "skepticism", "depression"],
            8: ["materialism", "workaholism", "power struggles"],
            9: ["emotional extremes", "resentment", "martyrdom"]
        ]
        return challenges[number] ?? ["finding balance"]
    }
    
    private func getRealmOpportunities(_ number: Int) -> [String] {
        let opportunities = [
            1: ["leadership", "innovation", "independence"],
            2: ["cooperation", "diplomacy", "peace-making"],
            3: ["creativity", "communication", "inspiration"],
            4: ["organization", "stability", "practical wisdom"],
            5: ["freedom", "adventure", "progressive thinking"],
            6: ["healing", "service", "family harmony"],
            7: ["spiritual growth", "research", "inner wisdom"],
            8: ["material success", "authority", "organization"],
            9: ["humanitarian service", "universal love", "completion"]
        ]
        return opportunities[number] ?? ["self-discovery"]
    }
    
    private func getCompatibilityFactors(_ profile: UserProfile) -> [String: Any] {
        return [
            "lifePathCompatibility": getLifePathCompatibility(profile.lifePathNumber),
            "expressionHarmony": getExpressionHarmony(profile.expressionNumber),
            "soulUrgeResonance": getSoulUrgeResonance(profile.soulUrgeNumber)
        ]
    }
    
    private func getLifePathCompatibility(_ lifePath: Int) -> [Int] {
        // Compatible life path numbers
        switch lifePath {
        case 1: return [3, 5, 6]
        case 2: return [4, 6, 8]
        case 3: return [1, 5, 7]
        case 4: return [2, 6, 8]
        case 5: return [1, 3, 7]
        case 6: return [1, 2, 4, 8, 9]
        case 7: return [3, 5, 9]
        case 8: return [2, 4, 6]
        case 9: return [6, 7]
        default: return []
        }
    }
    
    private func getExpressionHarmony(_ expression: Int?) -> String {
        guard let expr = expression else { return "unknown" }
        return expr % 3 == 0 ? "harmonious" : "dynamic"
    }
    
    private func getSoulUrgeResonance(_ soulUrge: Int?) -> String {
        guard let soul = soulUrge else { return "unknown" }
        return soul <= 5 ? "earthly" : "spiritual"
    }
    
    private func getCurrentVibration(focus: Int, realm: Int) -> Int {
        return reduceToSingleDigit(focus + realm)
    }
    
    private func getCurrentNumerologyDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func getCacheExpiry(for feature: KASPERFeature) -> TimeInterval {
        switch feature {
        case .dailyCard, .cosmicTiming:
            return 3600 // 1 hour for time-sensitive features
        case .focusIntention, .realmInterpretation:
            return 1800 // 30 minutes for dynamic features
        default:
            return 300  // 5 minutes default
        }
    }
    
    // MARK: - Utility Methods
    
    private func reduceToSingleDigit(_ number: Int) -> Int {
        let absNumber = abs(number)
        if absNumber < 10 || isMasterNumber(absNumber) {
            return absNumber
        }
        let sum = String(absNumber).compactMap { Int(String($0)) }.reduce(0, +)
        return reduceToSingleDigit(sum)
    }
    
    private func isMasterNumber(_ number: Int) -> Bool {
        return [11, 22, 33, 44].contains(number)
    }
}