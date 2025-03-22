//
//  AddProductView.swift
//  A2_iOS_Brendan_101447806
//
//  Created by Brendan Dasilva on 2025-03-21.
//

import SwiftUI
import CoreData

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var desc = ""
    @State private var price = ""
    @State private var provider = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Product Name", text: $name)
                TextField("Description", text: $desc)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Provider", text: $provider)
                
                Button("Save") {
                    let newProduct = Product(context: viewContext)
                    newProduct.productID = UUID()
                    newProduct.name = name
                    newProduct.desc = desc
                    newProduct.price = Double(price) ?? 0
                    newProduct.provider = provider
                    
                    do {
                        try viewContext.save()
                        dismiss()
                    } catch {
                        print("Error saving product: \(error.localizedDescription)")
                    }
                }
                .disabled(name.isEmpty || price.isEmpty || provider.isEmpty || desc.isEmpty)
            }
            .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
        }
    }
}
