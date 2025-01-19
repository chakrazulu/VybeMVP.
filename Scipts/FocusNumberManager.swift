import Foundation
import Combine
import CoreLocation

class FocusNumberManager: NSObject, ObservableObject {
    @Published var currentFocusNumber: Int = 0
    @Published var selectedFocusNumber: Int = 0
    @Published var matchLogs: [String] = []
    @Published var isAutoUpdateEnabled: Bool = false
    
    private var timer: Timer?
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        setupLocationManager()
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
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
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
        
        // Get current date and mock BPM (replace with actual BPM later)
        let currentDate = Date()
        let mockBPM = 80 // Replace with actual BPM measurement
        
        // Calculate focus number using helper
        currentFocusNumber = FocusNumberHelper.calculateFocusNumber(
            date: currentDate,
            coordinates: coordinates,
            bpm: mockBPM
        )
        
        checkForMatch()
    }

    func checkForMatch() {
        if currentFocusNumber == selectedFocusNumber {
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
            let logEntry = "🎯 Match! Focus Number \(currentFocusNumber) at \(timestamp)"
            matchLogs.append(logEntry)
            print(logEntry)
        }
    }
    
    func userDidPickFocusNumber(_ number: Int) {
        selectedFocusNumber = number
        print("🎲 User selected focus number: \(number)")
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
        print("🚫 Location error: \(error.localizedDescription)")
    }
}
