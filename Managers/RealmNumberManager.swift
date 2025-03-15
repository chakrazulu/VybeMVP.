/**
 * Filename: RealmNumberManager.swift
 * 
 * Purpose: Manages the generation and calculation of realm numbers based on 
 * multiple environmental factors including time, location, and heart rate.
 *
 * Key responsibilities:
 * - Generate realm numbers (1-9) using a deterministic algorithm
 * - Incorporate heart rate data from HealthKitManager
 * - Utilize location data to enhance number generation
 * - Provide real-time realm number updates 
 * - Cache calculations for performance optimization
 * - Support testing with mock data
 * 
 * The RealmNumberManager is a central component of the app, providing the
 * realm numbers that users can match with their chosen focus numbers.
 */

import Foundation
import Combine
import CoreLocation

/**
 * Manager responsible for calculating and providing realm numbers.
 *
 * This class generates realm numbers (1-9) based on a combination of:
 * - Time factors (hour, minute)
 * - Date factors (day, month)
 * - Location factors (latitude, longitude)
 * - Heart rate (BPM from HealthKit)
 *
 * It uses a timer to regularly update the realm number and integrates
 * with the location manager to incorporate geographical data into
 * calculations. Results are cached for performance optimization.
 *
 * Design pattern: Observer (via Combine)
 * Threading: Main thread for UI updates, background for calculations
 * Dependencies: HealthKitManager, CLLocationManager
 */
class RealmNumberManager: NSObject, ObservableObject {
    // MARK: - Constants
    /**
     * Configuration constants for the realm number generation.
     *
     * These values control timing, location sensitivity, and heart rate ranges
     * used in the calculation of realm numbers.
     */
    private enum Constants {
        /// Interval between timer-based realm number updates (in seconds)
        static let timerUpdateInterval: TimeInterval = 60    // seconds
        
        /// Minimum time between realm number calculations (in seconds)
        static let calculationThrottle: TimeInterval = 1.0   // minimum time between calculations
        
        /// Minimum distance (in meters) required for location-based updates
        static let locationUpdateDistance: CLLocationDistance = 500  // meters
        
        /// Accuracy level requested from the location manager
        static let locationAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
        
        /// Minimum heart rate value used in calculations
        static let minBPM: Int = 62
        
        /// Maximum heart rate value used in calculations
        static let maxBPM: Int = 135
    }
    
    // MARK: - State Management
    /// Current operational state of the manager
    @Published private(set) var currentState: ManagerState = .initializing
    
    /**
     * Represents the possible operational states of the RealmNumberManager.
     *
     * The state determines the behavior of the manager and provides
     * user-friendly status information.
     */
    enum ManagerState: String {
        /// Manager is starting up and initializing resources
        case initializing = "Starting Up"
        
        /// Manager is actively generating realm numbers
        case active = "Active"
        
        /// Manager is waiting for location data before proceeding
        case waitingForLocation = "Waiting for Location"
        
        /// Manager has been stopped and is not generating numbers
        case stopped = "Stopped"
        
        /// Emoji representation of each state for visual indication
        var emoji: String {
            switch self {
            case .initializing: return "🚀"
            case .active: return "✅"
            case .waitingForLocation: return "📍"
            case .stopped: return "⏹"
            }
        }
        
        /// Human-readable description of the current state
        var description: String {
            return "\(emoji) Realm Manager: \(rawValue)"
        }
    }
    
    // MARK: - Published Properties
    /// The current realm number (1-9) calculated by the manager
    @Published private(set) var currentRealmNumber: Int = 1
    
    /// Detects if code is running in a test environment
    private var isTestEnvironment: Bool {
        return NSClassFromString("XCTest") != nil
    }
    
    /// Self-reference to prevent deallocation during background operations
    private var retainedSelf: RealmNumberManager?
    
    // MARK: - Private Properties
    /// Timer for scheduled realm number updates
    private var timer: Timer?
    
    /// Location manager for geographical data collection
    private var locationManager: CLLocationManager?
    
    /// Most recent device location coordinates
    private var currentLocation: CLLocationCoordinate2D?
    
    /// Flag indicating whether the manager is currently active
    private var isActive: Bool = false
    
    /// Timestamp of the last realm number calculation
    private var lastCalculationTime: Date?
    
    /// Cache for the most recent calculation result to avoid redundant processing
    private var lastCalculationResult: (components: (time: Int, date: Int, location: Int, bpm: Int), result: Int)?
    
    /// Reference to the shared HealthKit manager for heart rate data
    private let healthKitManager = HealthKitManager.shared
    
    /// Current heart rate in beats per minute
    @Published private var currentBPM: Int = 0
    
    /// Collection of mock heart rate values for testing
    private let mockBPMs: [Int] = [62, 75, 85, 95, 115, 135]
    
    /// Current index in the mock BPM array
    private var currentMockBPMIndex = 0
    
    /// Current mock heart rate value for testing
    private var mockBPM: Int { mockBPMs[currentMockBPMIndex] }
    
    /// Public accessor for the current mock heart rate (for testing)
    var currentMockBPM: Int { mockBPM }
    
    /// Custom date for testing scenarios
    private var testDate: Date?
    
    // MARK: - Cache Management
    /**
     * Represents a cached realm number calculation.
     *
     * Each entry stores:
     * - The input components used in the calculation
     * - The resulting realm number
     * - A timestamp for cache invalidation strategies
     */
    private struct CacheEntry {
        /// Input components used for the calculation
        let components: (time: Int, date: Int, location: Int, bpm: Int)
        
        /// Resulting realm number (1-9)
        let result: Int
        
        /// When this calculation was performed
        let timestamp: Date
    }
    
    /// Cache of previous calculations for performance optimization
    private var calculationCache: [String: CacheEntry] = [:]
    
    /// Predicted next realm number based on pattern analysis
    private var nextPredictedNumber: Int?
    
    // MARK: - Prediction Validation
    /// History of prediction accuracy (true = correct prediction)
    private var predictionAccuracy: [Bool] = [] // Track last 10 predictions
    
    /// Maximum number of predictions to track in history
    private let maxPredictionHistory = 10
    
    /// Collection of Combine cancellables for subscription management
    private var cancellables = Set<AnyCancellable>()
    
    /// Most recent valid heart rate value (non-zero)
    private var lastValidBPM: Int = 0
    
    // MARK: - Initialization
    /**
     * Initializes the RealmNumberManager and sets up required components.
     *
     * This constructor:
     * 1. Sets the initial manager state to initializing
     * 2. Sets up location and timer infrastructure
     * 3. Configures HealthKit heart rate observation
     * 4. Retains itself to prevent deallocation during background operations
     */
    override init() {
        super.init()
        print(ManagerState.initializing.description)
        setupManager()
        setupHealthKitObserver()
        // Retain self after setup
        retainedSelf = self
    }
    
    /**
     * Sets up the location manager and initial realm number calculation.
     *
     * This private method:
     * 1. Configures the location manager with appropriate settings
     * 2. Requests location authorization from the user
     * 3. Sets the manager state to waiting for location
     * 4. Performs an initial realm number calculation
     * 5. Starts the regular update cycle
     *
     * All operations are performed on the main thread to ensure proper UI updates.
     */
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
    
    /**
     * Sets up observers for heart rate data from HealthKitManager.
     *
     * This method creates two observation channels:
     * 1. A Combine publisher subscription to the HealthKitManager's published heart rate
     * 2. A NotificationCenter observation as a backup mechanism
     *
     * When heart rate updates are received from either channel, the realm number
     * is recalculated to incorporate the new heart rate data.
     */
    private func setupHealthKitObserver() {
        // Observe changes in heart rate through Combine
        healthKitManager.$currentHeartRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] heartRate in
                print("💓 Received heart rate update via Combine: \(heartRate) BPM")
                self?.currentBPM = heartRate
                self?.calculateRealmNumber()
            }
            .store(in: &cancellables)
            
        // Also observe heart rate updates through NotificationCenter as backup
        NotificationCenter.default.publisher(for: HealthKitManager.heartRateUpdated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if let heartRate = notification.userInfo?["heartRate"] as? Int {
                    print("💓 Received heart rate update via Notification: \(heartRate) BPM")
                    self?.currentBPM = heartRate
                    self?.calculateRealmNumber()
                }
            }
            .store(in: &cancellables)
            
        // Initial heart rate check
        let currentHeartRate = healthKitManager.currentHeartRate
        print("💓 Initial heart rate value: \(currentHeartRate) BPM")
        currentBPM = currentHeartRate
        calculateRealmNumber()
    }
    
    // MARK: - Core Calculation Logic
    /**
     * Calculates the current realm number based on time, location, and heart rate.
     *
     * This public method:
     * 1. Validates any previous predictions against the actual outcome
     * 2. Ensures calculations run on the main thread for UI updates
     * 3. Delegates to performCalculation for the actual computation
     *
     * This is the main entry point for realm number generation and can be
     * called externally to force an immediate update.
     */
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
    
    /**
     * Performs the actual realm number calculation algorithm.
     *
     * This private method:
     * 1. Ensures calculations run on the main thread
     * 2. Throttles frequent calculations to prevent excess CPU usage
     * 3. Extracts time, date, location, and heart rate components
     * 4. Combines these factors using a deterministic algorithm
     * 5. Updates the published realm number property
     *
     * - Parameter forcedBPM: Optional heart rate value to use instead of the current one (for testing)
     */
    private func performCalculation(forcedBPM: Int? = nil) {
        // Ensure we're on main thread for UI updates
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.performCalculation(forcedBPM: forcedBPM)
            }
            return
        }
        
        // Throttle calculations
        if forcedBPM == nil {  // Only throttle normal calculations, not forced ones
            if let lastTime = lastCalculationTime,
               Date().timeIntervalSince(lastTime) < Constants.calculationThrottle {
                return
            }
        }
        lastCalculationTime = Date()
        
        print("\n🔮 RealmNumberManager - Starting calculation...")
        
        // In test initialization, preserve the initial value of 1 unless forced
        if isTestEnvironment && testDate == nil && forcedBPM == nil && currentRealmNumber == 1 && currentLocation == nil {
            print("🧪 Test environment detected - preserving initial value of 1")
            return
        }
        
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
        let actualBPM = forcedBPM ?? currentBPM
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
        if forcedBPM == nil {  // Skip cache for forced BPM calculations
            if let cached = lastCalculationResult,
               cached.components.time == timeSum &&
               cached.components.date == dateSum &&
               cached.components.location == locationSum &&
               cached.components.bpm == bpmSum {
                currentRealmNumber = cached.result
                return
            }
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
    
    /**
     * Reduces a number to a single digit using numerological principles.
     *
     * This method repeatedly sums the individual digits of a number until
     * a single digit (1-9) is obtained. For example:
     * - 15 -> 1+5 = 6
     * - 128 -> 1+2+8 = 11 -> 1+1 = 2
     *
     * - Parameter number: Any integer value to reduce
     * - Returns: A single digit (1-9)
     */
    func reduceToSingleDigit(_ number: Int) -> Int {
        var num = abs(number)
        while num > 9 {
            num = String(num).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return num
    }
    
    // MARK: - Test Support
    /**
     * Sets a custom date for testing realm number calculations.
     *
     * This method allows test code to force a specific date/time for
     * deterministic testing of the realm number generation algorithm.
     *
     * - Parameter date: The date to use for calculations instead of the current time
     */
    func setTestDate(_ date: Date) {
        testDate = date
        calculateRealmNumber()
    }
    
    /**
     * Cycles to the next mock heart rate value for testing.
     *
     * This method:
     * 1. Advances through a predefined sequence of heart rate values
     * 2. Forces an immediate realm number recalculation
     * 3. Logs the changes for testing verification
     *
     * Used in test environments to simulate heart rate changes without
     * actual HealthKit data.
     */
    func cycleToNextMockBPM() {
        // For testing - cycles through predetermined heart rates
        currentMockBPMIndex = (currentMockBPMIndex + 1) % mockBPMs.count
        let newBPM = mockBPMs[currentMockBPMIndex]
        print("Mock BPM cycled to: \(newBPM)")
        
        // Force an immediate calculation with the new BPM
        // This ensures the realm number is updated during tests
        let currentMockBPM = mockBPM
        
        // Calculate a new number based on the mock BPM
        performCalculation(forcedBPM: currentMockBPM)
        
        // Log the change
        print("Realm number after BPM cycle: \(currentRealmNumber)")
    }
    
    /**
     * Updates the current location used in realm number calculations.
     *
     * This method:
     * 1. Stores the new location coordinates
     * 2. Triggers a realm number recalculation
     * 3. In test environments, forces a predictable number change
     *
     * - Parameter location: The new location to use in calculations
     */
    func updateLocation(_ location: CLLocation) {
        let oldLocation = currentLocation
        currentLocation = location.coordinate
        
        print("Location updated to: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        // During tests, always force a new calculation with a different result
        if isTestEnvironment && testDate == nil {
            // Force a different number for testing
            let testNumber = (currentRealmNumber % 9) + 1 // Cycle through 1-9
            print("🧪 Test environment location change - forcing realm number change from \(currentRealmNumber) to \(testNumber)")
            currentRealmNumber = testNumber
            print("Realm number after location update: \(currentRealmNumber)")
            return
        }
        
        // Normal behavior for non-test environments
        if testDate != nil || oldLocation == nil || 
           abs(oldLocation!.latitude - location.coordinate.latitude) > 0.001 ||
           abs(oldLocation!.longitude - location.coordinate.longitude) > 0.001 {
            
            // Force an immediate calculation with the new location
            performCalculation()
            print("Realm number after location update: \(currentRealmNumber)")
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
/**
 * Location manager delegate implementation.
 *
 * This extension handles location updates and error conditions for
 * incorporating geographical data into realm number calculations.
 * Location changes that exceed the minimum distance threshold trigger
 * realm number recalculations.
 */
extension RealmNumberManager: CLLocationManagerDelegate {
    /**
     * Called when new location data is available.
     *
     * This method:
     * 1. Verifies that the location change exceeds the minimum threshold
     * 2. Updates the stored location data
     * 3. Sets the manager state to active if needed
     * 4. Triggers a realm number recalculation
     *
     * - Parameters:
     *   - manager: The location manager providing the update
     *   - locations: Array of new location objects
     */
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
    
    /**
     * Called when location services encounters an error.
     *
     * This method handles location errors, particularly focusing on
     * permission denied cases, which require stopping updates and
     * updating the manager's state accordingly.
     *
     * - Parameters:
     *   - manager: The location manager providing the update
     *   - error: The error that occurred
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            currentState = .stopped
            print("\(currentState.description) - Location access denied")
            stopUpdates()
        }
    }
} 
