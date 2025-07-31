//
//  CosmicHUDWidgetLiveActivity.swift
//  CosmicHUDWidget
//
//  Created by Corey Davis on 7/30/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

// Import shared types from main app
// Note: CosmicHUDTypes.swift must be added to Widget Extension target in Xcode

// MARK: - Cosmic HUD Live Activity Widget
/// Claude: The main Live Activity Widget that displays in Dynamic Island
/// Provides both compact and expanded views of spiritual awareness data
struct CosmicHUDWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CosmicHUDWidgetAttributes.self) { context in
            // MARK: - Lock Screen View
            /// Claude: Lock screen and notification banner display
            lockScreenView(context: context)
            
        } dynamicIsland: { context in
            // MARK: - Dynamic Island Configuration  
            /// Claude: The revolutionary omnipresent spiritual awareness display
            DynamicIsland {
                // MARK: - Expanded State Regions
                /// Claude: When user taps to expand the Dynamic Island
                
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text("👑")
                                .font(.title2)
                            Text("\(context.state.rulerNumber)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        Text("Ruler")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack {
                            Text("🔮")
                            Text("\(context.state.realmNumber)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        Text("Realm")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 6) {
                        // Just show the colorful aspect symbols - no redundant text
                        HStack(spacing: 4) {
                            ForEach(parseAspectForColors(context.state.aspectDisplay), id: \.self) { component in
                                Text(component.symbol)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(component.color)
                            }
                        }
                        
                        Text("Active Aspect")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .opacity(0.7)
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 4) {
                        // More meaningful spiritual guidance with more room now
                        Text(generateStructuredInsight(
                            ruler: context.state.rulerNumber,
                            realm: context.state.realmNumber,
                            aspect: context.state.aspectDisplay,
                            element: context.state.element
                        ))
                            .font(.caption)  // Slightly bigger font now that we have more space
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .lineSpacing(1) // More comfortable spacing
                            .minimumScaleFactor(0.8) // Less aggressive scaling needed
                    }
                    .padding(.horizontal, 8)
                }
                
            } compactLeading: {
                // MARK: - Compact Leading (Crown + Ruler + Aspects)
                HStack(spacing: 2) {
                    HStack(spacing: 1) {
                        Text("👑")
                            .font(.body)
                            .fontWeight(.bold)
                        Text("\(context.state.rulerNumber)")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(getNumberColor(context.state.rulerNumber))
                    }
                    
                    ForEach(parseAspectForColors(context.state.aspectDisplay), id: \.self) { component in
                        Text(component.symbol)
                            .font(.title3) // Bigger than .body
                            .fontWeight(.bold)
                            .foregroundColor(component.color)
                            .baselineOffset(0) // Ensure same baseline as ruler number
                    }
                }
                
            } compactTrailing: {
                // MARK: - Compact Trailing (Realm Number for more numerology focus)  
                Text("🔮\(context.state.realmNumber)")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                
            } minimal: {
                // MARK: - Minimal State (Crown + Ruler)
                Text("👑\(context.state.rulerNumber)")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .widgetURL(URL(string: "vybe://cosmic-hud"))
            .keylineTint(Color.purple)
        }
    }
    
    // MARK: - Lock Screen View
    /// Claude: Lock screen and notification banner display
    @ViewBuilder
    private func lockScreenView(context: ActivityViewContext<CosmicHUDWidgetAttributes>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("🌌 Cosmic Awareness")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(formatUpdateTime(context.state.lastUpdate))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Main content
            HStack(spacing: 12) {
                // Ruler number
                VStack(spacing: 4) {
                    HStack {
                        Text("👑")
                        Text("\(context.state.rulerNumber)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Text("Ruler")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                // Realm number
                VStack(spacing: 4) {
                    HStack {
                        Text("🔮")
                        Text("\(context.state.realmNumber)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Text("Realm")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                // Active aspect
                VStack(spacing: 4) {
                    Text(context.state.aspectDisplay)
                        .font(.title3)
                        .fontWeight(.medium)
                    Text("Aspect")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                    .frame(height: 30)
                
                // Element
                VStack(spacing: 4) {
                    Text(context.state.element)
                        .font(.title2)
                    Text("Element")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Comprehensive Lock Screen Insight - we have more space here!
            VStack(spacing: 2) {
                Text("✨ Personal Cosmic Guidance")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
                
                Text(generateLockScreenInsight(
                    ruler: context.state.rulerNumber,
                    realm: context.state.realmNumber,
                    aspect: context.state.aspectDisplay,
                    element: context.state.element
                ))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }
            .padding(.top, 4)
        }
        .padding()
        .activityBackgroundTint(Color.black)
        .activitySystemActionForegroundColor(Color.white)
    }
    
    // MARK: - Helper Methods
    
    /// Claude: Formats the last update time for display
    private func formatUpdateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// Claude: Converts planet symbols to readable names for aspect explanation
    private func formatAspectExplanation(_ aspectDisplay: String) -> String {
        // Simple symbol to name mapping for common planets
        let symbolMap: [String: String] = [
            "☉": "Sun", "☽": "Moon", "☿": "Mercury", "♀": "Venus", 
            "♂": "Mars", "♃": "Jupiter", "♄": "Saturn", "♅": "Uranus",
            "♆": "Neptune", "♇": "Pluto"
        ]
        
        let aspectMap: [String: String] = [
            "☌": "conjunct", "☍": "opposite", "△": "trine", 
            "□": "square", "⚹": "sextile", "⚻": "quincunx"
        ]
        
        var explanation = aspectDisplay
        for (symbol, name) in symbolMap {
            explanation = explanation.replacingOccurrences(of: symbol, with: name)
        }
        for (symbol, name) in aspectMap {
            explanation = explanation.replacingOccurrences(of: symbol, with: name)
        }
        
        return explanation.isEmpty ? "Cosmic alignment" : explanation
    }
    
    /// Claude: Generates comprehensive insight combining numerology, astrology, and elements
    private func generateComprehensiveInsight(ruler: Int, aspect: String, element: String) -> String {
        let rulerInsight = getRulerInsight(ruler)
        let elementInsight = getElementInsight(element)
        
        return "Ruler \(ruler) \(rulerInsight) while \(elementInsight)"
    }
    
    /// Claude: More compact insight for Dynamic Island space constraints
    private func generateCompactInsight(ruler: Int, element: String) -> String {
        let rulerAction = getCompactRulerAction(ruler)
        let elementFlow = getCompactElementFlow(element)
        
        return "\(rulerAction) • \(elementFlow)"
    }
    
    private func getCompactRulerAction(_ number: Int) -> String {
        switch number {
        case 1: return "Leading with power"
        case 2: return "Harmonizing energy"
        case 3: return "Creating beauty"
        case 4: return "Building stability"
        case 5: return "Seeking freedom"
        case 6: return "Nurturing souls"
        case 7: return "Deepening wisdom"
        case 8: return "Manifesting success"
        case 9: return "Serving all"
        default: return "Channeling cosmos"
        }
    }
    
    private func getCompactElementFlow(_ element: String) -> String {
        switch element {
        case "🔥": return "Fire transforms"
        case "🌱": return "Earth grounds"
        case "💨": return "Air expands"
        case "💧": return "Water flows"
        default: return "Elements align"
        }
    }
    
    /// Claude: Generate meaningful integrated insight for Dynamic Island
    private func generateStructuredInsight(ruler: Int, realm: Int, aspect: String, element: String) -> String {
        // Extract the aspect type and planets for deeper insight
        let aspectType = extractAspectTypeFromDisplay(aspect)
        let planets = extractPlanetsFromDisplay(aspect)
        
        // Build integrated numerology + astrology guidance
        let rulerEssence = getRulerEssence(ruler)
        let numerologyAstrology = getCombinedNumerologyAstrology(ruler, aspectType, planets: planets)
        
        // Create integrated spiritual guidance in exactly 2 lines
        return "\(rulerEssence)\n\(numerologyAstrology)"
    }
    
    private func getRulerEssence(_ number: Int) -> String {
        switch number {
        case 1: return "Lead boldly"
        case 2: return "Harmonize deeply"
        case 3: return "Create joyfully"
        case 4: return "Build steadily"
        case 5: return "Explore freely"
        case 6: return "Love purely"
        case 7: return "Seek wisdom"
        case 8: return "Manifest power"
        case 9: return "Serve all"
        default: return "Channel cosmos"
        }
    }
    
    private func getAspectMeaning(_ type: String, planets: [String]) -> String {
        switch type {
        case "trine": return "harmonious flow"
        case "square": return "creative tension"
        case "conjunction": return "unified force"
        case "opposition": return "balanced awareness"
        case "sextile": return "gentle opportunity"
        case "quincunx": return "divine adjustment"
        default: return "cosmic alignment"
        }
    }
    
    private func getAspectMeaningWithPlanets(_ type: String, planets: [String]) -> String {
        // Get the first two planets for the aspect description
        let planet1 = planets.first ?? "cosmic"
        let planet2 = planets.count > 1 ? planets[1] : "energy"
        
        switch type {
        case "trine": return "\(planet1) harmonizes \(planet2)"
        case "square": return "\(planet1) challenges \(planet2)"
        case "conjunction": return "\(planet1) unites \(planet2)"
        case "opposition": return "\(planet1) balances \(planet2)"
        case "sextile": return "\(planet1) supports \(planet2)"
        case "quincunx": return "\(planet1) adjusts \(planet2)"
        default: return "\(planet1) aligns \(planet2)"
        }
    }
    
    private func getElementalWisdom(_ element: String) -> String {
        switch element {
        case "🔥": return "with fire"
        case "🌱": return "with earth"
        case "💨": return "with air"
        case "💧": return "with water"
        default: return "with balance"
        }
    }
    
    private func extractAspectTypeFromDisplay(_ display: String) -> String {
        if display.contains("△") { return "trine" }
        if display.contains("□") { return "square" }
        if display.contains("☌") { return "conjunction" }
        if display.contains("☍") { return "opposition" }
        if display.contains("⚹") { return "sextile" }
        if display.contains("⚻") { return "quincunx" }
        return "unknown"
    }
    
    private func extractPlanetsFromDisplay(_ display: String) -> [String] {
        var planets: [String] = []
        if display.contains("☉") { planets.append("Sun") }
        if display.contains("☽") { planets.append("Moon") }
        if display.contains("☿") { planets.append("Mercury") }
        if display.contains("♀") { planets.append("Venus") }
        if display.contains("♂") { planets.append("Mars") }
        if display.contains("♃") { planets.append("Jupiter") }
        if display.contains("♄") { planets.append("Saturn") }
        if display.contains("♅") { planets.append("Uranus") }
        if display.contains("♆") { planets.append("Neptune") }
        if display.contains("♇") { planets.append("Pluto") }
        return planets
    }
    
    // MARK: - Enhanced Insight Functions
    
    private func getSpecificRulerAction(_ number: Int) -> String {
        switch number {
        case 1: return "Leadership breakthrough unfolds"
        case 2: return "Harmony guides your decisions"
        case 3: return "Creative expression flows"
        case 4: return "Foundation building strengthens"
        case 5: return "Freedom calls for change"
        case 6: return "Nurturing love transforms"
        case 7: return "Deep wisdom emerges"
        case 8: return "Manifestation power peaks"
        case 9: return "Completion cycle fulfills"
        default: return "Cosmic energy flows"
        }
    }
    
    private func getSpecificPlanetaryGuidance(_ aspectType: String, planets: [String]) -> String {
        guard planets.count >= 2 else {
            return "Cosmic energies support your path"
        }
        
        let planet1 = planets[0]
        let planet2 = planets[1]
        
        // Use proper astrological aspect terminology
        switch aspectType {
        case "trine": 
            return "\(planet1) trine \(planet2) creates flowing energy"
        case "square": 
            return "\(planet1) square \(planet2) builds dynamic tension"
        case "conjunction": 
            return "\(planet1) conjunct \(planet2) unites their powers"
        case "opposition": 
            return "\(planet1) opposite \(planet2) seeks perfect balance"
        case "sextile": 
            return "\(planet1) sextile \(planet2) opens opportunities"
        case "quincunx": 
            return "\(planet1) quincunx \(planet2) requires adjustment"
        default: 
            return "\(planet1) aspects \(planet2) in cosmic harmony"
        }
    }
    
    private func getElementalApplication(_ element: String) -> String {
        switch element {
        case "🔥": return "Apply passionate fire energy to your goals"
        case "🌱": return "Ground your ideas in practical earth action"
        case "💨": return "Let air element expand your thinking"
        case "💧": return "Trust water's intuitive flow"
        default: return "Balance all elemental energies"
        }
    }
    
    private func getCombinedPlanetaryElemental(_ aspectType: String, planets: [String], element: String) -> String {
        guard planets.count >= 2 else {
            return "Cosmic \(getElementName(element)) energy flows"
        }
        
        let planet1 = planets[0]
        let planet2 = planets[1]
        let elementName = getElementName(element)
        
        // Keep it super short to prevent cutoffs
        switch aspectType {
        case "trine": 
            return "\(planet1) trine \(planet2) flows \(elementName)"
        case "square": 
            return "\(planet1) square \(planet2) transforms \(elementName)"
        case "conjunction": 
            return "\(planet1) conjunct \(planet2) powers \(elementName)"
        case "opposition": 
            return "\(planet1) opposite \(planet2) balances \(elementName)"
        case "sextile": 
            return "\(planet1) sextile \(planet2) opens \(elementName)"
        case "quincunx": 
            return "\(planet1) quincunx \(planet2) adjusts \(elementName)"
        default: 
            return "\(planet1) aspects \(planet2) with \(elementName)"
        }
    }
    
    private func getElementName(_ element: String) -> String {
        switch element {
        case "🔥": return "fire"
        case "🌱": return "earth"
        case "💨": return "air"
        case "💧": return "water"
        default: return "cosmic"
        }
    }
    
    private func getCombinedNumerologyAstrology(_ ruler: Int, _ aspectType: String, planets: [String]) -> String {
        guard planets.count >= 2 else {
            return "\(ruler) channels cosmic wisdom"
        }
        
        let planet1 = planets[0]
        let planet2 = planets[1]
        let planet1Energy = getPlanetEnergy(planet1)
        let planet2Energy = getPlanetEnergy(planet2)
        let aspectEnergy = getAspectEnergy(aspectType)
        
        // Make it more compact but keep meaning
        return "\(ruler) \(aspectEnergy) \(planet1Energy) & \(planet2Energy)"
    }
    
    private func getRulerWord(_ number: Int) -> String {
        switch number {
        case 1: return "One"
        case 2: return "Two"
        case 3: return "Three"
        case 4: return "Four"
        case 5: return "Five"
        case 6: return "Six"
        case 7: return "Seven"
        case 8: return "Eight"
        case 9: return "Nine"
        default: return "Cosmic"
        }
    }
    
    private func getPlanetaryMeaning(_ planet1: String, _ planet2: String, _ aspectType: String) -> String {
        // Ultra-concise for space constraints
        let aspectEnergy = getAspectEnergy(aspectType)
        
        return "\(aspectEnergy) \(planet1)-\(planet2) energy"
    }
    
    private func getPlanetEnergy(_ planet: String) -> String {
        switch planet {
        case "Sun": return "core identity"
        case "Moon": return "emotional needs"
        case "Mercury": return "mental clarity"
        case "Venus": return "love values"
        case "Mars": return "action drive"
        case "Jupiter": return "growth wisdom"
        case "Saturn": return "life structure"
        case "Uranus": return "breakthrough change"
        case "Neptune": return "spiritual vision"
        case "Pluto": return "deep transformation"
        default: return "cosmic flow"
        }
    }
    
    private func getAspectEnergy(_ aspectType: String) -> String {
        switch aspectType {
        case "trine": return "harmonizes"
        case "square": return "challenges"
        case "conjunction": return "merges"
        case "opposition": return "balances"
        case "sextile": return "supports"
        case "quincunx": return "adjusts"
        default: return "connects"
        }
    }
    
    private func getRulerNumerologyMeaning(_ number: Int) -> String {
        switch number {
        case 1: return "leads breakthrough"
        case 2: return "harmonizes balance"
        case 3: return "creates expression"
        case 4: return "builds foundation"
        case 5: return "seeks freedom"
        case 6: return "nurtures love"
        case 7: return "deepens wisdom"
        case 8: return "manifests power"
        case 9: return "completes cycle"
        default: return "channels energy"
        }
    }
    
    /// Claude: Generate comprehensive insight for lock screen with exactly 2 lines
    private func generateLockScreenInsight(ruler: Int, realm: Int, aspect: String, element: String) -> String {
        let aspectType = extractAspectTypeFromDisplay(aspect)
        let planets = extractPlanetsFromDisplay(aspect)
        
        // Create 2-line lock screen guidance that integrates numerology
        let rulerGuidance = getDetailedRulerGuidance(ruler)
        let numerologyAstrologyGuidance = getLockScreenNumerologyAstrology(ruler, aspectType, planets: planets)
        
        return "\(rulerGuidance)\n\(numerologyAstrologyGuidance)"
    }
    
    private func getPlanetaryInfluence(_ planets: [String], aspectType: String) -> String {
        guard planets.count >= 2 else {
            return "Cosmic forces align"
        }
        
        let planet1 = planets[0]
        let planet2 = planets[1]
        
        switch aspectType {
        case "trine": return "\(planet1)'s energy flows harmoniously with \(planet2)."
        case "square": return "\(planet1)'s tension with \(planet2) sparks growth."
        case "conjunction": return "\(planet1) and \(planet2) unite their powers."
        case "opposition": return "\(planet1) and \(planet2) seek balance."
        case "sextile": return "\(planet1) gently supports \(planet2)'s gifts."
        case "quincunx": return "\(planet1) adjusts to \(planet2)'s wisdom."
        default: return "\(planet1) and \(planet2) dance together."
        }
    }
    
    private func getElementAdvice(_ element: String) -> String {
        switch element {
        case "🔥": return "Let fire transform"
        case "🌱": return "Let earth ground"
        case "💨": return "Let air expand"
        case "💧": return "Let water flow"
        default: return "Find balance"
        }
    }
    
    // MARK: - Detailed Lock Screen Functions
    
    private func getDetailedRulerGuidance(_ number: Int) -> String {
        switch number {
        case 1: return "Your leadership energy is at its peak."
        case 2: return "Cooperation and balance guide you today."
        case 3: return "Creative expression opens new doors."
        case 4: return "Methodical planning yields lasting results."
        case 5: return "Change and adventure call your name."
        case 6: return "Your caring nature heals and nurtures."
        case 7: return "Deep reflection reveals hidden truths."
        case 8: return "Material success follows focused effort."
        case 9: return "Completion and wisdom merge beautifully."
        default: return "Cosmic forces amplify your potential."
        }
    }
    
    private func getDetailedPlanetaryMessage(_ aspectType: String, planets: [String]) -> String {
        guard planets.count >= 2 else {
            return "Universal energies support your journey."
        }
        
        let planet1 = planets[0]
        let planet2 = planets[1]
        
        switch aspectType {
        case "trine": 
            return "\(planet1) and \(planet2) create harmonious opportunities for growth."
        case "square": 
            return "\(planet1)'s challenge with \(planet2) builds character and strength."
        case "conjunction": 
            return "\(planet1) merges with \(planet2) to amplify their combined power."
        case "opposition": 
            return "\(planet1) and \(planet2) seek perfect balance in your life."
        case "sextile": 
            return "\(planet1) gently supports \(planet2)'s beneficial influence."
        case "quincunx": 
            return "\(planet1) makes subtle adjustments to align with \(planet2)'s wisdom."
        default: 
            return "\(planet1) and \(planet2) dance together in cosmic harmony."
        }
    }
    
    private func getDetailedElementalAction(_ element: String) -> String {
        switch element {
        case "🔥": return "Channel fire's transformative power into passionate action."
        case "🌱": return "Use earth's stability to manifest tangible results."
        case "💨": return "Let air's clarity expand your mental horizons."
        case "💧": return "Flow with water's intuitive wisdom and emotional depth."
        default: return "Balance all elements for complete spiritual harmony."
        }
    }
    
    private func getCombinedCosmicGuidance(_ aspectType: String, planets: [String], element: String) -> String {
        guard planets.count >= 2 else {
            return "Cosmic \(getElementName(element)) energy supports you."
        }
        
        let planet1 = planets[0]
        let planet2 = planets[1]
        let elementAction = getShortElementAction(element)
        
        // Keep it shorter for lock screen
        switch aspectType {
        case "trine": 
            return "\(planet1) trine \(planet2) flows. \(elementAction)"
        case "square": 
            return "\(planet1) square \(planet2) builds. \(elementAction)"
        case "conjunction": 
            return "\(planet1) conjunct \(planet2) powers. \(elementAction)"
        case "opposition": 
            return "\(planet1) opposite \(planet2) balances. \(elementAction)"
        case "sextile": 
            return "\(planet1) sextile \(planet2) opens. \(elementAction)"
        case "quincunx": 
            return "\(planet1) quincunx \(planet2) adjusts. \(elementAction)"
        default: 
            return "\(planet1) aspects \(planet2). \(elementAction)"
        }
    }
    
    private func getShortElementAction(_ element: String) -> String {
        switch element {
        case "🔥": return "Let fire transform you."
        case "🌱": return "Ground yourself in earth."
        case "💨": return "Expand with air's clarity."
        case "💧": return "Flow with water's wisdom."
        default: return "Find elemental balance."
        }
    }
    
    private func getLockScreenNumerologyAstrology(_ ruler: Int, _ aspectType: String, planets: [String]) -> String {
        guard planets.count >= 2 else {
            return "\(ruler) channels cosmic wisdom today."
        }
        
        let planet1 = planets[0]
        let planet2 = planets[1]
        let planet1Energy = getPlanetEnergy(planet1)
        let planet2Energy = getPlanetEnergy(planet2)
        let aspectEnergy = getAspectEnergy(aspectType)
        
        // Match the expanded view format for consistency
        return "\(ruler) \(aspectEnergy) \(planet1Energy) & \(planet2Energy)."
    }
    
    private func getRulerPath(_ number: Int) -> String {
        switch number {
        case 1: return "leadership path"
        case 2: return "harmony path"
        case 3: return "creative path"
        case 4: return "foundation path"
        case 5: return "freedom path"
        case 6: return "nurturing path"
        case 7: return "wisdom path"
        case 8: return "power path"
        case 9: return "completion path"
        default: return "cosmic path"
        }
    }
    
    private func getCosmicAdvice(_ ruler: Int, aspectType: String, element: String) -> String {
        let elementAdvice = switch element {
            case "🔥": "Let passion guide transformation"
            case "🌱": "Ground visions in practical action"
            case "💨": "Allow thoughts to expand freely"
            case "💧": "Trust intuitive emotional flow"
            default: "Balance all elemental forces"
        }
        
        let aspectAdvice = switch aspectType {
            case "trine": "Flow with cosmic harmony"
            case "square": "Embrace growth through challenge"
            case "conjunction": "Unify opposing forces within"
            case "quincunx": "Adjust your spiritual compass"
            default: "Align with universal rhythm"
        }
        
        return "\(aspectAdvice). \(elementAdvice)."
    }
    
    private func getUltraCompactRuler(_ number: Int) -> String {
        switch number {
        case 1: return "Leading"
        case 2: return "Harmonizing"
        case 3: return "Creating"
        case 4: return "Building"
        case 5: return "Exploring"
        case 6: return "Nurturing"
        case 7: return "Deepening"
        case 8: return "Manifesting"
        case 9: return "Serving"
        default: return "Channeling"
        }
    }
    
    private func getUltraCompactElement(_ element: String) -> String {
        switch element {
        case "🔥": return "with fire"
        case "🌱": return "with earth"
        case "💨": return "with air"
        case "💧": return "with water"
        default: return "with cosmos"
        }
    }
    
    private func getRulerInsight(_ number: Int) -> String {
        switch number {
        case 1: return "ignites leadership energy"
        case 2: return "harmonizes relationships" 
        case 3: return "amplifies creative expression"
        case 4: return "builds solid foundations"
        case 5: return "seeks freedom and adventure"
        case 6: return "nurtures with compassion"
        case 7: return "deepens spiritual wisdom"
        case 8: return "manifests material success"
        case 9: return "serves universal consciousness"
        default: return "channels cosmic power"
        }
    }
    
    private func getElementInsight(_ element: String) -> String {
        switch element {
        case "🔥": return "fire energy fuels transformation"
        case "🌱": return "earth energy grounds your vision"
        case "💨": return "air energy expands consciousness"  
        case "💧": return "water energy flows with intuition"
        default: return "elemental forces guide you"
        }
    }
    
    
    /// Claude: Parse aspect display into colored components
    private func parseAspectForColors(_ aspectDisplay: String) -> [AspectComponent] {
        var components: [AspectComponent] = []
        
        for char in aspectDisplay {
            let symbol = String(char)
            let color = getSymbolColor(symbol)
            components.append(AspectComponent(symbol: symbol, color: color))
        }
        
        return components
    }
    
    /// Claude: Get traditional astrological colors for symbols
    private func getSymbolColor(_ symbol: String) -> Color {
        switch symbol {
        // Planets
        case "☉": return .yellow      // Sun - Solar gold
        case "☽": return .gray        // Moon - Lunar silver
        case "☿": return .blue        // Mercury - Communication blue
        case "♀": return .green       // Venus - Love green
        case "♂": return .red         // Mars - Passion red
        case "♃": return .orange      // Jupiter - Wisdom orange
        case "♄": return .brown       // Saturn - Earth brown
        case "♅": return .cyan        // Uranus - Electric cyan
        case "♆": return .purple      // Neptune - Mystical purple
        case "♇": return .indigo      // Pluto - Transformation indigo
        
        // Aspects
        case "☌": return .white       // Conjunction - Unity white
        case "☍": return .red         // Opposition - Tension red
        case "△": return .green       // Trine - Harmony green
        case "□": return .orange      // Square - Challenge orange
        case "⚹": return .blue        // Sextile - Opportunity blue
        case "⚻": return .purple      // Quincunx - Adjustment purple
        
        // Spaces and other
        case " ": return .clear
        default: return .primary
        }
    }
    
    /// Claude: Get the proper Vybe color for each number (matches focus number system)
    private func getNumberColor(_ number: Int) -> Color {
        switch number {
        case 1: return .red     // Unity/divine spark - Leadership
        case 2: return .orange  // Duality/polarity - Harmony
        case 3: return .yellow  // Trinity/creativity - Expression
        case 4: return .green   // Foundation/manifestation - Stability
        case 5: return .blue    // Will/quintessence - Freedom
        case 6: return .indigo  // Harmony/love - Nurturing
        case 7: return .purple  // Mystery/mastery - Wisdom
        case 8: return Color(red: 1.0, green: 0.8, blue: 0.0) // Gold - Power
        case 9: return .white   // Completion/wisdom - Service
        default: return .purple // Default to purple for cosmic
        }
    }
}

// MARK: - Supporting Types

/// Claude: Struct for colored aspect components
struct AspectComponent: Hashable {
    let symbol: String
    let color: Color
}

// MARK: - Preview Extensions

extension CosmicHUDWidgetAttributes {
    fileprivate static var preview: CosmicHUDWidgetAttributes {
        CosmicHUDWidgetAttributes()
    }
}

extension CosmicHUDWidgetAttributes.ContentState {
    fileprivate static var sample1: CosmicHUDWidgetAttributes.ContentState {
        CosmicHUDWidgetAttributes.ContentState(
            rulerNumber: 7,
            realmNumber: 8,
            aspectDisplay: "♀ △ ♃",
            element: "🔥",
            lastUpdate: Date()
        )
    }
    
    fileprivate static var sample2: CosmicHUDWidgetAttributes.ContentState {
        CosmicHUDWidgetAttributes.ContentState(
            rulerNumber: 3,
            realmNumber: 5,
            aspectDisplay: "☽ ☌ ♆",
            element: "💧", 
            lastUpdate: Date()
        )
    }
}

#Preview("Notification", as: .content, using: CosmicHUDWidgetAttributes.preview) {
    CosmicHUDWidgetLiveActivity()
} contentStates: {
    CosmicHUDWidgetAttributes.ContentState.sample1
    CosmicHUDWidgetAttributes.ContentState.sample2
}