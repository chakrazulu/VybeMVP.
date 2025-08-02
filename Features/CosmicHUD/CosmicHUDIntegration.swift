import SwiftUI
import ActivityKit
import Combine
import WidgetKit

// MARK: - Cosmic HUD Integration
/// Claude: The bridge between cosmic consciousness and Vybe's main app
/// Handles lifecycle management, navigation routing, and app state synchronization
/// Makes the HUD a living extension of the user's spiritual journey

@MainActor
class CosmicHUDIntegration: ObservableObject {
    
    // MARK: - Singleton
    static let shared = CosmicHUDIntegration()
    
    // MARK: - Published Properties
    @Published var isHUDEnabled: Bool = false
    @Published var hudActivity: Activity<CosmicHUDWidgetAttributes>?
    @Published var navigationRequest: HUDNavigationRequest?
    
    // MARK: - Dependencies
    private let hudManager = CosmicHUDManager.shared
    private let navigationCoordinator = CosmicHUDNavigationCoordinator.shared
    // Claude: FIXED - Don't create new instance, will use main app's shared instance
    private var mainAppRealmManager: RealmNumberManager?
    
    // Claude: Configure HUD manager with main app's realm manager for data sync
    private var isHUDConfigured = false
    
    // MARK: - Private Properties
    private var isInitialized = false
    private var cancellables = Set<AnyCancellable>()
    
    // Claude: Immediate update system - no timer needed
    // Updates happen instantly when values change while app is in foreground
    
    private init() {
        setupNavigationObserver()
        setupNotificationObservers()
    }
    
    // MARK: - Public Methods
    
    /// Claude: CRITICAL FIX - Set the main app's realm manager to prevent duplicate instances
    func setMainAppRealmManager(_ realmManager: RealmNumberManager) {
        self.mainAppRealmManager = realmManager
        print("🔗 HUD Integration: Main app realm manager configured - no more duplicate instances")
    }
    
    /// Initializes the Cosmic HUD system when app launches
    func initializeHUD() async {
        guard !isInitialized else { return }
        
        // Claude: Configure HUD manager with main app's realm manager for data sync
        if !isHUDConfigured, let realmManager = mainAppRealmManager {
            hudManager.configureWithMainAppManagers(realmManager: realmManager)
            isHUDConfigured = true
        }
        
        // Check device compatibility
        guard await CosmicHUDIntentValidator.validateIntentPermissions() else {
            print("Claude: Device not compatible with Cosmic HUD")
            return
        }
        
        // No need to clean up on initialization - let the system handle it
        
        // Check user preferences
        if shouldAutoStartHUD() {
            await startHUD()
        }
        
        isInitialized = true
        print("Claude: Cosmic HUD system initialized successfully")
    }
    
    /// Starts the Cosmic HUD Live Activity
    func startHUD() async {
        print("Claude: 🚀 Starting Cosmic HUD...")
        
        guard #available(iOS 16.1, *) else {
            print("Claude: ❌ iOS 16.1+ required for Live Activities")
            await MainActor.run { self.isHUDEnabled = false }
            return
        }
        
        // End any existing activities first to prevent duplicates
        if let existingActivity = hudActivity {
            print("Claude: 🔄 Ending existing activity before starting new one")
            await existingActivity.end(nil, dismissalPolicy: .immediate)
            await MainActor.run { self.hudActivity = nil }
        }
        
        // Check Activity authorization first
        let authorizationInfo = ActivityAuthorizationInfo()
        print("Claude: 📱 Activity authorization status: \(authorizationInfo.areActivitiesEnabled)")
        
        guard authorizationInfo.areActivitiesEnabled else {
            print("Claude: ❌ Live Activities are disabled in Settings")
            await MainActor.run { self.isHUDEnabled = false }
            return
        }
        
        do {
            print("Claude: 🔄 Refreshing HUD data...")
            // Get initial HUD data
            await hudManager.refreshHUDData()
            
            guard let hudData = hudManager.currentHUDData else {
                print("Claude: ❌ No HUD data available, cannot start HUD")
                await MainActor.run { self.isHUDEnabled = false }
                return
            }
            
            print("Claude: ✅ HUD data ready - Ruler: \(hudData.rulerNumber), Element: \(hudData.element)")
            
            // Create activity attributes and initial state
            let attributes = CosmicHUDWidgetAttributes()
            let currentRealmNumber = hudManager.getCurrentRealmNumber()
            print("Claude: 📊 Starting Live Activity - Ruler: \(hudData.rulerNumber), Realm: \(currentRealmNumber)")
            
            let contentState = CosmicHUDWidgetAttributes.ContentState(
                rulerNumber: hudData.rulerNumber,                   // LIVE from HUD manager
                realmNumber: currentRealmNumber,                    // LIVE from HUD manager
                aspectDisplay: formatAspectForHUD(hudData.dominantAspect),
                element: HUDGlyphMapper.element(for: hudData.element),
                lastUpdate: Date()
            )
            
            print("Claude: 🎯 Requesting Live Activity...")
            // Request the Live Activity
            let activity = try Activity<CosmicHUDWidgetAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: nil)
            )
            
            await MainActor.run {
                self.hudActivity = activity
                self.isHUDEnabled = true
            }
            
            // Start the HUD manager
            hudManager.startHUD()
            
            print("Claude: ✅ Cosmic HUD Live Activity started successfully! ID: \(activity.id)")
            print("Claude: 📡 HUD now updates immediately on value changes")
            
        } catch {
            print("Claude: ❌ Error starting HUD: \(error)")
            print("Claude: 🔍 Error details: \(error.localizedDescription)")
            
            await MainActor.run {
                self.isHUDEnabled = false
            }
            
            let errorMessage = if error.localizedDescription.contains("unsupportedTarget") {
                "Cosmic HUD requires iPhone 14 Pro or iPhone 15 Pro with Dynamic Island"
            } else {
                "Failed to start Cosmic HUD: \(error.localizedDescription)"
            }
            
            print("Claude: 💡 \(errorMessage)")
        }
    }
    
    /// Stops the Cosmic HUD Live Activity (explicit user action only)
    func stopHUD() async {
        guard #available(iOS 16.1, *) else { return }
        
        if let activity = hudActivity {
            print("Claude: 🛑 User requested to end Live Activity: \(activity.id)")
            await activity.end(nil, dismissalPolicy: .immediate)
            await MainActor.run {
                self.hudActivity = nil
            }
        }
        
        hudManager.stopHUD()
        await MainActor.run {
            self.isHUDEnabled = false
        }
        
        print("Claude: ✅ Cosmic HUD stopped by user request")
    }
    
    /// Updates the HUD with fresh cosmic data (foreground-only strategy)
    func updateHUD() async {
        guard #available(iOS 16.1, *),
              let activity = hudActivity,
              let hudData = hudManager.currentHUDData else {
            return
        }
        
        let currentRealmNumber = hudManager.getCurrentRealmNumber()
        print("Claude: 📊 Updating Live Activity - Ruler: \(hudData.rulerNumber), Realm: \(currentRealmNumber)")
        
        let updatedState = CosmicHUDWidgetAttributes.ContentState(
            rulerNumber: hudData.rulerNumber,                   // LIVE from HUD manager
            realmNumber: currentRealmNumber,                    // LIVE from HUD manager
            aspectDisplay: formatAspectForHUD(hudData.dominantAspect),
            element: HUDGlyphMapper.element(for: hudData.element),
            lastUpdate: Date()
        )
        
        await activity.update(.init(state: updatedState, staleDate: nil))
        
        // Also update widgets to keep them in sync
        WidgetCenter.shared.reloadTimelines(ofKind: "CosmicHUDWidget")
        
        print("Claude: ✅ HUD & widgets updated successfully")
    }
    
    /// Handles navigation requests from HUD intents
    func handleNavigationRequest(_ request: HUDNavigationRequest) {
        navigationRequest = request
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        print("Claude: Handling HUD navigation to \(request.destination)")
    }
    
    /// Clears the current navigation request
    func clearNavigationRequest() {
        navigationRequest = nil
    }
    
    
    /// Toggles HUD on/off based on user preference
    func toggleHUD() async {
        if isHUDEnabled {
            await stopHUD() // This will end the Live Activity completely
        } else {
            await startHUD() // This will create a new Live Activity
        }
    }
    
    // MARK: - App State Integration
    
    /// Should be called when app enters foreground
    func appDidBecomeActive() async {
        print("Claude: 🌅 App became active - immediate update with latest data")
        
        if isHUDEnabled {
            // Immediate update with latest data only - no timer
            await hudManager.refreshHUDData()
            await updateHUD()
            print("Claude: 📡 HUD now responds immediately to value changes")
        }
    }
    
    /// Should be called when app enters background
    func appDidEnterBackground() {
        print("Claude: 🌙 App backgrounded - Live Activity persists with last state")
        
        // Live Activity continues showing last state for up to 8 hours
        // Updates stop automatically when app backgrounds
    }
    
    /// Should be called when focus number changes
    func focusNumberDidChange(_ newNumber: Int) async {
        print("🎯 HUD Integration: Focus number changed to \(newNumber)")
        if isHUDEnabled {
            await hudManager.refreshHUDData()
            await updateHUD() // Update with new focus number
            print("✅ HUD Integration: HUD updated for new focus number")
        }
    }
    
    /// Should be called when user profile updates
    func userProfileDidUpdate() async {
        if isHUDEnabled {
            await hudManager.refreshHUDData()
            await updateHUD()
        }
    }
    
    // MARK: - Private Methods
    
    /// Ends all active Cosmic HUD activities to prevent spam
    @available(iOS 16.1, *)
    private func endAllCosmicHUDActivities() async {
        for activity in Activity<CosmicHUDWidgetAttributes>.activities {
            print("Claude: 🧹 Cleaning up orphaned activity: \(activity.id)")
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
    
    private func setupNavigationObserver() {
        navigationCoordinator.$activeDestination
            .compactMap { $0 }
            .sink { [weak self] destination in
                let request = HUDNavigationRequest(
                    destination: destination,
                    data: self?.navigationCoordinator.navigationData ?? [:]
                )
                self?.handleNavigationRequest(request)
            }
            .store(in: &cancellables) // Use local cancellables set
    }
    
    /// Claude: Sets up notification observers for app-wide events
    private func setupNotificationObservers() {
        // Listen for focus number changes
        NotificationCenter.default.publisher(for: NSNotification.Name.focusNumberChanged)
            .compactMap { $0.userInfo?["focusNumber"] as? Int }
            .sink { [weak self] newFocusNumber in
                print("🎯 HUD Integration: Focus number changed to \(newFocusNumber) - updating immediately")
                Task {
                    await self?.focusNumberDidChange(newFocusNumber)
                }
            }
            .store(in: &cancellables)
        
        // Listen for realm number changes  
        NotificationCenter.default.publisher(for: NSNotification.Name.realmNumberChanged)
            .compactMap { $0.userInfo?["realmNumber"] as? Int }
            .sink { [weak self] newRealmNumber in
                print("🌌 HUD Integration: Realm number changed to \(newRealmNumber) - updating immediately")
                Task {
                    if self?.isHUDEnabled == true {
                        await self?.hudManager.refreshHUDData()
                        await self?.updateHUD() // Update with new realm number
                        print("✅ HUD Integration: HUD updated immediately for realm number \(newRealmNumber)")
                    }
                }
            }
            .store(in: &cancellables)
        
        // Listen for HUD data updates (ruler number changes, aspect changes, etc.)
        NotificationCenter.default.publisher(for: NSNotification.Name("HUDDataUpdated"))
            .sink { [weak self] notification in
                if let rulerNumber = notification.userInfo?["rulerNumber"] as? Int {
                    print("🔄 HUD Integration: HUD data updated with ruler \(rulerNumber) - updating Live Activity")
                }
                Task {
                    if self?.isHUDEnabled == true {
                        await self?.updateHUD()
                        print("✅ HUD Integration: Live Activity updated for HUD data change")
                    }
                }
            }
            .store(in: &cancellables)
        
        print("🔗 HUD: Notification observers configured for immediate updates")
    }
    
    private func formatAspectForHUD(_ aspectData: AspectData?) -> String {
        guard let aspectData = aspectData else {
            return "No aspects"
        }
        
        return HUDGlyphMapper.aspectChain(
            planet1: aspectData.planet1,
            aspect: aspectData.aspect,
            planet2: aspectData.planet2
        )
    }
    
    private func shouldAutoStartHUD() -> Bool {
        return UserDefaults.standard.bool(forKey: "cosmicHUDAutoStart")
    }
}

// MARK: - HUD Navigation Request
struct HUDNavigationRequest: Identifiable {
    let id = UUID()
    let destination: String
    let data: [String: Any]
    let timestamp: Date
    
    init(destination: String, data: [String: Any] = [:]) {
        self.destination = destination
        self.data = data
        self.timestamp = Date()
    }
}

// MARK: - App Integration Extensions
extension CosmicHUDIntegration {
    
    /// Creates a SwiftUI view modifier for HUD integration
    func hudIntegrationModifier() -> some ViewModifier {
        HUDIntegrationModifier(integration: self)
    }
}

// MARK: - SwiftUI Integration Modifier
struct HUDIntegrationModifier: ViewModifier {
    let integration: CosmicHUDIntegration
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasAppeared {
                    Task {
                        await integration.initializeHUD()
                    }
                    hasAppeared = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                Task {
                    await integration.appDidBecomeActive()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                integration.appDidEnterBackground()
            }
            .sheet(item: Binding<HUDNavigationRequest?>(
                get: { integration.navigationRequest },
                set: { _ in integration.clearNavigationRequest() }
            )) { request in
                navigationDestination(for: request)
            }
    }
    
    @ViewBuilder
    private func navigationDestination(for request: HUDNavigationRequest) -> some View {
        switch request.destination {
        case "sighting":
            // Navigate to SightingView
            Text("Sighting View")
                .navigationTitle("Add Sighting")
            
        case "journal":
            // Navigate to JournalEntryView
            Text("Journal Entry View")
                .navigationTitle("New Entry")
            
        case "composer":
            // Navigate to PostComposerView
            Text("Post Composer View")
                .navigationTitle("Share Status")
            
        case "rulerGraph":
            // Navigate to RulerGraphView
            Text("Ruler Graph View")
                .navigationTitle("Numerology Patterns")
            
        case "focusSelector":
            // Navigate to FocusNumberSelector
            Text("Focus Number Selector")
                .navigationTitle("Change Focus")
            
        case "cosmicSnapshot":
            // Navigate to CosmicSnapshotView
            Text("Cosmic Snapshot View")
                .navigationTitle("Cosmic Moment")
            
        default:
            Text("Unknown Destination")
                .navigationTitle("Vybe")
        }
    }
}

// MARK: - VybeMVPApp Integration
extension CosmicHUDIntegration {
    
    /// Convenience method to integrate with VybeMVPApp
    func integrateWithMainApp() -> some ViewModifier {
        hudIntegrationModifier()
    }
}

// MARK: - Settings Integration
struct CosmicHUDSettings: View {
    @StateObject private var integration = CosmicHUDIntegration.shared
    @State private var autoStartEnabled = UserDefaults.standard.bool(forKey: "cosmicHUDAutoStart")
    @State private var isLoading = false
    @State private var lastError: String?
    
    var body: some View {
        Section("🌌 Cosmic HUD") {
            HStack {
                Toggle("Enable Cosmic HUD", isOn: Binding(
                    get: { integration.isHUDEnabled },
                    set: { newValue in
                        Task {
                            isLoading = true
                            lastError = nil
                            
                            if newValue {
                                await integration.startHUD()
                                // Check if it actually started
                                if !integration.isHUDEnabled {
                                    lastError = "Failed to start HUD - check console for details"
                                }
                            } else {
                                await integration.stopHUD()
                            }
                            
                            isLoading = false
                        }
                    }
                ))
                .disabled(isLoading)
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.7)
                }
            }
            
            Toggle("Auto-start on launch", isOn: $autoStartEnabled)
                .onChange(of: autoStartEnabled) { _, newValue in
                    UserDefaults.standard.set(newValue, forKey: "cosmicHUDAutoStart")
                }
            
            if let error = lastError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            if integration.isHUDEnabled {
                Label("Dynamic Island active", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Requires iPhone 14 Pro+", systemImage: "info.circle")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text("Dynamic Island needed for Cosmic HUD")
                        .foregroundColor(.secondary)
                        .font(.caption2)
                    
                    Text("Check Settings > Screen Time > Live Activities if toggle doesn't work")
                        .foregroundColor(.secondary)
                        .font(.caption2)
                }
            }
        }
    }
}

// MARK: - Preview Helpers
#if DEBUG
struct CosmicHUDIntegration_Previews: PreviewProvider {
    static var previews: some View {
        CosmicHUDSettings()
            .previewDisplayName("HUD Settings")
    }
}
#endif