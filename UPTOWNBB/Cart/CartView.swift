//
//  CartView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/12/24.
//

import SwiftUI
import Foundation
import Firebase

class CartView: ObservableObject {
    @Published var items: [Product] = []
    
    var subtotal: Double {
            items.reduce(0) { result, product in
                result + (product.price * Double(product.quantity))
            }
        }
    
    private var db = Firestore.firestore()
    
    init() {
        loadCartItems()
    }
    
    func loadCartItems() {
        db.collection("cartItems").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.items = documents.map { queryDocumentSnapshot -> Product in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let price = data["price"] as? Double ?? 0.0
                let quantity = data["quantity"] as? Int ?? 0
                let imageName = data["imageName"] as? String ?? ""
                let imageName1 = data["imageName1"] as? String ?? ""
                let imageName2 = data["imageName2"] as? String ?? ""
                let selectedSize = data["selectedSize"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                return Product(id: "UUID()", type: .regular, documentID: "UUID()", name: name, price: price, quantity: quantity, description: description, selectedSize: selectedSize, imageName: imageName, imageName1: imageName1, imageName2: imageName2)
            }
        }
    }
    func addToCart(item: Product, selectedSize: String) {
            let db = Firestore.firestore()
            let cartItemRef = db.collection("cartItems").document(item.id) // Assume `item.id` is a unique identifier for your products.

            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let cartItemDocument: DocumentSnapshot
                do {
                    try cartItemDocument = transaction.getDocument(cartItemRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                // Check if the item exists in the cart
                if let existingQuantity = cartItemDocument.data()?["quantity"] as? Int, cartItemDocument.exists {
                    // Item exists, so update its quantity
                    let newQuantity = existingQuantity + 1
                    transaction.updateData(["quantity": newQuantity], forDocument: cartItemRef)
                } else {
                    // Item does not exist, treat it as a new addition
                    // Assuming `item` has all necessary fields to be added to Firestore
                    let newItemData: [String: Any] = [
                        "name": item.name,
                        "price": item.price,
                        "description" : item.description,
                        "imageName" : item.imageName,
                        "selectedSize" : selectedSize,
                         "quantity": 1 // Starting with a quantity of 1 for new items
                    ]
                    transaction.setData(newItemData, forDocument: cartItemRef)
                   
                }

                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error.localizedDescription)")
                } else {
                    print("Transaction successfully committed!")
                }
            }
        
    }
    
    // Example Firestore update function (you'll need to implement this based on your Firestore setup)
//    func updateItemInFirestore(_ item: Product) {
//        // Implementation for updating an item in Firestore goes here.
//        // Use item.id or another unique identifier to find and update the item in Firestore.
//        guard let documentId = item.documentID else {
//            print("Error: Document ID is missing.")
//            return
//        }
//        
//        let db = Firestore.firestore()
//        let newQuantity = item.quantity + 1
//        db.collection("cartItems").document(documentId).updateData([
//            "quantity": newQuantity
//        ]) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Document successfully updated")
//            }
//            
//        }
//    }
    
    // Example Firestore add function (you'll need to implement this based on your Firestore setup)
    func addItemToFirestore(item: Product) {
        // Example of adding a new item, adjust for your data model
        let data: [String: Any] = ["name": item.name, "price": item.price, "quantity": item.quantity]
        db.collection("cartItems").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added")
            }
        }
    }
    func removeItems(atOffsets offsets: IndexSet) {
            // Additional logic might be required here to handle Firestore document deletion
            offsets.forEach { index in
                let item = self.items[index]
                // Assuming each item has a documentID property
                //let documentID = item.documentID
                RemovefromCart(item: item)
            }
            items.remove(atOffsets: offsets)
        }
    
    func RemovefromCart(item: Product){
        let db = Firestore.firestore()
            
            // Query the collection for items with a matching name
            db.collection("cartItems").whereField("name", isEqualTo: item.name).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        // Assuming each cart item has a 'quantity' field
                        if let quantity = document.data()["quantity"] as? Int, quantity > 1 {
                            // If quantity > 1, decrement the quantity
                            let newQuantity = quantity - 1
                            db.collection("cartItems").document(document.documentID).updateData(["quantity": newQuantity]) { error in
                                if let error = error {
                                    print("Error updating document: \(error)")
                                } else {
                                    print("Document successfully updated with decreased quantity.")
                                }
                            }
                        } else {
                            // If quantity is 1 (or not set), delete the item
                            db.collection("cartItems").document(document.documentID).delete() { error in
                                if let error = error {
                                    print("Error removing document: \(error)")
                                } else {
                                    print("Document successfully removed.")
                                }
                            }
                        }
                    }
                }
            }
    }
    func FetchCart(){
        db.collection("cartItems").getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        var newItems: [Product] = []
                        for document in querySnapshot!.documents {
                            do {
                                // Attempt to decode the document into a CartItem
                                let item = try document.data(as: Product.self)
                                newItems.append(item)
                            } catch {
                                print("Error decoding document: \(error)")
                            }
                        }
                        // Update the items on the main thread
                        DispatchQueue.main.async {
                            self.items = newItems
                        }
                    }
                }
            }
    }
    func RemovefromCart(atOffsets offsets: IndexSet) {
            //items.remove(atOffsets: offsets)
        
    }


struct CartProduct: Identifiable {
    var id: String = ""
    var product: Product.ID = ""
    var quantity: Int = 0
    var selectedSize: String = ""
}

  

    

