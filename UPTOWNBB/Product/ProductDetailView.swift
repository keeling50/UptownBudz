//
//  ProductDetailView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/20/24.
//

import SwiftUI

struct ProductDetailView: View {
    @State private var showingConfirmation = false
    var Item: Product
   @State private var selectedSize: String = "M"
    @ObservedObject var cart = CartView()
    var body: some View {
            VStack(spacing: 0) {
                ImageSwiperView(imageNames: [Item.imageName, Item.imageName1, Item.imageName2])
                    .frame(height:300) // Specify your desired height
                    //.background(Color.red)
                    //.edgesIgnoringSafeArea(.top) // Make it extend into
                    //.edgesIgnoringSafeArea(.bottom)
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(Item.name.capitalized).font(.system(size: 25, weight: .bold, design: .default)).padding(.top, 60)
                        
                        Text(Item.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(Item.price.formatted(.currency(code: "USD")))")
                            .fontWeight(.semibold)
                        
                        Text("Selected Size:" + selectedSize)
                        SizeSelectionView(availableSizes: Item.availableSizes, selectedSize: $selectedSize)
                        HStack(){
                            Button(action: {
                                CartView().addToCart(item: Item, selectedSize: selectedSize)
                                ProductView(product: Item).updateProductSizeInFirestoreByName(product: Item, selectedSize: selectedSize)
                                showingConfirmation = true
                            }) {
                                Text("Buy Now")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .disabled(selectedSize.isEmpty)
                            .padding(.top, 20)
                            .alert("Added to Cart", isPresented: $showingConfirmation){
                                Button("OK", role: .cancel) { }
                            }
                        }.frame(height: 50)
                    }
                }//.background(Color.blue)
            }
            .navigationBarBackButtonHidden(false)
        }
    }
       
struct ProductDetailView_Previews: PreviewProvider {
    @State static var sampleProduct = Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product", price: 9.99, quantity: 1, description: "kmksdmckmskmckmksmckmskmcksmkmckmskcm", imageName: "IMG_25321", imageName1: "IMG_25321", imageName2: "IMG_25321")

    static var previews: some View {
        ProductDetailView(Item: sampleProduct)
            .previewLayout(.sizeThatFits)
    }
}
