/// Utility method to manually control simulation mode for testing purposes
public func setSimulationMode(enabled: Bool) {
    enableSimulationMode(enabled)
    
    if enabled {
        // Start simulation if enabling
        simulateHeartRateForTesting()
    } else {
        // Try to get real data if disabling
        Task {
            _ = await forceHeartRateUpdate()
        }
    }
} 