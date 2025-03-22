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
    
    // error handling
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Product Name", text: $name)
                    TextField("Description", text: $desc)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Provider", text: $provider)
                }
                
                Section {
                    Button(action: validateAndSave) {
                        Text("Save Product")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundColor(.white)
                    }
                    .background(
                        Color.blue
                            .cornerRadius(8)
                    )
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1 : 0.5)
                    .listRowInsets(EdgeInsets()) // remove default padding
                    .listRowBackground(Color.clear) // clear section background
                }
            }
            .navigationTitle("Add Product")
            .alert("Invalid Input", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .toolbar {
                // keyboard dismissal button
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                            to: nil, from: nil, for: nil)
                    }
                }
            }
        }
    }
    
    // helper property for validation
    private var isFormValid: Bool {
        !name.isEmpty && !desc.isEmpty && !price.isEmpty && !provider.isEmpty
    }
    
    // price validation helper functions and creation of new product
    private func validateAndSave() {
        // validate price format
        guard let priceValue = Double(price) else {
            errorMessage = "Please enter a valid number for price"
            showAlert = true
            return
        }
        
        // validate positive price
        guard priceValue > 0 else {
            errorMessage = "Price must be greater than zero"
            showAlert = true
            return
        }
        
        // create new product
        let newProduct = Product(context: viewContext)
        newProduct.productID = UUID()
        newProduct.name = name
        newProduct.desc = desc
        newProduct.price = priceValue
        newProduct.provider = provider
        
        // save to Core Data
        do {
            try viewContext.save()
            dismiss()
        } catch {
            errorMessage = "Failed to save product: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    AddProductView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
