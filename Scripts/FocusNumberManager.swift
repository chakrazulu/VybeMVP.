import CoreLocation

class FocusNumberManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentFocusNumber: Int = 0
    @Published var selectedFocusNumber: Int = 0
    @Published var matchLogs: [String] = []
    @Published var isAutoUpdateEnabled: Bool = false
    @Published var lastKnownLocation: CLLocation?
    
    private var timer: Timer?
    private var locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        print("🚀 Initializing FocusNumberManager")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = false
        
        // Request permission immediately
        print("📱 Requesting location permission...")
        locationManager.requestWhenInUseAuthorization()
    }
    
    func testLocationPermissions() {
        print("\n🔍 Testing Location Services")
        print("System Location Services: \(CLLocationManager.locationServicesEnabled() ? "ON ✅" : "OFF ❌")")
        print("Authorization Status: \(authorizationStatusString(locationManager.authorizationStatus))")
        
        // Force immediate location update
        print("📍 Requesting immediate location update...")
        locationManager.requestLocation()
    }
    
    // Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("\n✅ Location Updated!")
        print("📍 Latitude: \(location.coordinate.latitude)")
        print("📍 Longitude: \(location.coordinate.longitude)")
        print("🎯 Accuracy: \(location.horizontalAccuracy)m")
        
        lastKnownLocation = location
        calculateFocusNumber(for: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\n❌ Location Error:")
        print("Error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("\n🔄 Authorization Changed:")
        print("New Status: \(authorizationStatusString(manager.authorizationStatus))")
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("✅ Permission granted - Starting updates")
            manager.startUpdatingLocation()
        case .denied:
            print("❌ Permission denied")
        case .restricted:
            print("⚠️ Permission restricted")
        case .notDetermined:
            print("⏳ Permission not determined")
        @unknown default:
            print("❓ Unknown authorization status")
        }
    }
    
    private func calculateFocusNumber(for location: CLLocation) {
        // Your existing focus number calculation logic
        print("🧮 Calculating focus number for location...")
        // Add your calculation here
    }
    
    private func startTimer() {
        stopTimer()
        print("\n⏰ Starting timer")
        locationManager.startUpdatingLocation() // Start continuous updates
        
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            print("\n🔄 Timer fired - Requesting location")
            self?.locationManager.requestLocation()
        }
        timer?.fire()
        isAutoUpdateEnabled = true
    }
    
    public func startUpdates() {
        startTimer()
    }
    
    public func stopUpdates() {
        stopTimer()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isAutoUpdateEnabled = false
        print("⏹️ Timer stopped")
    }
} 