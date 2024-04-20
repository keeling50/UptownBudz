//
//  CartItemDetail.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/15/24.
//

import SwiftUI

struct CartItemDetail: View {
    @Binding var cartItem: Product
   var body: some View {
   VStack {
       Text(cartItem.name).font(.largeTitle)
      cartItem.image.resizable().frame(width: 200, height: 200).clipShape(Circle())
      Text("\(cartItem.price)")
      Text(cartItem.description)
.multilineTextAlignment(.center).padding(.all, 20.0)
   }
}}
struct CartItemDetail_Previews: PreviewProvider {
    @State static var sampleProduct = Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product", price: 9.99, quantity: 1, description: "", imageName: "IMG_25321", imageName1: "IMG_25321", imageName2: "IMG_25321")

    static var previews: some View {
        CartItemRow(cartItem: $sampleProduct)
            .previewLayout(.sizeThatFits)
    }
}


