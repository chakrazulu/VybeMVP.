import Foundation
import Combine
import CoreLocation

class RealmNumberManager: NSObject, ObservableObject {
    // MARK: - Constants
    private enum Constants {
        // Time intervals
        static let timerUpdateInterval: TimeInterval = 60    // seconds
        static let calculationThrottle: TimeInterval = 1.0   // minimum time between calculations
        
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
    
    // Cache for expensive calculations
    private var lastCalculationResult: (components: (time: Int, date: Int, location: Int, bpm: Int), result: Int)?
    
    // HealthKit integration
    private let healthKitManager = HealthKitManager.shared
    @Published private var currentBPM: Int = 0
    
    // Mock BPM values for testing
    private let mockBPMs: [Int] = [62, 75, 85, 95, 115, 135]
    private var currentMockBPMIndex = 0
    private var mockBPM: Int { mockBPMs[currentMockBPMIndex] }
    
    // Public getter for testing
    var currentMockBPM: Int { mockBPM }
    
    // For testing
    private var testDate: Date?
    
    // MARK: - Cache Management
    private struct CacheEntry {
        let components: (time: Int, date: Int, location: Int, bpm: Int)
        let result: Int
        let timestamp: Date
    }
    
    // Enhanced cache with prediction
    private var calculationCache: [String: CacheEntry] = [:]
    private var nextPredictedNumber: Int?
    
    // MARK: - Prediction Validation
    private var predictionAccuracy: [Bool] = [] // Track last 10 predictions
    private let maxPredictionHistory = 10
    
    // Add cancellables property for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // Add property for last valid BPM
    private var lastValidBPM: Int = 0
    
    // MARK: - Initialization
    override init() {
        super.init()
        print(ManagerState.initializing.description)
        setupManager()
        setupHealthKitObserver()
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
    
    private func setupHealthKitObserver() {
        // Observe changes in heart rate through Combine
        healthKitManager.$currentHeartRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] heartRate in
                if let heartRate = heartRate {
                    print("💓 Received heart rate update via Combine: \(Int(round(heartRate))) BPM")
                    self?.currentBPM = Int(round(heartRate))
                    self?.calculateRealmNumber()
                }
            }
            .store(in: &cancellables)
            
        // Also observe heart rate updates through NotificationCenter as backup
        NotificationCenter.default.publisher(for: HealthKitManager.heartRateUpdated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if let heartRate = notification.userInfo?["heartRate"] as? Double {
                    print("💓 Received heart rate update via Notification: \(Int(round(heartRate))) BPM")
                    self?.currentBPM = Int(round(heartRate))
                    self?.calculateRealmNumber()
                }
            }
            .store(in: &cancellables)
            
        // Initial heart rate check
        if let currentHeartRate = healthKitManager.currentHeartRate {
            print("💓 Initial heart rate value: \(Int(round(currentHeartRate))) BPM")
            currentBPM = Int(round(currentHeartRate))
            calculateRealmNumber()
        }
    }
    
    // MARK: - Core Calculation Logic
    func calculateRealmNumber() {
        // If this is a real calculation (not a prediction), validate previous prediction
        if let predicted = nextPredictedNumber {
            // Ensure we're on main thread for UI updates
            if !Thread.isMainThread {
                DispatchQueue.main.async { [weak self] in
                    self?.calculateRealmNumber()
                }
                return
            }
            
            // Get the actual number
            let actualNumber = calculatePredictedNumber(for: Date())
            validatePrediction(predicted, actual: actualNumber)
        }
        
        // Continue with normal calculation
        performCalculation()
    }
    
    private func performCalculation() {
        // Ensure we're on main thread for UI updates
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.calculateRealmNumber()
            }
            return
        }
        
        // Throttle calculations
        if let lastTime = lastCalculationTime,
           Date().timeIntervalSince(lastTime) < Constants.calculationThrottle {
            return
        }
        lastCalculationTime = Date()
        
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
        
        // Use real BPM from HealthKit, falling back to last valid reading
        let actualBPM = currentBPM
        let bpmValue: Int
        let bpmSum: Int
        
        if actualBPM > 0 {
            print("💓 Using actual heart rate: \(actualBPM) BPM")
            bpmValue = actualBPM
            lastValidBPM = actualBPM  // Store this valid reading
        } else if lastValidBPM > 0 {
            print("ℹ️ Using last valid heart rate: \(lastValidBPM) BPM")
            bpmValue = lastValidBPM
        } else {
            print("⚠️ No heart rate history available yet")
            bpmValue = actualBPM
        }
        
        bpmSum = reduceToSingleDigit(bpmValue)
        
        // Add a small dynamic factor based on actual BPM variability
        let dynamicFactor = reduceToSingleDigit(bpmValue % 3)
        
        // Check cache for identical components
        if let cached = lastCalculationResult,
           cached.components.time == timeSum &&
           cached.components.date == dateSum &&
           cached.components.location == locationSum &&
           cached.components.bpm == bpmSum {
            currentRealmNumber = cached.result
            return
        }
        
        // Calculate final number using pure addition
        let totalSum = timeSum + dateSum + locationSum + bpmSum + dynamicFactor
        let finalNumber = reduceToSingleDigit(totalSum)
        
        // Update cache
        lastCalculationResult = ((timeSum, dateSum, locationSum, bpmSum), finalNumber)
        
        let oldNumber = currentRealmNumber
        if finalNumber != oldNumber || testDate != nil {
            currentRealmNumber = finalNumber
            print("🔄 Realm Number changed from \(oldNumber) to \(finalNumber)")
            print("\n🔢 Component Breakdown:")
            print("Time: \(hour)h:\(minute)m → \(timeSum)")
            print("Date: \(month)/\(day) → \(dateSum)")
            print("Location: \(locationSum)")
            print("BPM: \(bpmValue) → \(bpmSum)")
            print("Dynamic Factor: \(dynamicFactor)")
            print("Total: \(totalSum) → \(finalNumber)")
            
            if testDate != nil {
                print("\n🧪 Test Calculation Breakdown:")
                print("Time Sum (\(hour) + \(minute) = \(hour + minute) → \(timeSum))")
                print("Date Sum (\(day) + \(month) = \(day + month) → \(dateSum))")
                print("Location Sum (\(locationSum))")
                print("BPM Sum (\(bpmSum))")
                print("Dynamic Factor: \(dynamicFactor)")
                print("Total Sum (\(timeSum) + \(dateSum) + \(locationSum) + \(bpmSum) + \(dynamicFactor) = \(totalSum) → \(finalNumber))")
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
            print("\n🚀 Starting RealmNumberManager updates...")
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
            
            // Verify timer creation
            if self.timer != nil {
                print("✅ Realm timer started successfully")
            } else {
                print("❌ Failed to start realm timer")
                // Attempt recovery
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    print("🔄 Attempting timer recovery...")
                    self.startUpdates()
                }
            }
            
            // Force immediate calculation
            self.calculateRealmNumber()
        }
    }
    
    private func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
            print("✅ Realm timer stopped successfully")
        }
    }
    
    func stopUpdates() {
        print("\n⏹ Stopping RealmNumberManager updates...")
        isActive = false
        currentState = .stopped
        print(currentState.description)
        stopTimer()
        locationManager?.stopUpdatingLocation()
        print("✅ RealmNumberManager stopped successfully")
    }
    
    deinit {
        print("\n🗑 RealmNumberManager deinitializing...")
        stopUpdates()
        retainedSelf = nil
        print("✅ RealmNumberManager cleanup completed")
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
    
    // MARK: - Cache Management
    private func updateCache(components: (time: Int, date: Int, location: Int, bpm: Int), result: Int) {
        let cacheKey = "\(components.time)|\(components.date)|\(components.location)|\(components.bpm)"
        calculationCache[cacheKey] = CacheEntry(components: components, result: result, timestamp: Date())
        
        // Predict next number based on patterns
        predictNextNumber()
    }
    
    private func validatePrediction(_ predicted: Int, actual: Int) {
        let wasCorrect = predicted == actual
        predictionAccuracy.append(wasCorrect)
        
        // Keep only last 10 predictions
        if predictionAccuracy.count > maxPredictionHistory {
            predictionAccuracy.removeFirst()
        }
        
        // Log prediction accuracy
        let accuracy = Double(predictionAccuracy.filter { $0 }.count) / Double(predictionAccuracy.count) * 100
        print("\n🔮 Prediction Validation:")
        print("   Predicted: \(predicted)")
        print("   Actual: \(actual)")
        print("   Correct: \(wasCorrect ? "✅" : "❌")")
        print("   Recent Accuracy: \(String(format: "%.1f%%", accuracy))")
    }
    
    private func predictNextNumber() {
        // Calculate the next likely number based on current time and patterns
        let calendar = Calendar.current
        let nextMinute = calendar.date(byAdding: .minute, value: 1, to: Date()) ?? Date()
        
        // Store current state
        let currentComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nextMinute)
        
        // Pre-calculate the next number
        let prediction = calculatePredictedNumber(for: nextMinute)
        nextPredictedNumber = prediction
        
        print("\n🔮 Next Minute Prediction:")
        print("   Time: \(currentComponents.hour ?? 0):\(currentComponents.minute ?? 0)")
        print("   Predicted Number: \(prediction)")
    }
    
    private func calculatePredictedNumber(for date: Date) -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = calendar.dateComponents([.hour, .minute, .day, .month], from: date)
        
        // Calculate components
        let timeSum = reduceToSingleDigit((components.hour ?? 0) + (components.minute ?? 0))
        let dateSum = reduceToSingleDigit((components.day ?? 1) + (components.month ?? 1))
        
        // Use current location and BPM as they likely won't change in a minute
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
        
        let bpmSum = reduceToSingleDigit(mockBPM)
        
        // Calculate final prediction
        let totalSum = timeSum + dateSum + locationSum + bpmSum
        return reduceToSingleDigit(totalSum)
    }
    
    private func checkCache(components: (time: Int, date: Int, location: Int, bpm: Int)) -> Int? {
        let cacheKey = "\(components.time)|\(components.date)|\(components.location)|\(components.bpm)"
        guard let cached = calculationCache[cacheKey],
              Date().timeIntervalSince(cached.timestamp) < 60 else { // Cache valid for 1 minute
            calculationCache[cacheKey] = nil // Clear expired cache
            return nil
        }
        return cached.result
    }
    
    // Cleanup old cache entries periodically
    private func cleanupCache() {
        let oldDate = Date().addingTimeInterval(-60) // Remove entries older than 1 minute
        calculationCache = calculationCache.filter { $0.value.timestamp > oldDate }
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
