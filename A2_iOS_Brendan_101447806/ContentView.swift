//
//  ContentView.swift
//  A2_iOS_Brendan_101447806
//
//  Created by Brendan Dasilva on 2025-03-21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
    ) var products: FetchedResults<Product>

    @State private var currentIndex = 0
    @State private var searchQuery = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // show empty state
                    if products.isEmpty {
                        Text("No products found")
                            .padding(.top)
                            .padding(.horizontal)
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Product \(currentIndex + 1)/\(products.count)")
                                .font(.headline)
                            Text("Name: \(products[currentIndex].name ?? "")")
                            Text("Description: \(products[currentIndex].desc ?? "")")
                            Text("Price: $\(String(format: "%.2f", products[currentIndex].price))")
                            Text("Provider: \(products[currentIndex].provider ?? "")")
                        }
                        .padding([.top, .horizontal])

                        // Navigation buttons
                        HStack {
                            Button(action: {
                                currentIndex = max(0, currentIndex - 1)
                            }) {
                                Text("Previous")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(currentIndex == 0 ? Color.gray : Color.blue)
                                    .cornerRadius(8)
                            }
                            .disabled(currentIndex == 0)

                            Spacer()

                            Button(action: {
                                currentIndex = min(products.count - 1, currentIndex + 1)
                            }) {
                                Text("Next")
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(currentIndex == products.count - 1 ? Color.gray : Color.blue)
                                    .cornerRadius(8)
                            }
                            .disabled(currentIndex == products.count - 1)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Product Viewer")
            .searchable(text: $searchQuery)
            .onAppear {
                PersistenceController.loadSampleData(context: viewContext)
            }
            .onChange(of: searchQuery) {
                if searchQuery.isEmpty {
                    products.nsPredicate = nil
                } else {
                    products.nsPredicate = NSPredicate(
                        format: "name CONTAINS[c] %@ OR desc CONTAINS[c] %@ OR provider CONTAINS[c] %@",
                        searchQuery, searchQuery, searchQuery
                    )
                }
                currentIndex = 0
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("View All Items") {
                        ProductListView()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Add") {
                        AddProductView()
                    }
                }
            }
        }
    }
}
        


#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
    


