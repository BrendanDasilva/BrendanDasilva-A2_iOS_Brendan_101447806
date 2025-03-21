//
//  Persistence.swift
//  A2_iOS_Brendan_101447806
//
//  Created by Brendan Dasilva on 2025-03-21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    // In-memory store for previews
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()
    
    // Core Data container
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "A2_iOS_Brendan_101447806")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
