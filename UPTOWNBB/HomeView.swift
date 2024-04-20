//
//  HomeView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/10/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var cart = CartView()
    @EnvironmentObject var UserSetting: UserSettings
    enum Tab {
       case home
       case flavors
       case SmokeClub
       case Kids
       case Cart
       case Setting
    }
    @State private var selection: Tab = .home
    var body: some View {
        
        TabView(selection: $selection) {
            
            HomePageView().tabItem {
                Label("Home", systemImage: "house")
            }.tag(Tab.home)
            ProductListView().tabItem {
                Label("Flavors", systemImage: "1.square.fill")
            }.tag(Tab.flavors)
            SmokeView().tabItem {
                Label("Smoke Club", systemImage: "2.square.fill")
            }.tag(Tab.SmokeClub)
            Text("Uptown Kids Collection").tabItem {
                Label("Kids", systemImage: "3.square.fill")
            }.tag(Tab.Kids)
            CartListView().tabItem {
                Label("Cart", systemImage: "cart.badge.plus")
             }.tag(Tab.Cart)
            SettingsView().tabItem {
                Label("Settings", systemImage: "gearshape")
            }.tag(Tab.Setting)
        }.environmentObject(cart)
        .navigationBarBackButtonHidden(true)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(CartView())
    }
}
