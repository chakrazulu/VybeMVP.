import os.log // Standard import

class MyOSLogTest {
    func testLogger() {
        if #available(macOS 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *) { // Availability check for Logger
            let logger = Logger(subsystem: "com.example.test", category: "TestCategory")
            logger.info("This is a test log message.")
        } else {
            // Fallback on earlier versions
            let log = OSLog(subsystem: "com.example.test", category: "TestCategory")
            os_log("This is a test log message (old API).", log: log, type: .info)
        }
    }
}
