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
        
        container.loadPersistentStores { description, error in
            // Check if an error occurred during loading
            if error != nil {
                // Use the original 'error' parameter, force-unwrapped as we know it's non-nil
                fatalError("Failed to load Core Data store: \\(error!.localizedDescription)")
            }
            // Re-inline the expression to silence the potentially spurious 'unused variable' warning
            print("✅ Core Data store loaded successfully: \\(description.url?.absoluteString ?? \"In-Memory\")")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Optimize view context
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.name = "MainContext"
        container.viewContext.undoManager = nil  // Disable undo management for better performance
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
                Logger.error("Error saving context: \(nsError.localizedDescription)", category: Logger.coreData)
                
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
} 