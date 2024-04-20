//
//  ProductView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/10/24.
//

import SwiftUI
import Foundation
import Firebase

struct Product: Identifiable, Decodable, Hashable{
    var id: String
    var type : ProductType
    var documentID :String
    var name: String
    var price: Double
    var quantity: Int
    var description : String
    var selectedSize: String?
    var availableSizes: [String] = ["S", "M", "L", "XL","XXL"]
    var imageName: String
    var imageName1: String
    var imageName2: String
}
enum ProductType: String, CaseIterable, Decodable{
    case featured = "Featured"
    case upcoming = "Upcoming"
    case favorited = "Favorited"
    case regular = "Regular"
}

var productList = [Product]()

struct ProductView: View {
  var product: Product
    @EnvironmentObject var cart: CartView
   // @State private var isSheetPresented = false

  var body: some View {
    VStack(alignment: .leading) {
        Text(product.name.capitalized)
        .font(.headline)
      Text(product.description)
        .font(.caption)
        .foregroundColor(.gray)
        HStack{
            product.image.resizable().frame(width: 100, height: 100).clipShape(Circle())
            Text((product.price.formatted(.currency(code: "USD"))))
                .font(.callout)
        }
//        Button(action: {
//            isSheetPresented = true
//            addToCart(product)
//        }){
//            HStack {
//                Image(systemName: "cart.badge.plus")
//                Text("Add to Cart")
//            }
//        }.buttonStyle(.borderless)
//         .font(.largeTitle)
    }
    .padding()
  }

    class ProductViewModel: ObservableObject {
        @Published var selectedSize: String?
        // You can also include the Product here if needed
    }
    func updateProductSizeInFirestoreByName(product: Product, selectedSize: String) {
        let db = Firestore.firestore()
        let productsRef = db.collection("products")
        let productName = product.name
        // Step 1: Query for documents with the matching name
        productsRef.whereField("name", isEqualTo: productName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error finding products: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No products found with the name \(productName)")
                return
            }
            
            // Step 2: Update the selectedSize field for each matching document
            documents.forEach { document in
                productsRef.document(document.documentID).updateData(["selectedSize": selectedSize]) { error in
                    if let error = error {
                        print("Error updating product size for \(document.documentID): \(error.localizedDescription)")
                    } else {
                        print("Product size updated successfully for \(document.documentID).")
                    }
                }
            }
        }
       // CartItemRow(cartItem: product).selectedSize = selectedSize
    }
//    func addToCart(_ product: Product) {
//
//        CartView().addToCart(item: product .selectedSize:)
//
//     }
    }
struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        // Prepare a sample product for the preview
        let sampleProduct = Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_25321", imageName1: "IMG_25321", imageName2: "IMG_25321")

        // Prepare the environment object
        let cartView = CartView()

        // Return the ProductView with the necessary environment object
        ProductView(product: sampleProduct)
            .environmentObject(cartView)
    }
}
extension Product {
    var image: Image {
        Image(imageName)
    }
}



