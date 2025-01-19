import Foundation
import Combine
import CoreLocation
import CoreData

class FocusNumberManager: NSObject, ObservableObject {
    @Published var currentFocusNumber: Int = 0
    @Published var selectedFocusNumber: Int = 0
    @Published var matchLogs: [FocusMatch] = []  // Changed to use Core Data entity
    @Published var isAutoUpdateEnabled: Bool = false
    
    private var timer: Timer?
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        super.init()
        setupLocationManager()
        loadPreferences()
        loadMatchLogs()
        print("📱 Manager initialized with number: \(selectedFocusNumber)")
    }
    
    private func loadPreferences() {
        let preferences = UserPreferences.fetch(in: viewContext)
        selectedFocusNumber = Int(preferences.lastSelectedNumber)
        isAutoUpdateEnabled = preferences.isAutoUpdateEnabled
        print("📱 Loaded preferences - Selected Number: \(selectedFocusNumber), Auto Update: \(isAutoUpdateEnabled)")
        
        if isAutoUpdateEnabled {
            startUpdates()
        }
    }
    
    private func saveMatch() {
        guard let location = currentLocation else { return }
        
        // Create and save the match
        _ = FocusMatch.create(
            in: viewContext,
            chosenNumber: Int16(selectedFocusNumber),
            matchedNumber: Int16(currentFocusNumber),
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        do {
            try viewContext.save()
            loadMatchLogs()
            print("✅ Match saved successfully")
            print("📝 Current matches count: \(matchLogs.count)")
        } catch {
            print("❌ Failed to save match: \(error)")
        }
    }
    
    private func loadMatchLogs() {
        let request = NSFetchRequest<FocusMatch>(entityName: "FocusMatch")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FocusMatch.timestamp, ascending: false)]
        
        do {
            matchLogs = try viewContext.fetch(request)
            print("📱 Loaded \(matchLogs.count) matches from storage")
        } catch {
            print("❌ Failed to fetch matches: \(error)")
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdates() {
        print("🕒 Starting focus number updates")
        stopUpdates() // Ensure no timer duplication
        isAutoUpdateEnabled = true
        
        // Start location updates
        locationManager.startUpdatingLocation()
        
        // Create timer for updates
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in  // Changed to 10 seconds for testing
            self?.updateFocusNumber()
        }
        // Initial update
        updateFocusNumber()
    }

    func stopUpdates() {
        print("⏹️ Stopping focus number updates")
        timer?.invalidate()
        timer = nil
        isAutoUpdateEnabled = false
    }

    private func updateFocusNumber() {
        guard let coordinates = currentLocation else {
            print("📍 Location not available")
            return
        }
        
        print("\n🔢 FOCUS NUMBER CALCULATION STARTED")
        print("----------------------------------------")
        
        // Get current date and mock BPM
        let currentDate = Date()
        let mockBPM = 80
        
        print("📅 Current Date: \(currentDate)")
        print("📍 Location: \(coordinates.latitude), \(coordinates.longitude)")
        print("❤️ BPM: \(mockBPM)")
        
        // Calculate focus number
        currentFocusNumber = FocusNumberHelper.calculateFocusNumber(
            date: currentDate,
            coordinates: coordinates,
            bpm: mockBPM
        )
        
        print("✨ Calculated Focus Number: \(currentFocusNumber)")
        print("----------------------------------------\n")
        
        checkForMatch()
    }

    func checkForMatch() {
        if currentFocusNumber == selectedFocusNumber {
            saveMatch() // Now using Core Data to save matches
        }
    }
    
    func userDidPickFocusNumber(_ number: Int) {
        print("🔢 User picked number: \(number)")
        selectedFocusNumber = number
        // Save to Core Data
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(number),
            isAutoUpdateEnabled: isAutoUpdateEnabled
        )
        checkForMatch()
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
}

// MARK: - CLLocationManagerDelegate
extension FocusNumberManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            currentLocation = location
            print("📍 Location updated: \(location.latitude), \(location.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 Location error: \(error.localizedDescription)")
    }
}
