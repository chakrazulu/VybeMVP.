import CoreData

class PersistenceController {
    // Shared instance for the app
    static let shared = PersistenceController()
    
    // Storage for Core Data
    let container: NSPersistentContainer
    
    // Test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        return controller
    }()
    
    // Initialize Core Data stack
    init(inMemory: Bool = false) {
        // Disable CoreData debug output
        UserDefaults.standard.set(false, forKey: "com.apple.CoreData.SQLDebug")
        UserDefaults.standard.set(false, forKey: "com.apple.CoreData.Logging.stderr")
        UserDefaults.standard.set(false, forKey: "com.apple.CoreData.CloudKitDebug")
        
        container = NSPersistentContainer(name: "VybeMVP")
        
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
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Optimize view context
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.name = "MainContext"
        container.viewContext.undoManager = nil  // Disable undo management for better performance
    }
    
    // Save changes if there are any
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
    
    func saveIfNeeded() {
        if container.viewContext.hasChanges {
            save()
        }
    }
} 