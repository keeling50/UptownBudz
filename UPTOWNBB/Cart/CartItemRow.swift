//
//  CartItemRow.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/15/24.
//

import SwiftUI

struct CartItemRow: View {
   @Binding var cartItem: Product
   var body: some View {
   HStack {
       Image(cartItem.imageName).resizable().frame(width: 100, height: 100).clipShape(Circle())
      VStack(alignment: .leading) {
          Text(cartItem.name.capitalized).fontWeight(.semibold)
         Text(cartItem.price.formatted(.currency(code: "USD")))
         Button("Show details"){}.foregroundColor(.gray)
      }
      Spacer()
       VStack {
           Text("Quantity: \(cartItem.quantity) ")
           //Text("Size: \(cartItem.selectedSize)")
           if let size = cartItem.selectedSize {
                               Text("Size: \(size)")
                           } else {
                               Text("Size: Not Selected")
                           }
       }
   }
}}
struct CartItemRow_Previews: PreviewProvider {
    @State static var sampleProduct = Product(id: "sa", type: .regular, documentID: "sa", name: "Sample Product", price: 9.99, quantity: 1, description: "", imageName: "IMG_25321", imageName1: "IMG_25321", imageName2: "IMG_25321")

    static var previews: some View {
        CartItemRow(cartItem: $sampleProduct)
            .previewLayout(.sizeThatFits)
    }
}

