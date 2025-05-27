import Foundation

struct InsightCategory {
    static let insight = "insight"
    static let reflection = "reflection"
    static let contemplation = "contemplation"
    static let manifestation = "manifestation"
    static let challenge = "challenge"
    static let physicalPractice = "physical_practice"
    static let shadow = "shadow"
    static let archetype = "archetype"
    static let energyCheck = "energy_check"
    // Add other categories as needed
}

struct NumerologyInsightService {
    static let shared = NumerologyInsightService()

    private init() {}

    func fetchInsight(forNumber number: Int, category: String = InsightCategory.insight) -> String? {
        guard (0...9).contains(number) else {
            print("Error: Invalid number provided to fetchInsight: \(number)")
            return nil
        }

        let filename = "NumberMessages_Complete_\(number).json"
        
        // Try to load from "NumerologyData" subdirectory first
        if let url = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: "NumerologyData") {
            print("Found \(filename) in NumerologyData subdirectory.")
            return loadInsightFromUrl(url: url, number: number, category: category, filename: filename)
        } else {
            print("Warning: Could not find \(filename) in NumerologyData subdirectory. Attempting bundle root...")
            // Fallback: Attempt to load from the root of the app bundle
            if let fallbackUrl = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: nil) {
                 print("Found \(filename) in app bundle root.")
                 return loadInsightFromUrl(url: fallbackUrl, number: number, category: category, filename: filename)
            } else {
                print("Error: Could not find \(filename) in NumerologyData subdirectory OR in the app bundle root.")
                return nil
            }
        }
    }

    private func loadInsightFromUrl(url: URL, number: Int, category: String, filename: String) -> String? {
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let rootDictionary = json as? [String: Any],
                  let numberMessages = rootDictionary[String(number)] as? [String: [String]],
                  let messages = numberMessages[category],
                  !messages.isEmpty else {
                print("Error: Could not parse messages for number \(number), category '\(category)' from \(filename). JSON structure might be incorrect or category/messages missing.")
                return nil
            }
            
            // Return a random message from the array for variety
            return messages.randomElement()
            
        } catch {
            print("Error loading or parsing \(filename) for number \(number), category '\(category)': \(error)")
            return nil
        }
    }

    // Helper to get all messages for a specific number and category
    func fetchAllMessages(forNumber number: Int, category: String) -> [String]? {
        guard (0...9).contains(number) else {
            print("Error: Invalid number provided to fetchAllMessages: \(number)")
            return nil
        }

        let filename = "NumberMessages_Complete_\(number).json"
        
        // Try to load from "NumerologyData" subdirectory first
        if let url = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: "NumerologyData") {
            print("Found \(filename) in NumerologyData subdirectory for fetchAllMessages.")
            return loadAllMessagesFromUrl(url: url, number: number, category: category, filename: filename)
        } else {
            print("Warning: Could not find \(filename) in NumerologyData subdirectory for fetchAllMessages. Attempting bundle root...")
            // Fallback: Attempt to load from the root of the app bundle
            if let fallbackUrl = Bundle.main.url(forResource: filename, withExtension: nil, subdirectory: nil) {
                print("Found \(filename) in app bundle root for fetchAllMessages.")
                return loadAllMessagesFromUrl(url: fallbackUrl, number: number, category: category, filename: filename)
            } else {
                print("Error: Could not find \(filename) in NumerologyData subdirectory OR in the app bundle root for fetchAllMessages.")
                return nil
            }
        }
    }

    private func loadAllMessagesFromUrl(url: URL, number: Int, category: String, filename: String) -> [String]? {
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])

            guard let rootDictionary = json as? [String: Any],
                  let numberMessages = rootDictionary[String(number)] as? [String: [String]],
                  let messages = numberMessages[category] else {
                print("Error: Could not parse messages for number \(number), category '\(category)' from \(filename). JSON structure might be incorrect or category/messages missing.")
                return nil
            }
            return messages
        } catch {
            print("Error loading or parsing \(filename) for number \(number), category '\(category)': \(error)")
            return nil
        }
    }
} 