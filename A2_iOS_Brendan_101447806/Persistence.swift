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
        loadSampleData(context: viewContext)
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
    
    // MARK: - Sample Data Loading
    static func loadSampleData(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        if (try? context.count(for: request)) ?? 0 > 0 {
            return // Exit if data exists
        }
        
        let sampleProducts = [
            (name: "iPhone 15", desc: "Apple's latest flagship", price: 999.99, provider: "Apple"),
            (name: "Galaxy S24", desc: "Samsung premium phone", price: 899.99, provider: "Samsung"),
            (name: "Pixel 8", desc: "Google's AI-powered phone", price: 699.99, provider: "Google"),
            (name: "MacBook Pro 16\"", desc: "Professional laptop", price: 2499.99, provider: "Apple"),
            (name: "Surface Laptop 5", desc: "Microsoft premium laptop", price: 1299.99, provider: "Microsoft"),
            (name: "AirPods Pro", desc: "Noise-canceling earbuds", price: 249.99, provider: "Apple"),
            (name: "Galaxy Buds 2", desc: "Wireless earbuds", price: 149.99, provider: "Samsung"),
            (name: "PlayStation 5", desc: "Gaming console", price: 499.99, provider: "Sony"),
            (name: "Xbox Series X", desc: "4K gaming console", price: 499.99, provider: "Microsoft"),
            (name: "Kindle Paperwhite", desc: "E-Reader", price: 139.99, provider: "Amazon")
        ]
        
        for product in sampleProducts {
            let newProduct = Product(context: context)
            newProduct.productID = UUID()
            newProduct.name = product.name
            newProduct.desc = product.desc
            newProduct.price = product.price
            newProduct.provider = product.provider
        }
        
        try? context.save()
    }
}
