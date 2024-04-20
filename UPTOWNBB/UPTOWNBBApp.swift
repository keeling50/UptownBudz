//
//  UPTOWNBBApp.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/8/24.
//

import SwiftUI
import FirebaseCore
import Foundation
import Firebase

@main

struct UPTOWNBBApp: App {
    init() {
        FirebaseApp.configure()
    }
    @StateObject private var authService = UserSettings()
    
    var body: some Scene {
            WindowGroup {
                ContentView().environmentObject(authService)
            }
        }
}

struct ContentView: View {
    var body: some View {
        //Text(userSettings.darkModeEnabled ? "Dark Mode" : "Light Mode")
//        NavigationView {
//            switch userSettings.authenticationState {
////            case .authenticated:
////                HomeView()
////            case .unauthenticated:
////                LoginView().navigationBarBackButtonHidden(true)
////            }
////        }
//
//                    //if userSettings.authenticationState == .authenticated {
//                        HomeView() // The main interface of your app
//                    //} else {
//                        LoginView() // Your login or welcome screen
//                    //}
//
        @StateObject var authViewModel = UserSettings()
        NavigationView {
            if authViewModel.needsAuthentication {
                    //if authViewModel.isAuthenticated {
                        HomeView().environmentObject(authViewModel)
                    } else {
                        LoginView().environmentObject(authViewModel)
                    }
                }
//        //@EnvironmentObject var authService: UserSettings
//        if UserSetting().authService.signedIn {
//            HomeView()
//        } else {
//            LoginView()
//        }
        //.navigationBarBackButtonHidden(true)
        //.preferredColorScheme(authViewModel.colorScheme)
    }
}
