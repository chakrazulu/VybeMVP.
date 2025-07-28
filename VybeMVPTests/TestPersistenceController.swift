//
//  TestPersistenceController.swift
//  VybeMVPTests
//
//  Created to provide isolated Core Data stacks for each test
//  Prevents test data contamination between test runs
//

import CoreData
@testable import VybeMVP

/**
 * Claude: Test-specific Persistence Controller
 * 
 * PURPOSE:
 * Provides isolated, in-memory Core Data stacks for unit tests
 * Each test gets its own fresh instance to prevent data contamination
 */
extension PersistenceController {
    
    /**
     * Creates a fresh in-memory Core Data stack for testing
     * Each call returns a new instance with clean data
     */
    static func makeTestController() -> PersistenceController {
        return PersistenceController(inMemory: true)
    }
    
    /**
     * Clears all data from the provided Core Data context
     * Useful for test cleanup between test methods
     */
    static func clearAllData(in context: NSManagedObjectContext) {
        // Entity names to clear
        let entityNames = ["PostEntity", "JournalEntry", "FocusMatch", "Sighting", "UserPreferences", "PersistedInsightLog"]
        
        for entityName in entityNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Failed to clear \(entityName): \(error)")
            }
        }
    }
}