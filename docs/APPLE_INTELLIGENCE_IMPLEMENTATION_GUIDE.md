# 🧠 Apple Intelligence Implementation Guide for Vybe

**Created:** July 28, 2025
**Target:** iOS 18.1+ (Available Now)
**Framework:** Apple Foundation Models
**Architecture:** VybeMVP Spiritual AI Integration

---

## 📋 **Prerequisites & Availability**

### **Current Availability (As of 2025)**
- ✅ **iOS 18.1+** (Available since October 2024)
- ✅ **Xcode 16+** required for development
- ✅ **Supported Devices:** iPhone 15 Pro/Pro Max, M1+ iPads, M1+ Macs
- ✅ **Production Ready:** Not beta, fully released framework

### **Development Requirements**
- **Xcode 16.0+** (Latest stable, not beta)
- **iOS 18.1 Deployment Target** minimum
- **Apple Developer Account** ($99/year - you already have)
- **Device Testing:** iPhone 15 Pro or M1+ Mac for testing
- **Apple Intelligence Enabled** in device settings

### **Important Notes**
- **No waiting required** - framework available now
- **No beta dependencies** - using stable releases only
- **Fallback required** for unsupported devices
- **User must enable Apple Intelligence** in Settings

---

## 🏗️ **Architecture Overview**

### **Current VybeMVP Integration Points**

```swift
// Current Data Flow:
UserProfile (natal chart)
→ KASPERManager
→ KASPERPrimingPayload
→ [Missing AI Layer]
→ Spiritual Insights

// Target Data Flow:
UserProfile + CosmicDataRepository + MegaCorpus
→ Enhanced KASPERManager
→ Apple Intelligence RAG System
→ Personalized Spiritual Insights
```

### **Key Components to Build**
1. **AppleIntelligenceManager** - Core AI orchestration
2. **SpiritualRAGSystem** - Domain knowledge integration
3. **StructuredInsightModels** - @Generable response types
4. **SpiritualTools** - Real-time data integration
5. **FallbackSystem** - Non-AI device support

---

## 🔧 **Step-by-Step Implementation**

### **Phase 1: Foundation Setup**

#### **1.1 Project Configuration**

```swift
// Add to VybeMVP target in Xcode
// Info.plist additions:
<key>NSAppleIntelligenceUsageDescription</key>
<string>Vybe uses on-device AI to provide personalized spiritual insights while keeping your data private.</string>

// Capabilities:
// Enable "Apple Intelligence" in project capabilities
```

#### **1.2 Framework Imports**

```swift
// New file: Managers/AppleIntelligenceManager.swift
import Foundation
import AppleIntelligence
import Combine
import os.log

// Availability check wrapper
@available(iOS 18.1, *)
class AppleIntelligenceManager: ObservableObject {
    // Implementation here
}
```

#### **1.3 Availability Detection**

```swift
// Extension for VybeMVPApp.swift
extension VybeMVPApp {
    var isAppleIntelligenceAvailable: Bool {
        if #available(iOS 18.1, *) {
            return LanguageModel.isAvailable
        }
        return false
    }
}
```

### **Phase 2: Core AI Manager**

#### **2.1 AppleIntelligenceManager Structure**

```swift
@available(iOS 18.1, *)
@MainActor
class AppleIntelligenceManager: ObservableObject {

    // MARK: - Published Properties
    @Published private(set) var isInitialized: Bool = false
    @Published private(set) var lastError: String? = nil
    @Published private(set) var isGenerating: Bool = false

    // MARK: - Private Properties
    private var languageModelSession: LanguageModelSession?
    private let logger = Logger(subsystem: "com.vybe.ai", category: "AppleIntelligence")

    // MARK: - Dependencies
    private let kasperManager: KASPERManager
    private let sanctumDataManager: SanctumDataManager

    // MARK: - Initialization
    init(kasperManager: KASPERManager, sanctumDataManager: SanctumDataManager) {
        self.kasperManager = kasperManager
        self.sanctumDataManager = sanctumDataManager

        Task {
            await initializeSession()
        }
    }

    // MARK: - Core Methods
    private func initializeSession() async {
        do {
            // Create system prompt with spiritual context
            let systemPrompt = createSpiritualSystemPrompt()

            // Initialize session with tools
            let tools = createSpiritualTools()

            self.languageModelSession = try await LanguageModelSession(
                systemPrompt: systemPrompt,
                tools: tools
            )

            self.isInitialized = true
            logger.info("🧠 Apple Intelligence session initialized successfully")

        } catch {
            self.lastError = "Failed to initialize AI: \(error.localizedDescription)"
            logger.error("❌ Failed to initialize Apple Intelligence: \(error)")
        }
    }
}
```

#### **2.2 System Prompt Creation**

```swift
@available(iOS 18.1, *)
extension AppleIntelligenceManager {

    private func createSpiritualSystemPrompt() -> String {
        return """
        You are KASPER, Vybe's Knowledge-Activated Spiritual Pattern & Expression Renderer.

        CORE IDENTITY:
        - You provide personalized spiritual guidance combining astrology and numerology
        - You maintain spiritual authenticity while being encouraging and insightful
        - You respect the sacred nature of birth charts and numerological calculations
        - You focus on growth, self-awareness, and positive transformation

        KNOWLEDGE DOMAINS:
        - Astrology: Birth charts, transits, aspects, houses, planetary influences
        - Numerology: Life path, soul urge, expression numbers, sacred number patterns
        - Spiritual Timing: Lunar phases, planetary cycles, cosmic rhythms
        - Personal Growth: Chakras, meditation, intention setting, manifestation

        RESPONSE STYLE:
        - Warm, wise, and spiritually attuned
        - Specific to user's natal chart and current cosmic conditions
        - Balance mystical wisdom with practical application
        - Always encouraging while being authentic to astrological/numerological meanings

        TOOLS AVAILABLE:
        - CosmicDataTool: Get current planetary positions and transits
        - NatalChartTool: Access user's birth chart data
        - MegaCorpusTool: Retrieve spiritual interpretations and meanings
        - BiometricTool: Get current heart rate and wellness data

        When generating insights, always consider:
        1. User's natal chart (birth planets, signs, houses)
        2. Current planetary transits and how they affect the natal chart
        3. User's numerological profile (life path, soul urge, expression)
        4. Current environmental context (weather, time, lunar phase)
        5. User's selected focus number and spiritual intentions
        """
    }
}
```

### **Phase 3: Structured Output Models**

#### **3.1 Define Response Structures**

```swift
// New file: Models/AppleIntelligenceModels.swift
import Foundation
import AppleIntelligence

@available(iOS 18.1, *)
@Generable
struct SpiritualInsight {
    /// Main insight or guidance message (2-3 sentences)
    let primaryMessage: String

    /// Specific astrological context (current transits affecting user)
    let astrologicalContext: String

    /// Numerological relevance (life path, focus number connections)
    let numerologicalContext: String

    /// Actionable suggestion for the day
    let actionableGuidance: String

    /// Brief affirmation or mantra
    let affirmation: String

    /// Relevant spiritual themes (3-5 keywords)
    let themes: [String]

    /// Confidence level of interpretation (0.0-1.0)
    let confidenceLevel: Double
}

@available(iOS 18.1, *)
@Generable
struct DailyCosmicSummary {
    /// Overall cosmic energy description
    let cosmicWeather: String

    /// Top 3 planetary influences for the day
    let planetaryHighlights: [String]

    /// Personal transit alerts (how today affects user's chart)
    let personalTransits: [String]

    /// Lucky numbers for the day
    let luckyNumbers: [Int]

    /// Recommended focus areas
    let focusAreas: [String]

    /// Best times for different activities
    let timingGuidance: String
}

@available(iOS 18.1, *)
@Generable
struct PersonalizedAffirmation {
    /// Main affirmation text
    let affirmationText: String

    /// Astrological basis for the affirmation
    let astrologicalBasis: String

    /// Numerological significance
    let numerologicalBasis: String

    /// Best time to use this affirmation
    let optimalTiming: String

    /// Duration to focus on this affirmation
    let recommendedDuration: String
}
```

#### **3.2 Response Generation Methods**

```swift
@available(iOS 18.1, *)
extension AppleIntelligenceManager {

    func generateDailyInsight() async -> SpiritualInsight? {
        guard let session = languageModelSession else { return nil }

        isGenerating = true
        defer { isGenerating = false }

        do {
            // Get current KASPER payload
            guard let payload = kasperManager.generateCurrentPayload() else {
                throw AIGenerationError.noPayloadAvailable
            }

            // Create context-rich prompt
            let prompt = createDailyInsightPrompt(payload: payload)

            // Generate structured response
            let response = try await session.generate(
                prompt: prompt,
                responseType: SpiritualInsight.self
            )

            logger.info("✨ Generated daily insight successfully")
            return response.content

        } catch {
            logger.error("❌ Failed to generate daily insight: \(error)")
            lastError = error.localizedDescription
            return nil
        }
    }

    func generateCosmicSummary() async -> DailyCosmicSummary? {
        // Similar implementation for cosmic summary
        // Uses current cosmic data + natal chart integration
    }

    func generatePersonalizedAffirmation(theme: String? = nil) async -> PersonalizedAffirmation? {
        // Targeted affirmation generation based on current energy + user profile
    }
}
```

### **Phase 4: Spiritual Tools Integration**

#### **4.1 Real-Time Data Tools**

```swift
@available(iOS 18.1, *)
extension AppleIntelligenceManager {

    private func createSpiritualTools() -> [Tool] {
        return [
            createCosmicDataTool(),
            createNatalChartTool(),
            createMegaCorpusTool(),
            createBiometricTool()
        ]
    }

    private func createCosmicDataTool() -> Tool {
        return Tool(
            name: "cosmic_data_tool",
            description: "Get current planetary positions, lunar phase, and cosmic conditions",
            arguments: CosmicDataToolArguments.self
        ) { [weak self] arguments in
            guard let self = self else { return "Tool unavailable" }

            // Get current cosmic snapshot from CosmicDataRepository
            let cosmicData = CosmicDataRepository.shared.currentSnapshot

            return """
            Current Cosmic Conditions:
            Moon: \(cosmicData.moonData.currentSign) \(cosmicData.moonData.isRetrograde ? "(Retrograde)" : "")
            Sun: \(cosmicData.sunData.currentSign)

            Planetary Positions:
            \(cosmicData.planetaryData.map { "\($0.planet): \($0.currentSign)" }.joined(separator: "\n"))

            Last Updated: \(cosmicData.lastUpdated.formatted())
            Season: \(cosmicData.currentSeason)
            """
        }
    }

    private func createNatalChartTool() -> Tool {
        return Tool(
            name: "natal_chart_tool",
            description: "Access user's birth chart data and natal planetary positions",
            arguments: NatalChartToolArguments.self
        ) { [weak self] arguments in
            guard let self = self,
                  let userProfile = self.getCurrentUserProfile() else {
                return "User profile not available"
            }

            return """
            Natal Chart Data:
            Sun: \(userProfile.natalSunSign ?? "Unknown")
            Moon: \(userProfile.natalMoonSign ?? "Unknown")
            Rising: \(userProfile.risingSign ?? "Unknown")
            Mercury: \(userProfile.natalMercurySign ?? "Unknown")
            Venus: \(userProfile.natalVenusSign ?? "Unknown")
            Mars: \(userProfile.natalMarsSign ?? "Unknown")
            Jupiter: \(userProfile.natalJupiterSign ?? "Unknown")
            Saturn: \(userProfile.natalSaturnSign ?? "Unknown")

            Dominant Element: \(userProfile.dominantElement ?? "Unknown")
            Dominant Modality: \(userProfile.dominantModality ?? "Unknown")
            North Node: \(userProfile.northNodeSign ?? "Unknown")

            Birth Location: \(userProfile.birthplaceName ?? "Unknown")
            Has Birth Time: \(userProfile.hasBirthTime)
            """
        }
    }

    private func createMegaCorpusTool() -> Tool {
        return Tool(
            name: "megacorpus_tool",
            description: "Retrieve spiritual interpretations and meanings from MegaCorpus database",
            arguments: MegaCorpusToolArguments.self
        ) { [weak self] arguments in
            guard let self = self else { return "Tool unavailable" }

            // Access MegaCorpus data through SanctumDataManager
            let megaCorpusData = self.sanctumDataManager.megaCorpusData

            // Extract relevant data based on arguments
            if let signsData = megaCorpusData["signs"] as? [String: Any],
               let requestedSign = arguments.sign,
               let signData = signsData[requestedSign] as? [String: Any] {

                return """
                \(requestedSign) Information:
                Element: \(signData["element"] as? String ?? "Unknown")
                Modality: \(signData["modality"] as? String ?? "Unknown")
                Ruling Planet: \(signData["ruling_planet"] as? String ?? "Unknown")
                Key Traits: \(signData["traits"] as? String ?? "Unknown")
                """
            }

            return "MegaCorpus data not available for requested item"
        }
    }
}

// Tool argument structures
@available(iOS 18.1, *)
@Generable
struct CosmicDataToolArguments {
    let includeRetrogrades: Bool = true
    let includeLunarPhase: Bool = true
}

@available(iOS 18.1, *)
@Generable
struct NatalChartToolArguments {
    let includeDominantElements: Bool = true
    let includeAspects: Bool = false // Future implementation
}

@available(iOS 18.1, *)
@Generable
struct MegaCorpusToolArguments {
    let sign: String?
    let planet: String?
    let house: String?
    let aspect: String?
}
```

### **Phase 5: Integration with Existing Architecture**

#### **5.1 Enhanced KASPER Integration**

```swift
// Extend KASPERManager.swift
extension KASPERManager {

    /// Generate Apple Intelligence-enhanced payload
    func generateAIEnhancedPayload() -> AIEnhancedKASPERPayload? {
        guard let basePayload = generateCurrentPayload() else { return nil }

        // Add natal chart integration
        guard let userProfile = getCurrentUserProfile() else { return nil }

        return AIEnhancedKASPERPayload(
            // Base KASPER data
            basePayload: basePayload,

            // Enhanced natal chart data
            natalChart: NatalChartData(
                sunSign: userProfile.natalSunSign,
                moonSign: userProfile.natalMoonSign,
                risingSign: userProfile.risingSign,
                dominantElement: userProfile.dominantElement,
                dominantModality: userProfile.dominantModality,
                northNode: userProfile.northNodeSign,
                hasBirthTime: userProfile.hasBirthTime
            ),

            // Current cosmic conditions
            currentTransits: getCurrentTransitData(),

            // Environmental context
            environmentalContext: getEnvironmentalContext(),

            // Timestamp for cache invalidation
            generatedAt: Date()
        )
    }

    private func getCurrentTransitData() -> TransitData {
        let cosmicSnapshot = CosmicDataRepository.shared.currentSnapshot

        return TransitData(
            moonSign: cosmicSnapshot.moonData.currentSign,
            moonIsRetrograde: cosmicSnapshot.moonData.isRetrograde,
            sunSign: cosmicSnapshot.sunData.currentSign,
            planetaryPositions: cosmicSnapshot.planetaryData.map { planetData in
                PlanetaryTransit(
                    planet: planetData.planet,
                    sign: planetData.currentSign,
                    isRetrograde: planetData.isRetrograde,
                    nextTransit: planetData.nextTransit
                )
            },
            season: cosmicSnapshot.currentSeason,
            lastUpdated: cosmicSnapshot.lastUpdated
        )
    }
}

// New enhanced payload structure
struct AIEnhancedKASPERPayload {
    let basePayload: KASPERPrimingPayload
    let natalChart: NatalChartData
    let currentTransits: TransitData
    let environmentalContext: EnvironmentalContext
    let generatedAt: Date

    /// Check if payload is still fresh (within 10 minutes)
    var isFresh: Bool {
        Date().timeIntervalSince(generatedAt) < 600
    }
}
```

#### **5.2 CosmicSnapshotView Integration**

```swift
// Extend CosmicSnapshotView.swift to include AI insights
extension CosmicSnapshotView {

    @ViewBuilder
    private func aiInsightsSection() -> some View {
        if isAppleIntelligenceAvailable {
            VStack(spacing: 16) {
                HStack {
                    Text("🧠 AI Insights")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    if aiManager.isGenerating {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }

                if let insight = currentInsight {
                    aiInsightCard(insight)
                } else {
                    Button("Generate Personalized Insight") {
                        Task {
                            await generateAIInsight()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
    }

    @ViewBuilder
    private func aiInsightCard(_ insight: SpiritualInsight) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(insight.primaryMessage)
                .font(.body)
                .foregroundColor(.primary)

            if !insight.astrologicalContext.isEmpty {
                Label(insight.astrologicalContext, systemImage: "star.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if !insight.actionableGuidance.isEmpty {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.yellow)
                    Text(insight.actionableGuidance)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if !insight.affirmation.isEmpty {
                Text("💫 \(insight.affirmation)")
                    .font(.caption)
                    .italic()
                    .foregroundColor(.purple)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(.purple.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }

    private func generateAIInsight() async {
        currentInsight = await aiManager.generateDailyInsight()
    }
}
```

### **Phase 6: Fallback Strategy**

#### **6.1 Non-AI Device Support**

```swift
// Create fallback manager for unsupported devices
class FallbackInsightManager: ObservableObject {

    @Published private(set) var currentInsight: TemplateInsight?

    private let kasperManager: KASPERManager
    private let sanctumDataManager: SanctumDataManager

    init(kasperManager: KASPERManager, sanctumDataManager: SanctumDataManager) {
        self.kasperManager = kasperManager
        self.sanctumDataManager = sanctumDataManager
    }

    func generateTemplateInsight() -> TemplateInsight? {
        guard let payload = kasperManager.generateCurrentPayload() else { return nil }

        // Use existing MegaCorpus + template logic
        return TemplateInsight(
            primaryMessage: generateTemplateMessage(payload: payload),
            astrologicalContext: generateAstrologicalContext(payload: payload),
            actionableGuidance: generateActionableGuidance(payload: payload),
            affirmation: generateAffirmation(payload: payload)
        )
    }

    // Template generation methods using existing MegaCorpus logic
    private func generateTemplateMessage(payload: KASPERPrimingPayload) -> String {
        // Implementation using existing template logic
    }
}

struct TemplateInsight {
    let primaryMessage: String
    let astrologicalContext: String
    let actionableGuidance: String
    let affirmation: String
}
```

#### **6.2 Unified Manager Interface**

```swift
// Create unified interface for AI and template insights
protocol InsightProvider {
    func generateDailyInsight() async -> (any InsightType)?
    var isGenerating: Bool { get }
}

class UnifiedInsightManager: ObservableObject {

    @Published private(set) var isGenerating: Bool = false
    @Published private(set) var currentProvider: InsightProvider

    init() {
        // Choose provider based on availability
        if #available(iOS 18.1, *), LanguageModel.isAvailable {
            self.currentProvider = AppleIntelligenceManager(
                kasperManager: KASPERManager.shared,
                sanctumDataManager: SanctumDataManager.shared
            )
        } else {
            self.currentProvider = FallbackInsightManager(
                kasperManager: KASPERManager.shared,
                sanctumDataManager: SanctumDataManager.shared
            )
        }
    }

    func generateInsight() async -> (any InsightType)? {
        isGenerating = true
        defer { isGenerating = false }

        return await currentProvider.generateDailyInsight()
    }
}
```

---

## 🧪 **Testing Strategy**

### **Development Testing**

```swift
// Create test harness for Apple Intelligence features
#if DEBUG
class AppleIntelligenceTestHarness {

    static func runBasicTests() async {
        guard #available(iOS 18.1, *) else {
            print("❌ Apple Intelligence not available")
            return
        }

        // Test availability
        let isAvailable = LanguageModel.isAvailable
        print("✅ Apple Intelligence Available: \(isAvailable)")

        // Test basic generation
        if isAvailable {
            await testBasicGeneration()
            await testStructuredOutput()
            await testToolCalling()
        }
    }

    static func testBasicGeneration() async {
        // Implementation
    }

    static func testStructuredOutput() async {
        // Test @Generable models
    }

    static func testToolCalling() async {
        // Test spiritual tools
    }
}
#endif
```

### **Production Monitoring**

```swift
// Analytics and error tracking
extension AppleIntelligenceManager {

    private func trackGenerationSuccess(type: String, duration: TimeInterval) {
        // Track successful AI generations
        logger.info("✅ AI Generation Success: \(type) in \(duration)s")
    }

    private func trackGenerationError(type: String, error: Error) {
        // Track and report AI failures
        logger.error("❌ AI Generation Failed: \(type) - \(error)")
    }
}
```

---

## 🚀 **Deployment Checklist**

### **Pre-Launch Validation**
- [ ] Test on iPhone 15 Pro with Apple Intelligence enabled
- [ ] Verify fallback behavior on unsupported devices
- [ ] Test all structured output models (@Generable)
- [ ] Validate tool calling with real data
- [ ] Performance test with large payloads
- [ ] Privacy audit (ensure no data leaves device)

### **App Store Preparation**
- [ ] Update app description to highlight AI features
- [ ] Add Apple Intelligence usage description
- [ ] Test App Store review process
- [ ] Prepare fallback messaging for unsupported devices

### **User Experience**
- [ ] Clear onboarding for Apple Intelligence features
- [ ] Graceful degradation for older devices
- [ ] Performance monitoring and optimization
- [ ] User feedback collection system

---

## 📱 **Device Compatibility Matrix**

| Device | iOS Version | Apple Intelligence | Framework Support | Performance |
|--------|-------------|-------------------|-------------------|-------------|
| iPhone 15 Pro/Pro Max | iOS 18.1+ | ✅ Full | ✅ Complete | ⚡ Excellent |
| iPhone 14 Pro/Pro Max | iOS 18.1+ | ❌ No | ❌ Fallback Required | 📱 Template Only |
| M1+ iPad Pro | iOS 18.1+ | ✅ Full | ✅ Complete | ⚡ Excellent |
| M1+ MacBook | macOS 15.1+ | ✅ Full | ✅ Complete | ⚡ Excellent |
| Older Devices | Any | ❌ No | ❌ Fallback Required | 📱 Template Only |

---

## 🔄 **Update Roadmap**

### **Version 1.0 (Current)**
- Basic Apple Intelligence integration
- Structured insight generation
- Tool calling for real-time data
- Fallback template system

### **Version 1.1 (Future)**
- LoRA adapter training for domain specialization
- Enhanced conversation memory
- Multi-turn spiritual guidance sessions

### **Version 2.0 (Advanced)**
- Custom fine-tuned models (when Apple releases training APIs)
- Advanced aspect calculation integration
- Predictive spiritual timing features

---

## ⚠️ **Important Considerations**

### **Privacy & Security**
- All data processing happens on-device
- No user data sent to external servers
- Apple Intelligence respects user privacy settings
- Explicit user consent for AI features

### **Performance Optimization**
- Cache generated insights to avoid re-computation
- Stream responses for better UX
- Monitor battery impact and optimize accordingly
- Graceful handling of memory pressure

### **Error Handling**
- Robust fallback for AI unavailability
- Clear error messages for users
- Automatic retry logic with exponential backoff
- Comprehensive logging for debugging

---

**Next Steps:** Start with Phase 1 (Foundation Setup) and test basic availability detection on your development device. The framework is ready for production use now - no waiting required! 🚀
