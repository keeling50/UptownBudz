//
//  CartListView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/12/24.
//

import SwiftUI
import Foundation

struct CartListView: View {
    @EnvironmentObject var cart: CartView
    var body: some View {
       NavigationView {List {  ForEach($cart.items.indices, id: \.self) { index in
                   NavigationLink(destination: CartItemDetail(cartItem: $cart.items[index])) {
                       CartItemRow(cartItem:  $cart.items[index])}
               }
       .onDelete(perform: cart.removeItems)
           CartSummary()
               RoundedButton(imageName: "creditcard", text: "Continue").padding()
           }.navigationTitle("Cart")
        
       }.navigationViewStyle(StackNavigationViewStyle())
    }
}
//    var body: some View {
//            List {
//                ForEach(cart.items) { item in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(item.name)
//                                .font(.headline)
//                            Text("$\(item.price, specifier: "%.2f")")
//                                .font(.subheadline)
//                        }
//                        Spacer()
//                        Text("Qty: \(item.quantity)")
//                    }
//                }
//                .onDelete(perform: deleteItems)
//
//                if !cart.items.isEmpty {
//                    HStack {
//                        Spacer()
//                        //Text("Total: $\(cart.total, specifier: "%.2f")")
//                            .font(.title)
//                        Spacer()
//                    }
//                }
//            }
//            .navigationTitle("Cart Items")
//            .navigationBarItems(trailing: EditButton())
//        }
        func filterit(){
        //    cart.items = cart.items.filter {$0.quantity >= 1}
        }
        struct RoundedButton: View {
            var imageName: String
            var text: String
            var body: some View {
            
                HStack {
              Image(systemName: imageName).font(.title)
              Text(text).fontWeight(.semibold).font(.title)
            }.padding().foregroundColor(.white).background(Color.orange)
            .cornerRadius(40)
        }}
          


struct CartListView_Previews: PreviewProvider {
    static var previews: some View {
        CartListView()
            .environmentObject(CartView())
    }
}
