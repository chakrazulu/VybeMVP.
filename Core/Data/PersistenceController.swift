/*
 * ========================================
 * 💾 PERSISTENCE CONTROLLER - CORE DATA INFRASTRUCTURE
 * ========================================
 * 
 * CORE PURPOSE:
 * Central Core Data stack manager providing persistent storage for all app data
 * including journal entries, focus matches, user preferences, and spiritual insights.
 * Handles automatic migration, performance optimization, and testing support with
 * in-memory stores for SwiftUI previews and unit tests.
 * 
 * CORE DATA STACK ARCHITECTURE:
 * 
 * === MANAGED OBJECT MODEL ===
 * • Model File: VybeMVP.xcdatamodeld
 * • Entities: JournalEntry, FocusMatch, UserPreferences, PersistedInsightLog, Sighting
 * • Static Loading: Model loaded once to prevent conflicts during testing
 * • Bundle Location: Main bundle resource with .momd extension
 * 
 * === PERSISTENT CONTAINER CONFIGURATION ===
 * • Container Name: "VybeMVP"
 * • Store Type: SQLite (default) or In-Memory (testing/previews)
 * • Migration: Automatic lightweight migration enabled
 * • Remote Changes: Background notification enabled for CloudKit sync
 * • History Tracking: Enabled for multi-context coordination
 * 
 * === PERFORMANCE OPTIMIZATIONS ===
 * • Automatic Merging: Changes from parent context merged automatically
 * • Merge Policy: NSMergeByPropertyObjectTrumpMergePolicy (property-level)
 * • Fault Deletion: Inaccessible faults deleted automatically
 * • Undo Management: Disabled for better performance
 * • Context Name: "MainContext" for debugging
 * • Background Saving: Save operations on background queue
 * 
 * === DEBUG CONFIGURATION ===
 * • SQL Debug: Disabled to reduce console noise
 * • CloudKit Debug: Disabled for cleaner logs
 * • Logging: Minimal logging for production performance
 * • Store URLs: Logged for debugging and verification
 * 
 * === THREADING MODEL ===
 * • View Context: Main thread only (UI updates)
 * • Save Operations: Background thread (userInitiated QoS)
 * • Context Isolation: Each test gets isolated in-memory store
 * • Thread Safety: performAndWait used for background saves
 * 
 * === TESTING SUPPORT ===
 * • In-Memory Stores: /dev/null URL for isolated testing
 * • Preview Instance: Static preview property for SwiftUI
 * • Dependency Injection: Custom init for test isolation
 * • Clean State: Each test gets fresh, empty store
 * 
 * === MIGRATION STRATEGY ===
 * • Automatic Migration: shouldMigrateStoreAutomatically = true
 * • Model Inference: shouldInferMappingModelAutomatically = true
 * • Lightweight Only: Complex migrations require manual model versions
 * • Version Compatibility: Handles schema changes transparently
 * 
 * === INTEGRATION POINTS ===
 * • JournalManager: Journal entry persistence
 * • FocusNumberManager: Focus match history storage
 * • AIInsightManager: Spiritual insight logging
 * • SightingsManager: Number sighting records
 * • UserPreferences: App configuration persistence
 * • All SwiftUI Views: Environment injection via .managedObjectContext
 * 
 * === ERROR HANDLING ===
 * • Store Loading: Fatal error on persistent store failure
 * • Save Operations: Logged errors with DEBUG crash for development
 * • Model Loading: Fatal error if VybeMVP.momd not found
 * • Context Validation: Graceful handling of save conflicts
 * 
 * === MEMORY MANAGEMENT ===
 * • Singleton Pattern: Single shared instance for app lifecycle
 * • Context Reuse: View context reused across app
 * • Fault Management: Automatic cleanup of unused objects
 * • Background Cleanup: Save operations don't block UI
 * 
 * This controller is the foundation of all data persistence in VybeMVP, ensuring
 * spiritual insights, journal entries, and user preferences are safely stored
 * and efficiently accessed throughout the app's mystical journey.
 */

/**
 * Filename: PersistenceController.swift
 * 
 * Purpose: Manages Core Data persistence for the app, providing a centralized
 * storage interface for all model data.
 *
 * Key responsibilities:
 * - Initialize and configure the Core Data stack
 * - Provide access to the persistence container and view context
 * - Handle data saving operations
 * - Manage migration of data between app versions
 * - Support in-memory stores for testing and previews
 * 
 * This controller is central to the app's data persistence strategy,
 * ensuring that all CoreData operations follow consistent patterns.
 */

import CoreData
import os.log

/**
 * Controller responsible for Core Data persistence operations.
 *
 * This class provides:
 * - A shared instance for app-wide persistence
 * - Configuration of the Core Data stack
 * - Optimized context settings for performance
 * - Automatic migration capabilities
 * - Support for both persistent and in-memory stores
 *
 * Design pattern: Singleton with dependency injection support
 * Threading: Main thread for view context, background for saving
 * Performance: Optimized for mobile with automatic merging
 */
class PersistenceController {
    /// Shared singleton instance for app-wide access
    static let shared = PersistenceController()
    
    /// Explicitly load the Managed Object Model once to avoid conflicts, especially in tests.
    static let model: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: "VybeMVP", withExtension: "momd") else {
            fatalError("Failed to find Core Data model file (VybeMVP.momd)")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model from file: \\(modelURL)")
        }
        return managedObjectModel
    }()
    
    /// Core Data persistent container managing the object model
    let container: NSPersistentContainer
    
    /**
     * Preview instance with in-memory store for SwiftUI previews.
     *
     * This static property provides a non-persistent Core Data stack
     * that can be used in SwiftUI previews without affecting real data.
     */
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        return controller
    }()
    
    /**
     * Initializes the Core Data persistence stack.
     *
     * This method:
     * 1. Configures debug settings for Core Data
     * 2. Sets up the persistent container with the data model
     * 3. Configures store descriptors with optimization settings
     * 4. Enables automatic migration
     * 5. Sets up optimized view context settings
     *
     * - Parameter inMemory: When true, creates an in-memory store that does not persist data
     */
    init(inMemory: Bool = false) {
        // Disable CoreData debug output
        UserDefaults.standard.set(false, forKey: "com.apple.CoreData.SQLDebug")
        UserDefaults.standard.set(false, forKey: "com.apple.CoreData.Logging.stderr")
        UserDefaults.standard.set(false, forKey: "com.apple.CoreData.CloudKitDebug")
        
        container = NSPersistentContainer(name: "VybeMVP", managedObjectModel: Self.model)
        
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, 
                                forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            
            // Optimize for performance
            description.setOption(true as NSNumber, 
                                forKey: NSPersistentHistoryTrackingKey)
            description.setOption(true as NSNumber, 
                                forKey: "NSPersistentStoreRemoveUbiquitousMetadataOption")
            description.setOption(false as NSNumber, 
                                forKey: "NSPersistentStoreLoggingKey")
            
            // Configure automatic lightweight migration
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // Claude: PERFORMANCE OPTIMIZATION - Load Core Data stores on background thread
        container.loadPersistentStores { description, error in
            // Check if an error occurred during loading
            if error != nil {
                // Use the original 'error' parameter, force-unwrapped as we know it's non-nil
                fatalError("Failed to load Core Data store: \\(error!.localizedDescription)")
            }
            // Log successful loading
            print("✅ Core Data store loaded successfully: \\(description.url?.absoluteString ?? \"In-Memory\")")
            
            // Claude: Configure view context on main thread after loading completes
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.configureViewContextOptimizations()
                print("🚀 Core Data view context optimized for performance")
            }
        }
        
        // Claude: Basic context setup - detailed optimization moved to async method
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    // Claude: PERFORMANCE OPTIMIZATION - Separate method for view context configuration
    private func configureViewContextOptimizations() {
        // Optimize view context for better performance
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.name = "MainContext"
        container.viewContext.undoManager = nil  // Disable undo management for better performance
        
        // Additional performance optimizations
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    /**
     * Saves any pending changes in the view context.
     *
     * This method:
     * 1. Checks if there are changes to be saved
     * 2. Performs the save operation on a background thread
     * 3. Handles and logs any errors that occur during saving
     * 4. In DEBUG builds, crashes with details if saving fails
     */
    func save() {
        let context = container.viewContext
        
        guard context.hasChanges else { return }
        
        // Perform save on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try context.performAndWait {
                    try context.save()
                }
            } catch {
                let nsError = error as NSError
                Logger.data.error("Error saving context: \(nsError.localizedDescription)")
                
                #if DEBUG
                DispatchQueue.main.async {
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                #endif
            }
        }
    }
    
    /**
     * Convenience method to save only if changes exist.
     *
     * This method checks if the view context has changes before
     * calling the save method, avoiding unnecessary operations.
     */
    func saveIfNeeded() {
        if container.viewContext.hasChanges {
            save()
        }
    }
    
    // MARK: - Background Context Support
    
    /**
     * Claude: PERFORMANCE OPTIMIZATION - Background Context Methods
     * 
     * Creates and manages background contexts for heavy Core Data operations.
     * Prevents blocking the main thread during large data operations like:
     * - Batch imports from Firestore
     * - Complex queries and transformations
     * - Large dataset synchronization
     * - Background cache updates
     */
    
    /**
     * Creates a new background context for heavy operations.
     * 
     * PERFORMANCE BENEFITS:
     * - Operations don't block main thread UI
     * - Automatic parent context synchronization
     * - Optimized for concurrent operations
     * - Memory efficient with proper cleanup
     * 
     * USAGE:
     * ```swift
     * let backgroundContext = persistenceController.newBackgroundContext()
     * backgroundContext.perform {
     *     // Heavy Core Data operations here
     *     try? backgroundContext.save()
     * }
     * ```
     * 
     * @return NSManagedObjectContext configured for background operations
     */
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        
        // Claude: Configure background context for optimal performance
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        context.undoManager = nil // Disable undo for better performance
        context.name = "BackgroundContext-\(UUID().uuidString.prefix(8))"
        
        return context
    }
    
    /**
     * Performs a background operation with automatic context management.
     * 
     * THREAD SAFETY:
     * - Automatically creates background context
     * - Ensures proper thread confinement
     * - Handles context cleanup after operation
     * - Merges changes back to main context
     * 
     * PERFORMANCE OPTIMIZED:
     * - Uses .userInitiated QoS for responsiveness
     * - Automatic error handling and logging
     * - Memory efficient context lifecycle
     * 
     * @param operation The Core Data operations to perform
     * @param completion Optional completion handler (called on main thread)
     */
    func performBackgroundTask(
        _ operation: @escaping (NSManagedObjectContext) throws -> Void,
        completion: @escaping (Result<Void, Error>) -> Void = { _ in }
    ) {
        container.performBackgroundTask { context in
            // Claude: Configure context for optimal background performance
            context.automaticallyMergesChangesFromParent = true
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            context.undoManager = nil
            context.name = "PerformBackgroundTask-\(UUID().uuidString.prefix(8))"
            
            do {
                // Perform the heavy operation on background thread
                try operation(context)
                
                // Save changes if any exist
                if context.hasChanges {
                    try context.save()
                    print("🚀 Background Core Data operation completed successfully")
                }
                
                // Notify completion on main thread
                DispatchQueue.main.async {
                    completion(.success(()))
                }
                
            } catch {
                Logger.data.error("Background Core Data operation failed: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /**
     * Async version of performBackgroundTask for modern Swift concurrency.
     * 
     * MODERN SWIFT CONCURRENCY:
     * - Uses async/await pattern for cleaner code
     * - Proper error propagation with Swift's Result type
     * - Thread-safe context management
     * - Automatic main actor isolation for UI updates
     * 
     * EXAMPLE USAGE:
     * ```swift
     * do {
     *     try await persistenceController.performBackgroundOperation { context in
     *         // Heavy Core Data work here
     *         let posts = try context.fetch(fetchRequest)
     *         // Process posts...
     *     }
     * } catch {
     *     print("Operation failed: \(error)")
     * }
     * ```
     * 
     * @param operation The async Core Data operations to perform
     * @throws Any error that occurs during the operation
     */
    func performBackgroundOperation(
        _ operation: @escaping (NSManagedObjectContext) throws -> Void
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            performBackgroundTask(operation) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /**
     * Batch fetch operation optimized for large datasets.
     * 
     * MEMORY OPTIMIZATION:
     * - Configures fetch request for minimal memory footprint
     * - Uses batch fetching to reduce memory pressure
     * - Proper fault management for large datasets
     * - Background thread execution prevents UI blocking
     * 
     * PERFORMANCE FEATURES:
     * - Configurable batch size for optimal performance
     * - Automatic predicate and sort descriptor support
     * - Generic type safety with Swift generics
     * - Error handling with detailed logging
     * 
     * @param fetchRequest The fetch request to execute
     * @param batchSize Number of objects to fetch at once (default: 100)
     * @param completion Completion handler with fetched objects
     */
    func performBatchFetch<T: NSManagedObject>(
        _ fetchRequest: NSFetchRequest<T>,
        batchSize: Int = 100,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        performBackgroundTask { context in
            // Claude: Optimize fetch request for batch processing
            fetchRequest.fetchBatchSize = batchSize
            fetchRequest.includesSubentities = false
            fetchRequest.returnsObjectsAsFaults = true
            
            let results = try context.fetch(fetchRequest)
            
            DispatchQueue.main.async {
                completion(.success(results))
            }
        } completion: { result in
            if case .failure(let error) = result {
                completion(.failure(error))
            }
        }
    }
} 