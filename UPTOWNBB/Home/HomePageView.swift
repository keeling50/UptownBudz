//
//  HomePageView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/23/24.
//

import SwiftUI
import StoreKit

struct HomePageView: View {
    @Namespace var animation
    @StateObject var homeData : HomeViewModel = HomeViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 15){
                ZStack{
                    if homeData.searchActivated {
                        SearchBar()
                    }
                    else{
                        SearchBar()
                            .matchedGeometryEffect(id: "SEARCHBAR", in: animation)
                        
                    }
                }
                .frame(width: getRect().width / 1.6)
                .padding(.horizontal, 25)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeOut){
                        homeData.searchActivated = true
                    }
                }
                
                Text("Welcome BudBoyz")
                .font(.system(size: 28, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal, 25)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 18){
                        ForEach(ProductType.allCases,id:\.self){type in
                            //Bullshit goes here
                            ProductTypeView(type: type)
                        }
                        
                    }
                    .padding(.horizontal,25)
                }
                .padding(.top,1)
                
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack(spacing: 25){
                        
                        ForEach(homeData.filterProducts){product in
                            ProductCardView(product: product)
                            ///Product Card View
                            
                        }
                        
                    }
                    .padding(.horizontal,25)
                    .padding(.bottom)
                    .padding(.top,80)
                }
                .padding(.top,0)
                Button{
                    homeData.ShowMoreProductsonType.toggle()
                }label: {
                    Label {
                        Image(systemName: "arrow.right")
                    } icon: {
                        Text("See More")
                            .font(.system(size: 15, weight: .bold))
                        //.foregroundColor(Color("Blue"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
                .padding(.top,-10)
                Text("Events")
                .font(.system(size: 22, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal, 25)
                CalendarView(viewModel: calendarViewModel)
                            .onAppear {
                                // Load or set events
                                calendarViewModel.events = [
                                    CalendarEvent(date: Date(), title: "Popup Shop @ Union Stations")]
                            }
                
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1)
            .ignoresSafeArea())
        .onChange(of: homeData.productType){ newValue in
            homeData.filterProductbyType()
        }
        .sheet(isPresented: $homeData.ShowMoreProductsonType){
        }content: {
            HomeMoreView()
        }
        .overlay(alignment: .topTrailing){
            ZStack{
                if homeData.searchActivated{
                    SearchView(animation: animation)
                        .environmentObject(homeData)
                }
            }
        }
            
    }
    
    @ViewBuilder
    func SearchBar()->some View{
        HStack(spacing: 15){
            Image(systemName: "magnifyingglass")
                .font(.title2)
                .foregroundColor(.gray)

            TextField("Search", text: .constant(""))
                .disabled(true)
        }
        .padding(.vertical,12)
        .padding(.horizontal)
        .background(
            Capsule().strokeBorder(Color.gray, lineWidth: 0.6)
        )
    }
        
    @ViewBuilder
    func ProductCardView(product: Product)->some View{
        VStack (spacing: 10){
            
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: getRect().width / 2.5, height: getRect().width / 2.5)
                .offset(y: -80)
                .padding(.bottom, -80)
            
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
    }
    
    @ViewBuilder
    func ProductTypeView(type: ProductType)-> some View{
        
        Button{
            withAnimation{
                homeData.productType = type
            }
        }label: {
            
            Text(type.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(homeData.productType == type ? Color.blue : Color.gray)
            //.foregroundColor(homeData.productType == type ? Color("red") : Color.gray)
                .padding(.bottom, 10)
                .overlay{
                    
                    ZStack{
                        if homeData.productType ==  type{
                            Capsule()
                                .fill(.blue)
                                .matchedGeometryEffect(id: "PRODUCTTAB", in: animation)
                                .frame(height: 2)
                        }
                        else{
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                    //, alignment : .bottom
                    .padding(.horizontal, -1)
                    
                    
                }
        }
        
    }
    }

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
    extension View{
        func getRect()->CGRect{
            return UIScreen.main.bounds
        }
    }
