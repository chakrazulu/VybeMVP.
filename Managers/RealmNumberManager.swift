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
    @Published private(set) var currentRealmNumber: Int = 1
    
    // Add strong reference to prevent deallocation
    private var retainedSelf: RealmNumberManager?
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D?
    private var isActive: Bool = false
    private var lastCalculationTime: Date?
    
    // Mock BPM values for testing
    private let mockBPMs: [Int] = [62, 75, 85, 95, 115, 135]
    private var currentMockBPMIndex = 0
    private var mockBPM: Int { mockBPMs[currentMockBPMIndex] }
    
    // Public getter for testing
    var currentMockBPM: Int { mockBPM }
    
    // For testing
    private var testDate: Date?
    
    // MARK: - Initialization
    override init() {
        super.init()
        print(ManagerState.initializing.description)
        setupManager()
        // Retain self after setup
        retainedSelf = self
    }
    
    private func setupManager() {
        // Setup location manager on main thread
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = Constants.locationAccuracy
            self.locationManager?.distanceFilter = Constants.locationUpdateDistance
            self.locationManager?.requestWhenInUseAuthorization()
            
            self.currentState = .waitingForLocation
            print(self.currentState.description)
            
            // Initial calculation
            self.calculateRealmNumber()
            
            // Start updates after setup
            self.startUpdates()
        }
    }
    
    // MARK: - Core Calculation Logic
    func calculateRealmNumber() {
        // Ensure we're on main thread for UI updates
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.calculateRealmNumber()
            }
            return
        }
        
        print("\n🔮 RealmNumberManager - Starting calculation...")
        
        // Get UTC date components
        let utcNow = getCurrentUTCDate()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        // Extract components
        let hour = calendar.component(.hour, from: utcNow)
        let minute = calendar.component(.minute, from: utcNow)
        let day = calendar.component(.day, from: utcNow)
        let month = calendar.component(.month, from: utcNow)
        
        // Calculate time sum (hour + minute)
        let timeSum = reduceToSingleDigit(hour + minute)
        
        // Calculate date sum (day + month)
        let dateSum = reduceToSingleDigit(day + month)
        
        // Process location
        var locationSum = 0
        if let location = currentLocation {
            let latDegrees = String(format: "%.6f", abs(location.latitude))
                .replacingOccurrences(of: ".", with: "")
            let lonDegrees = String(format: "%.6f", abs(location.longitude))
                .replacingOccurrences(of: ".", with: "")
            
            let latSum = reduceToSingleDigit(Int(latDegrees) ?? 0)
            let lonSum = reduceToSingleDigit(Int(lonDegrees) ?? 0)
            locationSum = reduceToSingleDigit(latSum + lonSum)
        }
        
        // Get BPM value and reduce
        let bpmSum = reduceToSingleDigit(mockBPM)
        
        // Calculate final number
        let totalSum = timeSum + dateSum + locationSum + bpmSum
        let finalNumber = reduceToSingleDigit(totalSum)
        
        let oldNumber = currentRealmNumber
        if finalNumber != oldNumber || testDate != nil {
            currentRealmNumber = finalNumber
            print("🔄 Realm Number changed from \(oldNumber) to \(finalNumber)")
            print("\n🔢 Component Breakdown:")
            print("Time: \(hour)h:\(minute)m = \(timeSum)")
            print("Date: \(month)/\(day) = \(dateSum)")
            print("Location: \(locationSum)")
            print("BPM: \(bpmSum)")
            print("Total: \(totalSum) → \(finalNumber)")
            
            if testDate != nil {
                print("\n🧪 Test Calculation Breakdown:")
                print("Time Sum (\(hour) + \(minute) = \(hour + minute) → \(timeSum)): \(timeSum)")
                print("Date Sum (\(day) + \(month) = \(day + month) → \(dateSum)): \(dateSum)")
                print("Location Sum (\(locationSum)): \(locationSum)")
                print("BPM Sum (\(mockBPM) → \(bpmSum)): \(bpmSum)")
                print("Total Sum (\(timeSum) + \(dateSum) + \(locationSum) + \(bpmSum) = \(totalSum) → \(finalNumber))")
            }
        }
    }
    
    func reduceToSingleDigit(_ number: Int) -> Int {
        var num = abs(number)
        while num > 9 {
            num = String(num).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return num
    }
    
    // MARK: - Test Support
    func setTestDate(_ date: Date) {
        testDate = date
        calculateRealmNumber()
    }
    
    func cycleToNextMockBPM() {
        currentMockBPMIndex = (currentMockBPMIndex + 1) % mockBPMs.count
        calculateRealmNumber()
    }
    
    func updateLocation(_ location: CLLocation) {
        let oldLocation = currentLocation
        currentLocation = location.coordinate
        
        // Always trigger calculation on location update during tests
        if testDate != nil || oldLocation == nil || 
           abs(oldLocation!.latitude - location.coordinate.latitude) > 0.001 ||
           abs(oldLocation!.longitude - location.coordinate.longitude) > 0.001 {
            calculateRealmNumber()
        }
    }
    
    private func getCurrentUTCDate() -> Date {
        if let testDate = testDate {
            return testDate
        }
        let current = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: current)
        return calendar.date(from: components) ?? current
    }
    
    func startUpdates() {
        guard !isActive else { return }
        
        DispatchQueue.main.async {
            self.isActive = true
            self.currentState = .active
            print(self.currentState.description)
            
            // Stop existing timer if any
            self.stopTimer()
            
            // Start location updates
            self.locationManager?.startUpdatingLocation()
            
            // Create new timer
            self.timer = Timer.scheduledTimer(withTimeInterval: Constants.timerUpdateInterval, repeats: true) { [weak self] _ in
                self?.calculateRealmNumber()
            }
            self.timer?.tolerance = 1.0
            
            // Force immediate calculation
            self.calculateRealmNumber()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func stopUpdates() {
        isActive = false
        currentState = .stopped
        print(currentState.description)
        stopTimer()
        locationManager?.stopUpdatingLocation()
    }
    
    deinit {
        stopUpdates()
        retainedSelf = nil
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
        print("   Raw Time Sum: \(hour) + \(minute) = \(hour + minute)")
        print("\n📅 UTC Date Components:")
        print("   Day: \(day)")
        print("   Month: \(month)")
        print("   Raw Date Sum: \(day) + \(month) = \(day + month)")
        print("\n🧮 Raw Components:")
        print("   Time Sum: \(hour + minute)")
        print("   Date Sum: \(day + month)")
        print("   Location: \(getLocationDescription())")
        print("   Location Sum: \(locationSum)\(locationSum == 0 ? " (Waiting for location)" : "")")
        print("   BPM: \(mockBPM) → \(bpmValue) (\(getActivityLevelDescription()))")
        print("\n📊 Transcendental Reduction:")
        print("   Raw Total: \(hour + minute) + \(day + month) + \(locationSum) + \(bpmValue) = \(totalSum)")
        print("   Reduction Steps: \(getReductionSteps(totalSum))")
        print("   Final Number: \(result)")
        print("🌟 ===============================\n")
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
