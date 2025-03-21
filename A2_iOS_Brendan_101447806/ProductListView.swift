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
            VStack(alignment: .leading) {
                Text(product.name ?? "")
                    .font(.headline)
                Text(product.desc ?? "")
                    .font(.subheadline)
                Text(product.desc ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("All Products")
    }
}
