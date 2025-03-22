//
//  ProductListView.swift
//  A2_iOS_Brendan_101447806
//
//  Created by Brendan Dasilva on 2025-03-21.
//

import SwiftUI
import CoreData

struct ProductListView: View {
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
    ) var products: FetchedResults<Product>
    
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
        }
        .navigationTitle("All Products")
    }
}
