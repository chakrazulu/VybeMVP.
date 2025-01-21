import Foundation
import Combine
import CoreLocation

class RealmNumberManager: NSObject, ObservableObject {
    // MARK: - Constants
    private enum Constants {
        // Time intervals
        static let timerUpdateInterval: TimeInterval = 60    // seconds
        
        // Location
        static let locationUpdateDistance: CLLocationDistance = 500  // meters
        static let locationAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
        
        // BPM ranges
        static let minBPM: Int = 62
        static let maxBPM: Int = 135
    }
    
    // MARK: - State Management
    @Published private(set) var currentState: ManagerState = .initializing
    
    enum ManagerState: String {
        case initializing = "Starting Up"
        case active = "Active"
        case waitingForLocation = "Waiting for Location"
        case stopped = "Stopped"
        
        var emoji: String {
            switch self {
            case .initializing: return "🚀"
            case .active: return "✅"
            case .waitingForLocation: return "📍"
            case .stopped: return "⏹"
            }
        }
        
        var description: String {
            return "\(emoji) Realm Manager: \(rawValue)"
        }
    }
    
    // MARK: - Published Properties
    @Published var currentRealmNumber: Int = 1
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D?
    
    // Mock BPM values for testing
    private let mockBPMs: [Int] = [
        Constants.minBPM,     // Resting/Meditation
        75,                   // Normal relaxed state
        85,                   // Light activity
        95,                   // Moderate activity
        115,                  // Exercise
        Constants.maxBPM      // Peak exercise
    ]
    
    private var currentMockBPMIndex = 0
    
    // Helper to get current mock BPM
    private var mockBPM: Int {
        return mockBPMs[currentMockBPMIndex]
    }
    
    // UTC Calendar for calculations
    private lazy var utcCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
    
    // MARK: - Initialization
    override init() {
        super.init()
        print(ManagerState.initializing.description)
        // Delay setup to prevent blocking main thread
        DispatchQueue.main.async { [weak self] in
            self?.setupManager()
        }
    }
    
    private func setupManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = Constants.locationAccuracy
        locationManager?.distanceFilter = Constants.locationUpdateDistance
        locationManager?.requestWhenInUseAuthorization()
        
        currentState = .waitingForLocation
        print(currentState.description)
        
        // Start with initial calculation
        calculateRealmNumber()
        
        // Setup timer on main thread
        DispatchQueue.main.async { [weak self] in
            self?.startUpdates()
        }
    }
    
    func calculateRealmNumber() {
        print("\n🔮 RealmNumberManager - Starting calculation...")
        
        // Perform calculation on background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                print("❌ RealmNumberManager - Self is nil during calculation")
                return
            }
            
            let utcNow = Date()
            
            // Time components
            let hour = self.utcCalendar.component(.hour, from: utcNow)
            let minute = self.utcCalendar.component(.minute, from: utcNow)
            let day = self.utcCalendar.component(.day, from: utcNow)
            let month = self.utcCalendar.component(.month, from: utcNow)
            
            // Calculate raw sums first
            let timeSum = hour + minute
            let dateSum = day + month
            
            // Location component with detailed logging
            var locationSum = 0
            if let location = self.currentLocation {
                let latDegrees = Int(abs(location.latitude))
                let lonDegrees = Int(abs(location.longitude))
                locationSum = latDegrees + lonDegrees
                print("📍 Location Update: \(String(format: "%.4f°, %.4f°", location.latitude, location.longitude))")
                print("   → Raw Sum: \(latDegrees)° + \(lonDegrees)° = \(locationSum)")
            } else {
                print("📍 Location: Waiting for data...")
            }
            
            // Get raw BPM value with activity level
            let bpmValue = self.mockBPM
            print("💓 BPM: \(bpmValue) (\(self.getActivityLevelDescription()))")
            
            // Calculate total of raw values
            let totalSum = timeSum + dateSum + locationSum + bpmValue
            
            // Only reduce at the very end
            let rawNumber = self.reduceToSingleDigit(totalSum)
            
            // Update debug logging to show the pure calculation
            DispatchQueue.main.async {
                self.debugLog(
                    hour: hour,
                    minute: minute,
                    timeSum: timeSum,
                    day: day,
                    month: month,
                    dateSum: dateSum,
                    locationSum: locationSum,
                    bpmValue: bpmValue,
                    totalSum: totalSum,
                    result: rawNumber
                )
                
                if self.currentRealmNumber != rawNumber {
                    print("🔄 Realm Number changed from \(self.currentRealmNumber) to \(rawNumber)")
                    self.currentRealmNumber = rawNumber
                } else {
                    print("✨ Realm Number remains at \(rawNumber)")
                }
            }
        }
    }
    
    private func reduceToSingleDigit(_ number: Int) -> Int {
        var num = abs(number)
        var reductionSteps: [Int] = [num]
        
        while num > 9 {
            let digits = String(num).compactMap { Int(String($0)) }
            num = digits.reduce(0, +)
            reductionSteps.append(num)
        }
        
        return num
    }
    
    private func getReductionSteps(_ number: Int) -> String {
        var num = abs(number)
        var steps: [String] = [String(num)]
        
        while num > 9 {
            let digits = String(num).compactMap { Int(String($0)) }
            let digitStr = digits.map(String.init).joined(separator: "+")
            num = digits.reduce(0, +)
            steps.append("\(digitStr)=\(num)")
        }
        
        return steps.joined(separator: " → ")
    }
    
    // Activity level descriptions
    private func getActivityLevelDescription() -> String {
        switch currentMockBPMIndex {
            case 0: return "Meditation"
            case 1: return "Resting"
            case 2: return "Light Activity"
            case 3: return "Moderate Activity"
            case 4: return "Exercise"
            case 5: return "Peak Exercise"
            default: return "Unknown"
        }
    }
    
    private func getLocationDescription() -> String {
        if let location = currentLocation {
            return String(format: "%.4f°, %.4f°", abs(location.latitude), abs(location.longitude))
        }
        return "Waiting for location..."
    }
    
    private func debugLog(hour: Int,
                         minute: Int,
                         timeSum: Int,
                         day: Int,
                         month: Int,
                         dateSum: Int,
                         locationSum: Int,
                         bpmValue: Int,
                         totalSum: Int,
                         result: Int) {
        print("\n🌟 ===============================")
        print("🌟    TRANSCENDENTAL CALC       ")
        print("🌟 ===============================")
        print("📅 UTC Time Components:")
        print("   Hour: \(hour)")
        print("   Minute: \(minute)")
        print("   Raw Time Sum: \(hour) + \(minute) = \(timeSum)")
        print("\n📅 UTC Date Components:")
        print("   Day: \(day)")
        print("   Month: \(month)")
        print("   Raw Date Sum: \(day) + \(month) = \(dateSum)")
        print("\n🧮 Raw Components:")
        print("   Time Sum: \(timeSum)")
        print("   Date Sum: \(dateSum)")
        print("   Location: \(getLocationDescription())")
        print("   Location Sum: \(locationSum)\(locationSum == 0 ? " (Waiting for location)" : "")")
        print("   BPM: \(bpmValue) (\(getActivityLevelDescription()))")
        print("\n📊 Transcendental Reduction:")
        print("   Raw Total: \(timeSum) + \(dateSum) + \(locationSum) + \(bpmValue) = \(totalSum)")
        print("   Reduction Steps: \(getReductionSteps(totalSum))")
        print("   Final Number: \(result)")
        print("🌟 ===============================\n")
    }
    
    func startUpdates() {
        print(ManagerState.active.description)
        currentState = .active
        stopUpdates()
        locationManager?.startUpdatingLocation()
        
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timerUpdateInterval, repeats: true) { [weak self] _ in
            self?.calculateRealmNumber()
        }
        
        calculateRealmNumber()
    }
    
    func stopUpdates() {
        currentState = .stopped
        print(currentState.description)
        timer?.invalidate()
        timer = nil
        locationManager?.stopUpdatingLocation()
    }
    
    deinit {
        stopUpdates()
    }
}

// MARK: - CLLocationManagerDelegate
extension RealmNumberManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        
        if let current = currentLocation {
            let oldLocation = CLLocation(latitude: current.latitude, longitude: current.longitude)
            let newLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            guard oldLocation.distance(from: newLocation) > Constants.locationUpdateDistance else { return }
        }
        
        currentLocation = location
        if currentState != .active {
            currentState = .active
            print(currentState.description)
        }
        calculateRealmNumber()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            currentState = .stopped
            print("\(currentState.description) - Location access denied")
            stopUpdates()
        }
    }
} 
