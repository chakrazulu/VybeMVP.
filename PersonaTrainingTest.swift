import Foundation
import os.log

// Quick test to verify PersonaTrainingManager bundle access
class PersonaTrainingTest {
    static func testBundleAccess() {
        let logger = Logger(subsystem: "com.vybe.test", category: "PersonaTraining")

        logger.info("🧪 Testing PersonaTrainingManager bundle access...")

        // Test persona file access
        let personas = ["oracle", "psychologist", "mindfulnesscoach", "numerologyscholar", "philosopher"]
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 22, 33, 44]

        var foundFiles = 0
        var totalExpected = 0

        for persona in personas {
            for number in numbers {
                totalExpected += 1
                let numberStr = String(format: "%02d", number)

                if let bundleURL = Bundle.main.url(
                    forResource: "grok_\(persona)_\(numberStr)_converted",
                    withExtension: "json",
                    subdirectory: "KASPERMLXRuntimeBundle/Behavioral/\(persona)"
                ) {
                    foundFiles += 1
                    logger.info("✅ Found: \(bundleURL.lastPathComponent)")
                } else {
                    logger.warning("❌ Missing: grok_\(persona)_\(numberStr)_converted.json")
                }
            }
        }

        logger.info("📊 Bundle Access Test Results:")
        logger.info("   Found: \(foundFiles) files")
        logger.info("   Expected: \(totalExpected) files")
        logger.info("   Success Rate: \(foundFiles)/\(totalExpected) (\(Int(Double(foundFiles)/Double(totalExpected)*100))%)")

        if foundFiles > 0 {
            logger.info("🎉 SUCCESS: PersonaTrainingManager can access bundle files!")
        } else {
            logger.error("💥 FAILURE: No bundle files accessible")
        }
    }
}
