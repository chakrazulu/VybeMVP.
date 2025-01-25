import Foundation
import Combine
import CoreLocation
import CoreData
import os.log

class FocusNumberManager: NSObject, ObservableObject {
    @Published var currentFocusNumber: Int = 0
    @Published var selectedFocusNumber: Int = 0
    @Published var matchLogs: [FocusMatch] = []  // Changed to use Core Data entity
    @Published var isAutoUpdateEnabled: Bool = false
    @Published var realmNumber: Int = 0  // To track realm number
    
    private var timer: Timer?
    private var locationManager = CLLocationManager()
    private var _currentLocation: CLLocationCoordinate2D?
    private var viewContext: NSManagedObjectContext
    
    static let validFocusNumbers = 1...9
    static let defaultFocusNumber = 1
    
    // UTC Calendar for calculations
    private let utcCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
    
    // Local Calendar for display
    private let localCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        return calendar
    }()
    
    var currentLocation: CLLocation? {
        get {
            guard let coordinate = _currentLocation else { return nil }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        set {
            _currentLocation = newValue?.coordinate
        }
    }
    
    private var lastUpdateTime: Date = Date()
    private let minimumUpdateInterval: TimeInterval = 60 // 1 minute
    
    // Mock BPM values for testing
    private let mockBPMs: [Int] = [
        62,   // Resting/Meditation
        75,   // Normal relaxed state
        85,   // Light activity
        95,   // Moderate activity
        115,  // Exercise
        135   // Peak exercise
    ]
    private var currentMockBPMIndex = 0
    
    // Helper to cycle through mock BPMs
    private var currentMockBPM: Int {
        let bpm = mockBPMs[currentMockBPMIndex]
        Logger.debug("🎯 Using mock BPM #\(currentMockBPMIndex + 1): \(bpm)", category: Logger.focus)
        return bpm
    }
    
    // Function to test next mock BPM
    func cycleToNextMockBPM() {
        currentMockBPMIndex = (currentMockBPMIndex + 1) % mockBPMs.count
        Logger.debug("🔄 Cycling to next mock BPM...", category: Logger.focus)
        calculateFocusNumber()
    }
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        super.init()
        setupLocationManager()
        loadPreferences()
        loadMatchLogs()
        Logger.debug("📱 Manager initialized with number: \(selectedFocusNumber)", category: Logger.focus)
    }
    
    private func loadPreferences() {
        let preferences = UserPreferences.fetch(in: viewContext)
        selectedFocusNumber = Int(preferences.lastSelectedNumber)
        
        // Ensure we never have 0 as a focus number
        if selectedFocusNumber == 0 {
            selectedFocusNumber = Self.defaultFocusNumber
            UserPreferences.save(
                in: viewContext,
                lastSelectedNumber: Int16(Self.defaultFocusNumber),
                isAutoUpdateEnabled: preferences.isAutoUpdateEnabled
            )
        }
        
        isAutoUpdateEnabled = preferences.isAutoUpdateEnabled
        Logger.debug("Loaded preferences - Number: \(selectedFocusNumber), Auto Update: \(isAutoUpdateEnabled)", category: Logger.focus)
        
        if isAutoUpdateEnabled {
            startUpdates()
        }
    }
    
    // MARK: - Match Logs
    
    func loadMatchLogs() {
        let request = NSFetchRequest<FocusMatch>(entityName: "FocusMatch")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusMatch.timestamp, ascending: false)]
        
        do {
            matchLogs = try viewContext.fetch(request)
            print("📱 Loaded \(matchLogs.count) matches from storage")
        } catch {
            print("❌ Failed to fetch matches: \(error)")
        }
    }
    
    func saveMatch() {
        // Create a new FocusMatch entity
        let match = FocusMatch(context: viewContext)
        match.timestamp = Date()
        match.chosenNumber = Int16(selectedFocusNumber)
        match.matchedNumber = Int16(currentFocusNumber)
        
        print("\n🌈 ================================")
        print("🌈         MATCH DETECTED!         ")
        print("🌈 ================================")
        print("📊 Match Details:")
        print("   Time: \(match.timestamp)")
        print("   Focus Number: \(currentFocusNumber)")
        print("   Selected Number: \(selectedFocusNumber)")
        print("   Realm Number: \(realmNumber)")
        print("   Total Matches: \(matchLogs.count + 1)")
        print("🌈 ================================\n")
        
        // Save to Core Data
        do {
            try viewContext.save()
            print("✅ Match saved successfully")
            print("📝 Current matches count: \(matchLogs.count + 1)")
            loadMatchLogs() // Reload to refresh the UI
            print("✨ Recent matches updated - new count: \(matchLogs.count)")
        } catch {
            print("❌ Failed to save match: \(error.localizedDescription)")
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 500
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // Start location updates immediately
        Logger.debug("📍 Location updates started", category: Logger.location)
    }

    // Calculate Focus Number based on UTC time, location, and BPM
    func calculateFocusNumber() {
        let utcNow = Date()
        let components = utcCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: utcNow)
        
        // Convert year to sum of digits (2025 -> 2+0+2+5 = 9)
        let yearString = String(components.year ?? 0)
        let yearSum = yearString.compactMap { Int(String($0)) }.reduce(0, +)
        
        // Reduce each component to a single digit
        let monthSum = reduceToSingleDigit(components.month ?? 0)
        let daySum = reduceToSingleDigit(components.day ?? 0)
        let hourSum = reduceToSingleDigit(components.hour ?? 0)
        let minuteSum = reduceToSingleDigit(components.minute ?? 0)
        
        // Sum all time components and reduce again
        let timeSum = reduceToSingleDigit(yearSum + monthSum + daySum + hourSum + minuteSum)
        
        Logger.debug("⏰ Time Components:", category: Logger.focus)
        Logger.debug("   Year(\(components.year ?? 0)) digits: \(yearString.map { String($0) }.joined(separator: "+")) = \(yearSum)", category: Logger.focus)
        Logger.debug("   Month(\(components.month ?? 0)): \(monthSum)", category: Logger.focus)
        Logger.debug("   Day(\(components.day ?? 0)): \(daySum)", category: Logger.focus)
        Logger.debug("   Hour(\(components.hour ?? 0)): \(hourSum)", category: Logger.focus)
        Logger.debug("   Minute(\(components.minute ?? 0)): \(minuteSum)", category: Logger.focus)
        Logger.debug("   Time Sum (reduced): \(timeSum)", category: Logger.focus)
        
        // Add location influence if available
        var locationFactor = 0
        if let location = currentLocation {
            // Convert coordinates to strings and sum their digits
            let latString = String(format: "%.4f", abs(location.coordinate.latitude))
            let longString = String(format: "%.4f", abs(location.coordinate.longitude))
            
            let latDigits = latString.compactMap { $0.isNumber ? Int(String($0)) : nil }
            let longDigits = longString.compactMap { $0.isNumber ? Int(String($0)) : nil }
            
            let latSum = reduceToSingleDigit(latDigits.reduce(0, +))
            let longSum = reduceToSingleDigit(longDigits.reduce(0, +))
            
            // Combine and reduce location factors
            locationFactor = reduceToSingleDigit(latSum + longSum)
            
            Logger.debug("📍 Location Analysis:", category: Logger.focus)
            Logger.debug("   Raw Latitude: \(location.coordinate.latitude)", category: Logger.focus)
            Logger.debug("   → Digits: \(latDigits.map(String.init).joined(separator: "+")) = \(latDigits.reduce(0, +)) reduces to \(latSum)", category: Logger.focus)
            Logger.debug("   Raw Longitude: \(location.coordinate.longitude)", category: Logger.focus)
            Logger.debug("   → Digits: \(longDigits.map(String.init).joined(separator: "+")) = \(longDigits.reduce(0, +)) reduces to \(longSum)", category: Logger.focus)
            Logger.debug("   Location Factor (reduced): \(locationFactor)", category: Logger.focus)
        } else {
            Logger.debug("📍 Waiting for location data...", category: Logger.focus)
        }
        
        // BPM calculation
        let rawBPM = currentMockBPM
        let bpmDigits = String(rawBPM).map { Int(String($0))! }
        let bpmSum = bpmDigits.reduce(0, +)
        let bpmFactor = reduceToSingleDigit(bpmSum)
        
        Logger.debug("💓 BPM Analysis:", category: Logger.focus)
        Logger.debug("   Raw BPM: \(rawBPM)", category: Logger.focus)
        Logger.debug("   → Digits: \(bpmDigits.map(String.init).joined(separator: "+")) = \(bpmSum)", category: Logger.focus)
        Logger.debug("   → Reduced: \(bpmSum) → \(bpmFactor)", category: Logger.focus)
        
        // Combine all factors and reduce one final time
        let totalValue = reduceToSingleDigit(timeSum + locationFactor + bpmFactor)
        
        // Update current focus number
        currentFocusNumber = totalValue
        
        Logger.debug("🧮 Final Calculation:", category: Logger.focus)
        Logger.debug("   Time Sum (reduced): \(timeSum)", category: Logger.focus)
        Logger.debug("   Location Factor (reduced): \(locationFactor)", category: Logger.focus)
        Logger.debug("   BPM Factor (reduced): \(bpmFactor)", category: Logger.focus)
        Logger.debug("   Combined Total (reduced): \(totalValue)", category: Logger.focus)
        Logger.debug("📊 Final Focus Number: \(currentFocusNumber)", category: Logger.focus)
        
        Logger.debug("🎭 Current State:", category: Logger.focus)
        Logger.debug("   Selected Number: \(selectedFocusNumber)", category: Logger.focus)
        Logger.debug("   Current Focus Number: \(currentFocusNumber)", category: Logger.focus)
        Logger.debug("   Realm Number: \(realmNumber)", category: Logger.focus)
        Logger.debug("   Auto-Update: \(isAutoUpdateEnabled)", category: Logger.focus)
        Logger.debug("   Match Count: \(matchLogs.count)", category: Logger.focus)
        
        // Check for matches with both selected number and realm number
        checkForMatches()
    }
    
    // Change from private to internal for testing
    func reduceToSingleDigit(_ number: Int) -> Int {
        var num = abs(number)
        while num > 9 {
            let digits = String(num).compactMap { Int(String($0)) }
            num = digits.reduce(0, +)
        }
        return num
    }

    func startUpdates() {
        stopUpdates() // Clear any existing timer
        calculateFocusNumber() // Initial calculation
        
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.calculateFocusNumber()
        }
        
        isAutoUpdateEnabled = true
        saveAutoUpdatePreference(true)
        Logger.debug("▶️ Started focus number updates", category: Logger.focus)
    }

    func stopUpdates() {
        timer?.invalidate()
        timer = nil
        isAutoUpdateEnabled = false
        saveAutoUpdatePreference(false)
        Logger.debug("⏹ Stopped focus number updates", category: Logger.focus)
    }

    private func saveAutoUpdatePreference(_ enabled: Bool) {
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(selectedFocusNumber),
            isAutoUpdateEnabled: enabled
        )
    }

    func checkForMatch() {
        guard currentFocusNumber > 0 && currentFocusNumber == selectedFocusNumber else {
            return
        }
        saveMatch()
    }
    
    var effectiveFocusNumber: Int {
        let number = currentFocusNumber == 0 ? selectedFocusNumber : currentFocusNumber
        return max(1, min(number, 9))  // Ensure valid range
    }
    
    func userDidPickFocusNumber(_ number: Int) {
        let validNumber = max(1, min(number, 9))
        
        // Only update if the number actually changed
        guard validNumber != selectedFocusNumber else { return }
        
        selectedFocusNumber = validNumber
        
        // If current focus number is 0 or invalid, update it
        if currentFocusNumber < 1 || currentFocusNumber > 9 {
            currentFocusNumber = validNumber
        }
        
        // Save to Core Data
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(validNumber),
            isAutoUpdateEnabled: isAutoUpdateEnabled
        )
        
        // Check for match after a brief delay to allow animations to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.checkForMatch()
        }
    }
    
    func enableAutoFocusNumber() {
        startUpdates()
    }

    /// Tests location permissions and prints detailed status to console
    func testLocationPermissions() {
        print("\n📍 LOCATION PERMISSIONS TEST")
        print("----------------------------------------")
        
        // Check current authorization status
        let status = locationManager.authorizationStatus
        print("🔍 Current Status: \(authorizationStatusString(status))")
        
        // Start location updates if authorized
        switch status {
        case .notDetermined:
            print("⏳ Requesting location permission...")
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted:
            print("⚠️ Location access is restricted!")
            print("💡 TIP: Check parental controls or device management settings")
            
        case .denied:
            print("🚫 Location access denied!")
            print("💡 TIP: User needs to enable location in Settings > Privacy > Location Services")
            
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Location permission granted!")
            print("🎯 Starting location updates...")
            locationManager.startUpdatingLocation()
            
        @unknown default:
            print("❓ Unknown authorization status")
        }
        print("----------------------------------------\n")
    }

    /// Converts location authorization status to readable string
    private func authorizationStatusString(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedWhenInUse: return "Authorized When In Use"
        case .authorizedAlways: return "Authorized Always"
        @unknown default: return "Unknown"
        }
    }

    // Add this method to update realm number
    func updateRealmNumber(_ newValue: Int) {
        if realmNumber != newValue {
            print("\n🔄 Realm number changed: \(realmNumber) → \(newValue)")
            realmNumber = newValue
            checkForMatches()
        }
    }
    
    private func checkForMatches() {
        if currentFocusNumber == selectedFocusNumber {
            print("\n🎯 SELECTED MATCH! Focus number matches your selected number!")
            saveMatch()
        }
        
        if currentFocusNumber == realmNumber {
            print("\n🌟 REALM MATCH! Focus number matches the realm number!")
            saveMatch()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension FocusNumberManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        
        // Only update if location has changed significantly
        if let currentLoc = _currentLocation {
            let oldLocation = CLLocation(latitude: currentLoc.latitude, longitude: currentLoc.longitude)
            let newLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            guard oldLocation.distance(from: newLocation) > 500 else { return }
        }
        
        _currentLocation = location
        Logger.debug("📍 Location updated: \(location.latitude), \(location.longitude)", category: Logger.location)
        calculateFocusNumber() // Recalculate with new location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .denied:
                stopUpdates()
                Logger.error("❌ Location access denied", category: Logger.location)
            case .locationUnknown:
                Logger.debug("⚠️ Location temporarily unavailable", category: Logger.location)
            default:
                Logger.error("❌ Location error: \(error.localizedDescription)", category: Logger.location)
            }
        }
    }
}
