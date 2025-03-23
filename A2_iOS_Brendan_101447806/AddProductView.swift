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
    
    //
    var productToEdit: Product?
    
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
            .onAppear {
                if let product = productToEdit {
                    // Pre-fill fields when editing
                    name = product.name ?? ""
                    desc = product.desc ?? ""
                    price = String(format: "%.2f", product.price)
                    provider = product.provider ?? ""
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
        // allow letters, numbers, spaces, and dashes
        let allowedCharacters = CharacterSet.alphanumerics
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "-"))
        
        // name validation
        if name.count > 30 {
            errorMessage = "Product name must be ≤ 30 characters"
            showAlert = true
            return
        }
        
        if name.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            errorMessage = "Name can only contain letters and numbers"
            showAlert = true
            return
        }
        
        // description validation
        if desc.count > 60 {
            errorMessage = "Description must be ≤ 60 characters"
            showAlert = true
            return
        }
        
        if desc.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            errorMessage = "Description can only contain letters and numbers"
            showAlert = true
            return
        }
        
        // price validation (existing)
        guard let priceValue = Double(price) else {
            errorMessage = "Please enter a valid number for price"
            showAlert = true
            return
        }
        
        guard priceValue > 0 else {
            errorMessage = "Price must be greater than zero"
            showAlert = true
            return
        }
        
        // provider validation
        if provider.count > 20 {
            errorMessage = "Provider must be ≤ 20 characters"
            showAlert = true
            return
        }
        if provider.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            errorMessage = "Provider can only contain letters and numbers"
            showAlert = true
            return
        }
        
        if let product = productToEdit {
            // update existing product
            product.name = name
            product.desc = desc
            product.price = priceValue
            product.provider = provider
        } else {
            // create new product
            let newProduct = Product(context: viewContext)
            newProduct.productID = UUID()
            newProduct.name = name
            newProduct.desc = desc
            newProduct.price = priceValue
            newProduct.provider = provider
        }
        
        
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
