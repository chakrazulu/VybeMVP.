import Foundation
import Combine
import CoreLocation
import CoreData
import os.log

class FocusNumberManager: NSObject, ObservableObject {
    // Singleton instance
    static let shared = FocusNumberManager()
    
    @Published var selectedFocusNumber: Int = 0
    @Published var matchLogs: [FocusMatch] = []
    @Published var isAutoUpdateEnabled: Bool = false
    @Published var realmNumber: Int = 0 {
        didSet {
                checkForMatches()
            }
        }
    
    private var timer: Timer?
    private var _currentLocation: CLLocationCoordinate2D?
    private let viewContext: NSManagedObjectContext
    
    // Add currentLocation property
    var currentLocation: CLLocation? {
        didSet {
            _currentLocation = currentLocation?.coordinate
        }
    }
    
    static let validFocusNumbers = 1...9
    static let defaultFocusNumber = 1
    
    // For testing
    static func createForTesting(with persistenceController: PersistenceController) -> FocusNumberManager {
        return FocusNumberManager(persistenceController: persistenceController)
    }
    
    private init(persistenceController: PersistenceController = .shared) {
        self.viewContext = persistenceController.container.viewContext
        super.init()
        
        loadPreferences()
        loadMatchLogs()
        Logger.debug("📱 FocusNumberManager initialized with number: \(selectedFocusNumber)", category: Logger.focus)
    }
    
    // Add reduceToSingleDigit method
    func reduceToSingleDigit(_ number: Int) -> Int {
        var sum = 0
        var num = abs(number)
        
        // First sum all digits
        while num > 0 {
            sum += num % 10
            num /= 10
        }
        
        // If sum is still greater than 9, reduce again
        while sum > 9 {
            var tempSum = 0
            while sum > 0 {
                tempSum += sum % 10
                sum /= 10
            }
            sum = tempSum
        }
        
        return sum
    }
    
    // Computed property for journal entries
    var effectiveFocusNumber: Int {
        max(1, min(selectedFocusNumber, 9))  // Ensure valid range
    }
    
    func startUpdates() {
        stopUpdates() // Clear any existing timer
        
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.checkForMatches()
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
    
    private func loadPreferences() {
        let preferences = UserPreferences.fetch(in: viewContext)
        selectedFocusNumber = Int(preferences.lastSelectedNumber)
        
        // Ensure we never have 0 as a focus number
        if selectedFocusNumber == 0 {
            selectedFocusNumber = Self.defaultFocusNumber
            UserPreferences.save(
                in: viewContext,
                lastSelectedNumber: Int16(Self.defaultFocusNumber),
                isAutoUpdateEnabled: false
            )
        }
        
        isAutoUpdateEnabled = preferences.isAutoUpdateEnabled
        Logger.debug("Loaded preferences - Number: \(selectedFocusNumber), Auto Update: \(isAutoUpdateEnabled)", category: Logger.focus)
    }
    
    private func saveAutoUpdatePreference(_ enabled: Bool) {
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(selectedFocusNumber),
            isAutoUpdateEnabled: enabled
        )
    }
    
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
    
    // Add verification method
    func verifyAndSaveMatch(realmNumber: Int, completion: @escaping (Bool) -> Void) {
        // Ensure we're on the main thread for Core Data
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                print("❌ FocusNumberManager deallocated")
                completion(false)
                return
            }
            
            print("\n🔍 Verifying match...")
            print("   Selected Focus Number: \(self.selectedFocusNumber)")
            print("   Realm Number: \(realmNumber)")
            print("   Valid Range: \(Self.validFocusNumbers)")
            
            // Verify all conditions
            guard Self.validFocusNumbers.contains(self.selectedFocusNumber),
                  Self.validFocusNumbers.contains(realmNumber),
                  self.selectedFocusNumber == realmNumber else {
                print("❌ Match verification failed:")
                if !Self.validFocusNumbers.contains(self.selectedFocusNumber) {
                    print("   - Focus number \(self.selectedFocusNumber) not in valid range")
                }
                if !Self.validFocusNumbers.contains(realmNumber) {
                    print("   - Realm number \(realmNumber) not in valid range")
                }
                if self.selectedFocusNumber != realmNumber {
                    print("   - Numbers don't match")
                }
                completion(false)
                return
            }
            
            // Check for recent matches to prevent duplicates
            let recentMatchExists = self.checkForRecentMatch()
            if recentMatchExists {
                print("❌ Recent match exists - preventing duplicate")
                completion(false)
                return
            }
            
            // All verifications passed, save the match
            self.saveMatch()
            completion(true)
        }
    }
    
    private func checkForRecentMatch() -> Bool {
        // Get current time
        let now = Date()
        
        // Check if there's a match in the last minute
        return matchLogs.contains { match in
            let timeDifference = now.timeIntervalSince(match.timestamp)
            return timeDifference < 60 // Less than 1 minute
        }
    }
    
    private func saveMatch() {
        // Create a new FocusMatch entity
        let match = FocusMatch(context: viewContext)
        match.timestamp = Date()
        match.chosenNumber = Int16(selectedFocusNumber)
        match.matchedNumber = Int16(realmNumber)
        
        print("\n🌟 ================================")
        print("🌟         MATCH DETECTED!         ")
        print("🌟 ================================")
        print("📊 Match Details:")
        print("   Time: \(match.timestamp)")
        print("   Focus Number: \(selectedFocusNumber)")
        print("   Realm Number: \(realmNumber)")
        print("   Previous Match Count: \(matchLogs.count)")
        
        do {
            try viewContext.save()
            print("   ✅ Match saved successfully")
            loadMatchLogs() // Reload matches after saving
            print("   📱 New Match Count: \(matchLogs.count)")
        } catch {
            print("❌ Failed to save match: \(error)")
            print("   Error Description: \(error.localizedDescription)")
        }
        print("🌟 ================================\n")
    }
    
    private func checkForMatches() {
        // Only create a match if the numbers are equal and valid
        if selectedFocusNumber == realmNumber && Self.validFocusNumbers.contains(selectedFocusNumber) {
            verifyAndSaveMatch(realmNumber: realmNumber) { _ in }
        }
    }
    
    func updateRealmNumber(_ newValue: Int) {
        if realmNumber != newValue {
            print("\n🔄 Realm number changed: \(realmNumber) → \(newValue)")
            realmNumber = newValue
            checkForMatches()
        }
    }
    
    func userDidPickFocusNumber(_ number: Int) {
        let validNumber = max(1, min(number, 9))
        selectedFocusNumber = validNumber
        
        // Save to Core Data
        UserPreferences.save(
            in: viewContext,
            lastSelectedNumber: Int16(validNumber),
            isAutoUpdateEnabled: isAutoUpdateEnabled
        )
        
        print("\n📝 Focus Number set to: \(validNumber)")
        // Check for immediate match with current realm number
        checkForMatches()
    }
    
    // Add calculateTranscendentalNumber method
    func calculateTranscendentalNumber() -> Int {
        let timeFactor = calculateTimeFactor()
        let locationFactor = calculateLocationFactor()
        let focusFactor = selectedFocusNumber
        
        // Calculate the transcendental number by combining all factors
        let sum = timeFactor + locationFactor + focusFactor
        return reduceToSingleDigit(sum)
    }
    
    func calculateTimeFactor() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: now)
        
        guard let hour = components.hour,
              let minute = components.minute else {
            return 1 // Default to 1 if we can't get time components
        }
        
        // Combine hour and minute into a single number and reduce
        return reduceToSingleDigit(hour + minute)
    }
    
    func calculateLocationFactor() -> Int {
        guard let location = _currentLocation else {
            return 1 // Default to 1 if no location available
        }
        
        // Convert coordinates to positive integers by removing decimal point
        let latString = String(format: "%.6f", abs(location.latitude))
            .replacingOccurrences(of: ".", with: "")
        let longString = String(format: "%.6f", abs(location.longitude))
            .replacingOccurrences(of: ".", with: "")
        
        // Convert strings to integers and reduce to single digits
        let latSum = reduceToSingleDigit(Int(latString) ?? 0)
        let longSum = reduceToSingleDigit(Int(longString) ?? 0)
        
        // Combine latitude and longitude factors
        return reduceToSingleDigit(latSum + longSum)
    }
    }
    
// MARK: - CLLocationManagerDelegate
extension FocusNumberManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        _currentLocation = location
        Logger.debug("📍 Location updated: \(location.latitude), \(location.longitude)", category: Logger.location)
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .denied:
                Logger.error("❌ Location access denied", category: Logger.location)
            case .locationUnknown:
                Logger.debug("⚠️ Location temporarily unavailable", category: Logger.location)
            default:
                Logger.error("❌ Location error: \(error.localizedDescription)", category: Logger.location)
            }
        }
    }}

