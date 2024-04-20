//
//  CartSummary.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/15/24.
//

import SwiftUI

struct CartSummary: View {
   //@Binding var subtotal: Double
    @EnvironmentObject var cart: CartView
    var body: some View {
   VStack {
      Button(action: { print("We'll implement promo codes later")
      }) { Text("Add promo/discount code").padding()}
      HStack {
         Text("Cart").bold()
         Spacer()
         VStack {
            HStack {
               Text("Subtotal")
               Spacer()
                Text(String(format: "$%.2f", cart.subtotal))
            }
            HStack {
               Text("Taxes")
               Spacer()
                Text(String(format: "$%.2f", cart.subtotal*0.0662))
            }
            HStack {
               Text("Total")
               Spacer()
                Text(String(format: "$%.2f", cart.subtotal+cart.subtotal*0.0662))
            }
         }.frame(width: 200)
      }.padding()
   }.background(Color.gray.opacity(0.1))
}}

