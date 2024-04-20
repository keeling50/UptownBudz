//
//  ProductListView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/12/24.
//
import SwiftUI
import FirebaseFirestore

struct ProductListView: View {
  @State private var products = [Product]()
    
    var body: some View {
            NavigationView {
                List(products) { product in
                    NavigationLink(destination: ProductDetailView(Item: product)) {
                        ProductView(product: product)
                    }
                }
                .navigationTitle("Flavors")
                .onAppear {
                    fetchProducts()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    

  func fetchProducts() {
    Firestore.firestore().collection("products").getDocuments() { querySnapshot, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }

      self.products = querySnapshot?.documents.compactMap { document -> Product? in
        let data = document.data()

        guard let name = data["name"] as? String,
              let price = data["price"] as? Double,
              let imageName = data["imageName"] as? String,
              let imageName1 = data["imageName1"] as? String,
              let imageName2 = data["imageName2"] as? String,
              let description = data["description"] as? String
        else {
          return nil
        }

          return Product(id: document.documentID, type: .regular, documentID: document.documentID, name: name, price: price, quantity: 0, description: description, imageName: imageName, imageName1: imageName1, imageName2: imageName2)
      } ?? []
    }
  }
}
struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}

