import SwiftUI
import ActivityKit
import Combine

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
    private let realmNumberManager = RealmNumberManager()
    
    // MARK: - Private Properties
    private var isInitialized = false
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupNavigationObserver()
    }
    
    // MARK: - Public Methods
    
    /// Initializes the Cosmic HUD system when app launches
    func initializeHUD() async {
        guard !isInitialized else { return }
        
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
            let contentState = CosmicHUDWidgetAttributes.ContentState(
                rulerNumber: hudData.rulerNumber,
                realmNumber: realmNumberManager.currentRealmNumber,
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
    
    /// Stops the Cosmic HUD Live Activity
    func stopHUD() async {
        guard #available(iOS 16.1, *) else { return }
        
        if let activity = hudActivity {
            print("Claude: 🛑 Ending Live Activity: \(activity.id)")
            await activity.end(nil, dismissalPolicy: .immediate)
            await MainActor.run {
                self.hudActivity = nil
            }
        }
        
        // Let the system handle cleanup naturally
        
        hudManager.stopHUD()
        await MainActor.run {
            self.isHUDEnabled = false
        }
        
        print("Claude: ✅ Cosmic HUD stopped and cleaned up")
    }
    
    /// Updates the HUD with fresh cosmic data
    func updateHUD() async {
        guard #available(iOS 16.1, *),
              let activity = hudActivity,
              let hudData = hudManager.currentHUDData else {
            return
        }
        
        let updatedState = CosmicHUDWidgetAttributes.ContentState(
            rulerNumber: hudData.rulerNumber,
            realmNumber: realmNumberManager.currentRealmNumber,
            aspectDisplay: formatAspectForHUD(hudData.dominantAspect),
            element: HUDGlyphMapper.element(for: hudData.element),
            lastUpdate: Date()
        )
        
        await activity.update(.init(state: updatedState, staleDate: nil))
        print("Claude: HUD updated successfully")
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
            await stopHUD()
        } else {
            await startHUD()
        }
    }
    
    // MARK: - App State Integration
    
    /// Should be called when app enters foreground
    func appDidBecomeActive() async {
        if isHUDEnabled {
            await hudManager.refreshHUDData()
            await updateHUD()
        }
    }
    
    /// Should be called when app enters background
    func appDidEnterBackground() {
        // HUD continues running in background via Live Activity
        print("Claude: App backgrounded, HUD continues via Live Activity")
    }
    
    /// Should be called when focus number changes
    func focusNumberDidChange(_ newNumber: Int) async {
        if isHUDEnabled {
            await hudManager.refreshHUDData()
            await updateHUD()
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