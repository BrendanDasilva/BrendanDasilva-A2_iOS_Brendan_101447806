//
//  ContentView.swift
//  A2_iOS_Brendan_101447806
//
//  Created by Brendan Dasilva on 2025-03-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // core Data context for database operations
    @Environment(\.managedObjectContext) private var viewContext
    
    // fetch products from Core Data, sorted by name
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
    ) var products: FetchedResults<Product>
    
    // track the current product index for navigation
    @State private var currentIndex = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // show empty state if no products exist
                if products.isEmpty {
                    Text("No products found")
                } else {
                    // product details
                    Group {
                        Text("Product \(currentIndex + 1)/\(products.count)")
                            .font(.headline)
                        Text("Name: \(products[currentIndex].name ?? "")")
                        Text("Description: \(products[currentIndex].desc ?? "")")
                        Text("Price: $\(String(format: "%.2f", products[currentIndex].price))")
                        Text("Provider: \(products[currentIndex].provider ?? "")")
                    }
                    
                    // previous/next navigation buttons
                    HStack {
                        Button("Previous") {
                            currentIndex = max(0, currentIndex - 1)
                        }
                        .disabled(currentIndex == 0)
                        
                        Button("Next") {
                            currentIndex = min(products.count - 1, currentIndex + 1)
                        }
                        .disabled(currentIndex == products.count - 1)
                    }
                }
            }
            .padding()
            .navigationTitle("Product Viewer")
            .onAppear {
                PersistenceController.loadSampleData(context: viewContext)
            }
        }
    }
}
        


#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
    


