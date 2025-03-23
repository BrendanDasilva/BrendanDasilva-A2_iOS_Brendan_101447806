//
//  ProductListView.swift
//  A2_iOS_Brendan_101447806
//
//  Created by Brendan Dasilva on 2025-03-21.
//

import SwiftUI
import CoreData

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
    ) var products: FetchedResults<Product>
    
    @State private var productToEdit: Product?
    @State private var showDeleteAlert = false
    
    var body: some View {
        List(products, id: \.self) { product in
            VStack(alignment: .leading, spacing: 4) {
                Text(product.provider ?? "Unknown Provider")
                    .font(.headline)
                Text(product.name ?? "Unnamed Product")
                    .font(.headline)
                VStack(alignment: .leading) {
                    Text("$\(String(format: "%.2f", product.price))")
                        .font(.subheadline)
                    Text(product.desc ?? "No description available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
            // swipe to delete (left)
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    deleteProduct(product)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
            // swipe to edit (right)
            .swipeActions(edge: .leading) {
                Button {
                    productToEdit = product
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .tint(.blue)
            }
        }
        .navigationTitle("All Products")
        .sheet(item: $productToEdit) { product in
            AddProductView(productToEdit: product)
                .environment(\.managedObjectContext, viewContext)
        }
        .alert("Product Deleted", isPresented: $showDeleteAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The product was successfully deleted.")
        }
    }
    
    private func deleteProduct(_ product: Product) {
        viewContext.delete(product)
        do {
            try viewContext.save()
            showDeleteAlert = true
        } catch {
            print("Error deleting product: \(error.localizedDescription)")
        }
    }
}
