// This file has been deprecated.
// Please use the PersistenceController in Core/Data/PersistenceController.swift instead.
// Keeping this file as a compatibility layer to prevent build errors.

import CoreData
import Foundation

// Instead of a typealias which might affect imports, implement a forwarding class
public class PersistenceController {
    public var container: NSPersistentContainer
    
    // Forward to the main implementation
    public init(inMemory: Bool = false) {
        // Use the actual implementation from Core/Data
        let coreImplementation = VybeMVP.PersistenceController(inMemory: inMemory)
        self.container = coreImplementation.container
    }
    
    // For compatibility with existing code
    public static var shared: PersistenceController {
        return PersistenceController(inMemory: false)
    }
    
    public static var preview: PersistenceController {
        return PersistenceController(inMemory: true)
    }
    
    public var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}