//
//  SearchView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/26/24.
//

import SwiftUI

struct SearchView: View {
    var animation: Namespace.ID
    
    @EnvironmentObject var homeData : HomeViewModel
    @FocusState var StartTF: Bool
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 20){
                Button{
                    withAnimation{
                        homeData.searchActivated = false
                        
                    }
                    homeData.searchText = ""
                } label: {
                    
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.7))
                }
                HStack(spacing: 15){
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundColor(.gray)

                    TextField("Search", text: $homeData.searchText)
                        .focused($StartTF)
                        .textCase(.lowercase)
                        .disableAutocorrection(true)
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(
                    Capsule().strokeBorder(Color.purple, lineWidth: 1.5)
                )
                .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                .padding(.trailing, 20)
                
            }
            .padding([.horizontal,.top])
            .padding(.top)
            .padding(.bottom,10)
            
            
            if let products = homeData.searchedProducts {
                if products.isEmpty{
                    VStack(spacing: 10){
//                        Image("NOTFOUND")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .padding(.top,60)
                        
                        Text("Item Not Found")
                            .font(.system(size: 22, weight: .bold))
                        Text("Try a more generic search term or try looking for alternative products")
                            .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                    }
                            .padding()
                }else{
                    ScrollView(.vertical, showsIndicators: false){
                        
                        VStack(spacing: 0){
                            Text("Found \(products.count) results")
                                .font(.system(size: 24, weight: .bold))
                                .padding(.vertical)
                            
                            StaggeredGrid(list: products, columns: 2, spacing: 20) {product in
                                ProductCardView(product: product)
                                
                            }
                        }
                        .padding()
                        
                    }
                }
            }
            else{
                
                ProgressView()
                    .padding(.top,30)
                    .opacity(homeData.searchText == "" ? 0 : 1)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        //.background(Color.blue)//.backgroundColor(Color.red)
        .background(Color.gray.opacity(0.9).ignoresSafeArea())
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                StartTF = true
            }
        }
    }
        
    
    @ViewBuilder
        func ProductCardView(product: Product)->some View{
            VStack (spacing: 10){
                
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .offset(y: -50)
//                    .padding(.bottom, -50)
                
                Text(product.name.capitalized)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top)
                
                //Text(product.)
                //.font(.system(size: 14))
                //.foregroundColor(.gray)
                
                Text((product.price.formatted(.currency(code: "USD"))))
                //.font(.callout)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.top,5)
            }
            .padding(.horizontal,20)
            .padding(.bottom,22)
            .background(
                Color.white
                    .cornerRadius(25)
            )
            .padding(.top,50)
        }
}
struct SearchView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @Namespace var animation
        
        var body: some View {
            SearchView(animation: animation)
                .environmentObject(HomeViewModel()) // Make sure to provide necessary EnvironmentObjects
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
