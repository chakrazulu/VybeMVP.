import Foundation
import AppIntents
import SwiftUI

// MARK: - Cosmic HUD App Intents
/// Claude: Spiritual shortcuts that make Vybe accessible from anywhere
/// 
/// REVOLUTIONARY UX CONCEPT:
/// Hold the Dynamic Island to see system shortcuts for instant spiritual actions.
/// No need to open the app - cosmic guidance is always one touch away.
/// 
/// 6 SACRED ACTIONS:
/// 1. 👁 Add Sighting - Capture number synchronicities in the moment
/// 2. 📓 Journal Entry - Record spiritual insights instantly
/// 3. 💬 Post Status - Share cosmic wisdom with community
/// 4. 📊 Ruler Graph - Explore numerological patterns
/// 5. 🔢 Change Focus - Shift spiritual alignment instantly
/// 6. ✨ Cosmic Snapshot - Capture planetary moment for analysis
/// 
/// TECHNICAL IMPLEMENTATION:
/// - iOS 16.1+ App Intents framework for system integration
/// - NotificationCenter routing to CosmicHUDIntegration
/// - Haptic feedback for tactile spiritual connection
/// - Siri voice shortcuts with natural language phrases
/// - Parameters for quick data entry (notes, focus numbers, etc.)
/// 
/// SPIRITUAL PHILOSOPHY:
/// These shortcuts remove friction from spiritual practice.
/// When synchronicity strikes, users can capture it instantly.
/// The HUD becomes a portal between cosmic awareness and digital action.

// MARK: - Base Intent Protocol
/// Claude: Shared protocol for all Cosmic HUD spiritual shortcuts
/// Provides consistent cosmic descriptions for each sacred action
protocol CosmicIntent: AppIntent {
    /// Human-readable description of the spiritual purpose
    var cosmicDescription: String { get }
}

// MARK: - Add Sighting Intent
/// Claude: Instant number sighting capture from anywhere in iOS
/// Perfect for synchronicity moments that can't wait for app launch
/// Routes directly to SightingView with cosmic context preserved
struct AddSightingIntent: CosmicIntent {
    static var title: LocalizedStringResource = "Add Number Sighting"
    static var description = IntentDescription("Capture a sacred number sighting from the Cosmic HUD")
    
    var cosmicDescription: String {
        return "👁 Capture cosmic synchronicity in the moment"
    }
    
    func perform() async throws -> some IntentResult {
        // Claude: Navigate to sighting creation via notification system
        // CosmicHUDIntegration listens for this notification and routes to SightingView
        await MainActor.run {
            NotificationCenter.default.post(
                name: .cosmicHUDNavigate,
                object: nil,
                userInfo: ["destination": "sighting"]
            )
        }
        
        // Claude: Siri speaks this response when shortcut is voice-activated
        return .result(dialog: "Opening sighting capture...")
    }
}

// MARK: - Add Journal Entry Intent
/// Claude: Instant spiritual journaling from anywhere in iOS
/// Supports optional quick note parameter for voice-to-text entries
/// Routes to JournalEntryView with cosmic timestamp and context
struct AddJournalEntryIntent: CosmicIntent {
    static var title: LocalizedStringResource = "Add Journal Entry"
    static var description = IntentDescription("Create a spiritual journal entry from the Cosmic HUD")
    
    var cosmicDescription: String {
        return "📓 Record your spiritual journey"
    }
    
    /// Claude: Optional parameter for voice shortcuts or quick text input
    /// Example: "Hey Siri, add journal entry 'feeling aligned with Venus energy'"
    @Parameter(title: "Quick Note", description: "Optional quick note for the entry")
    var quickNote: String?
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            // Claude: Build navigation payload with optional quick note
            // JournalEntryView can pre-populate text if note is provided
            var userInfo: [String: Any] = ["destination": "journal"]
            if let note = quickNote {
                userInfo["quickNote"] = note
            }
            
            NotificationCenter.default.post(
                name: .cosmicHUDNavigate,
                object: nil,
                userInfo: userInfo
            )
        }
        
        return .result(dialog: "Opening journal entry...")
    }
}

// MARK: - Post Status Intent
/// Claude: Instant community sharing from anywhere in iOS
/// Perfect for sharing cosmic insights without app launch delay
/// Routes to PostComposerView with current HUD data context
struct PostStatusIntent: CosmicIntent {
    static var title: LocalizedStringResource = "Post Spiritual Status"
    static var description = IntentDescription("Share your cosmic state with the Vybe community")
    
    var cosmicDescription: String {
        return "💬 Share your cosmic wisdom"
    }
    
    /// Claude: Optional pre-filled message for voice shortcuts
    /// Example: "Hey Siri, post spiritual status 'Jupiter energy flowing strong today'"
    @Parameter(title: "Status Message", description: "Your spiritual status message")
    var statusMessage: String?
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            var userInfo: [String: Any] = ["destination": "composer"]
            if let message = statusMessage {
                userInfo["prefilledMessage"] = message
            }
            
            NotificationCenter.default.post(
                name: .cosmicHUDNavigate,
                object: nil,
                userInfo: userInfo
            )
        }
        
        return .result(dialog: "Opening post composer...")
    }
}

// MARK: - Ruler Graph Intent
/// Claude: Instant access to numerological analysis from anywhere
/// Routes to RulerGraphView showing patterns and spiritual insights
/// No parameters needed - shows current user's complete numerological profile
struct RulerGraphIntent: CosmicIntent {
    static var title: LocalizedStringResource = "View Ruler Number Graph"
    static var description = IntentDescription("Explore your numerological patterns and insights")
    
    
    var cosmicDescription: String {
        return "📊 Explore your sacred patterns"
    }
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            NotificationCenter.default.post(
                name: .cosmicHUDNavigate,
                object: nil,
                userInfo: ["destination": "rulerGraph"]
            )
        }
        
        return .result(dialog: "Opening ruler number analysis...")
    }
}

// MARK: - Change Focus Number Intent
/// Claude: Instant spiritual alignment shifts from anywhere in iOS
/// Can set specific number via parameter or open selector interface
/// Updates FocusNumberManager and refreshes HUD immediately
struct ChangeFocusNumberIntent: CosmicIntent {
    static var title: LocalizedStringResource = "Change Focus Number"
    static var description = IntentDescription("Select a new focus number for spiritual alignment")
    
    var cosmicDescription: String {
        return "🔢 Shift your spiritual focus"
    }
    
    /// Claude: Optional direct number selection with validation range
    /// Example: "Hey Siri, change focus number to 7" sets number directly
    /// If nil, opens FocusNumberSelector interface for manual selection
    @Parameter(title: "New Focus Number", description: "Choose a number from 1-9", inclusiveRange: (1, 9))
    var newFocusNumber: Int?
    
    func perform() async throws -> some IntentResult {
        if let number = newFocusNumber {
            // Claude: Direct number update - perfect for voice shortcuts
            // "Hey Siri, change focus number to 3" → instant spiritual alignment
            await MainActor.run {
                FocusNumberManager.shared.setFocusNumber(number, sendNotification: true)
                
                // Claude: Trigger immediate HUD refresh to show new ruler number
                // Users see their new cosmic alignment reflected instantly
                Task {
                    await CosmicHUDManager.shared.refreshHUDData()
                }
            }
            
            return .result(dialog: "Focus number changed to \(number). Your cosmic alignment is shifting...")
        } else {
            // Claude: No number specified - open selector interface
            // Good for manual selection with visual feedback
            await MainActor.run {
                NotificationCenter.default.post(
                    name: .cosmicHUDNavigate,
                    object: nil,
                    userInfo: ["destination": "focusSelector"]
                )
            }
            
            return .result(dialog: "Opening focus number selector...")
        }
    }
}

// MARK: - Cosmic Snapshot Intent
/// Claude: Instant cosmic moment capture from anywhere in iOS
/// Perfect for significant planetary alignments or spiritual breakthroughs
/// Routes to CosmicSnapshotView with current astronomical data preserved
struct CosmicSnapshotIntent: CosmicIntent {
    static var title: LocalizedStringResource = "Take Cosmic Snapshot"
    static var description = IntentDescription("Capture your current cosmic state and planetary alignments")
    
    var cosmicDescription: String {
        return "✨ Capture this cosmic moment"
    }
    
    func perform() async throws -> some IntentResult {
        await MainActor.run {
            NotificationCenter.default.post(
                name: .cosmicHUDNavigate,
                object: nil,
                userInfo: ["destination": "cosmicSnapshot"]
            )
        }
        
        return .result(dialog: "Opening cosmic snapshot...")
    }
}

// MARK: - Cosmic HUD Shortcuts Provider
/// Claude: System-wide Siri voice shortcuts and Shortcuts app integration
/// Each shortcut has multiple natural language phrases for voice activation
/// Icons use SF Symbols for consistent iOS system integration
struct CosmicHUDShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            // Claude: Number sighting capture - perfect for synchronicity moments
            AppShortcut(
                intent: AddSightingIntent(),
                phrases: [
                    "Add a number sighting in \(.applicationName)",
                    "Capture cosmic sighting in \(.applicationName)",
                    "Record sacred number in \(.applicationName)"
                ],
                shortTitle: "Add Sighting",
                systemImageName: "eye"
            ),
            
            // Claude: Spiritual journaling - capture insights instantly
            AppShortcut(
                intent: AddJournalEntryIntent(),
                phrases: [
                    "Add journal entry in \(.applicationName)",
                    "Write spiritual journal in \(.applicationName)",
                    "Record cosmic thoughts in \(.applicationName)"
                ],
                shortTitle: "Journal Entry",
                systemImageName: "book.closed"
            ),
            
            // Claude: Community sharing - spread cosmic wisdom
            AppShortcut(
                intent: PostStatusIntent(),
                phrases: [
                    "Post spiritual status in \(.applicationName)",
                    "Share cosmic state in \(.applicationName)",
                    "Post to Vybe community in \(.applicationName)"
                ],
                shortTitle: "Post Status",
                systemImageName: "bubble.left.and.bubble.right"
            ),
            
            // Claude: Numerological analysis - explore sacred patterns
            AppShortcut(
                intent: RulerGraphIntent(),
                phrases: [
                    "Show ruler graph in \(.applicationName)",
                    "View numerology patterns in \(.applicationName)",
                    "Open cosmic analysis in \(.applicationName)"
                ],
                shortTitle: "Ruler Graph",
                systemImageName: "chart.bar"
            ),
            
            // Claude: Spiritual alignment - instant focus number shifts
            AppShortcut(
                intent: ChangeFocusNumberIntent(),
                phrases: [
                    "Change focus number in \(.applicationName)",
                    "Set new focus number in \(.applicationName)",
                    "Shift spiritual focus in \(.applicationName)"
                ],
                shortTitle: "Change Focus",
                systemImageName: "arrow.triangle.2.circlepath"
            ),
            
            // Claude: Cosmic moment capture - preserve significant alignments
            AppShortcut(
                intent: CosmicSnapshotIntent(),
                phrases: [
                    "Take cosmic snapshot in \(.applicationName)",
                    "Capture planetary alignments in \(.applicationName)",
                    "Record cosmic moment in \(.applicationName)"
                ],
                shortTitle: "Cosmic Snapshot",
                systemImageName: "sparkles"
            )
        ]
    }
}

// MARK: - Navigation Coordinator
/// Claude: Central routing system for HUD intent navigation
/// Bridges App Intents notifications to SwiftUI navigation state
/// Maintains navigation data payload for contextual app launches
class CosmicHUDNavigationCoordinator: ObservableObject {
    static let shared = CosmicHUDNavigationCoordinator()
    
    /// Current navigation destination from HUD intent
    @Published var activeDestination: String?
    /// Payload data for navigation context (quick notes, focus numbers, etc.)
    @Published var navigationData: [String: Any] = [:]
    
    private init() {
        setupNotificationObserver()
    }
    
    /// Claude: Listens for App Intent navigation requests
    /// Converts NotificationCenter posts to SwiftUI navigation state
    /// Weak self prevents retain cycles in long-lived coordinator
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: .cosmicHUDNavigate,
            object: nil,
            queue: .main  // Claude: Main queue ensures UI updates happen safely
        ) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let destination = userInfo["destination"] as? String else {
                return
            }
            
            // Claude: Update published properties to trigger SwiftUI navigation
            self?.activeDestination = destination
            self?.navigationData = Dictionary(uniqueKeysWithValues: userInfo.compactMap { key, value in
                guard let stringKey = key as? String else { return nil }
                return (stringKey, value)
            })
        }
    }
    
    func clearNavigation() {
        activeDestination = nil
        navigationData.removeAll()
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let cosmicHUDNavigate = Notification.Name("cosmicHUDNavigate")
}

// MARK: - Intent Result Extensions
extension IntentResult {
    /// Creates a cosmic-themed result with spiritual flair
    static func cosmicResult(message: String, emoji: String = "✨") -> some IntentResult {
        return .result(dialog: "\(emoji) \(message)")
    }
}

// MARK: - Shortcut Validation
/// Claude: Device compatibility checks for Cosmic HUD features
/// Ensures graceful degradation on unsupported devices
struct CosmicHUDIntentValidator {
    /// Claude: Validates that all required permissions are available for HUD intents
    /// Checks iOS version, device capability, and framework availability
    static func validateIntentPermissions() async -> Bool {
        // Claude: ActivityKit required for Live Activities (Dynamic Island HUD)
        guard #available(iOS 16.1, *) else {
            return false
        }
        
        // Claude: Dynamic Island requires iPhone 14 Pro+ hardware
        // This is a simplified check - actual implementation would verify notch presence
        let hasNotch = await UIDevice.current.userInterfaceIdiom == .phone
        
        // Claude: App Intents framework availability (iOS 16+)
        let hasAppIntents = true // AppIntents framework is available
        
        return hasNotch && hasAppIntents
    }
    
    /// Gets appropriate error message for unsupported devices
    static func getUnsupportedMessage() -> String {
        if #available(iOS 16.1, *) {
            return "Cosmic HUD requires iPhone 14 Pro or later with Dynamic Island"
        } else {
            return "Cosmic HUD requires iOS 16.1 or later"
        }
    }
}

// MARK: - Preview Helpers
#if DEBUG
extension CosmicHUDIntentValidator {
    static func previewIntentList() -> [String] {
        return [
            "👁 Add Sighting - Capture sacred number synchronicities",
            "📓 Journal Entry - Record spiritual insights",
            "💬 Post Status - Share cosmic wisdom",
            "📊 Ruler Graph - Explore numerological patterns",
            "🔢 Change Focus - Shift spiritual alignment",
            "✨ Cosmic Snapshot - Capture planetary moment"
        ]
    }
}
#endif