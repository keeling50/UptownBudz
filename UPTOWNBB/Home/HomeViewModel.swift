//
//  HomeViewModel.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/23/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Combine


//10:523 video -https://www.youtube.com/watch?v=OR3At42Jt3I
class HomeViewModel: ObservableObject {
    @Published var productType : ProductType = .regular
    @Published var products : [Product] = [
//        Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_2521", imageName1: "IMG_25321", imageName2: "IMG_25321"),
//        Product(id: "sa", type: .featured, documentID: "sa", name: "Sample Product1", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_2524", imageName1: "IMG_25321", imageName2: "IMG_25321"),
//        Product(id: "sa", type: .featured, documentID: "sa", name: "Sample Product2", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_2529", imageName1: "IMG_25321", imageName2: "IMG_25321"),
//        Product(id: "sa", type: .featured, documentID: "sa", name: "Sample Product3", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_2530", imageName1: "IMG_25321", imageName2: "IMG_25321"),
//        Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product4", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_2521", imageName1: "IMG_25321", imageName2: "IMG_25321"),
//        Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product5", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_2522", imageName1: "IMG_25321", imageName2: "IMG_25321"),
//        Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product6", price: 9.99, quantity: 1, description: "A Whole bunch of bullshit I swear", imageName: "IMG_2523", imageName1: "IMG_25321", imageName2: "IMG_25321"),
    ]
    
    @Published var filterProducts: [Product] = []
    @Published var ShowMoreProductsonType: Bool = false
    @Published var searchText: String = ""
    @Published var searchActivated: Bool = false
    @Published var searchedProducts: [Product]?
    
    var searchCancellable : AnyCancellable?
    
    
    init(){
        fetchProductsFromFirestore()
        filterProductbyType()
        searchCancellable = $searchText.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: {str in
                if str != ""{
                    self.filterProductbySearch()
                }else{
                    self.searchedProducts = nil
                }
                
            })
        
    }
    
    func fetchProductsFromFirestore() {
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
                  let typeName = data["type"] as? String,
                  let type = ProductType(rawValue: typeName),
                  let imageName2 = data["imageName2"] as? String,
                  let description = data["description"] as? String
            else {
              return nil
            }
              DispatchQueue.main.async {
                          self.filterProductbyType()
                      }
              return Product(id: document.documentID, type: type, documentID: document.documentID, name: name, price: price, quantity: 0, description: description, imageName: imageName, imageName1: imageName1, imageName2: imageName2)
          } ?? []
        }
      }
    
        func filterProductbyType(){
        DispatchQueue.global(qos: .userInteractive).async {
            let result = self.products
                .lazy
                .filter{ product in
                    return product.type == self.productType
                }
                .prefix(4)

            DispatchQueue.main.async {
                self.filterProducts =  result.compactMap({ product in
                    return product
                })
            }
        }
//            self.filterProducts = self.products.filter { $0.type == self.productType }.prefix(4).map { $0 }
                }
    func filterProductbySearch(){
    DispatchQueue.global(qos: .userInteractive).async {
        let result = self.products
            .lazy
            .filter{ product in
                return product.name.lowercased().contains(self.searchText.lowercased())
            }
        DispatchQueue.main.async {
            self.searchedProducts =  result.compactMap({ product in
                return product
            })
        }
    }
//            self.filterProducts = self.products.filter { $0.type == self.productType }.prefix(4).map { $0 }
            }
        
    }

    


