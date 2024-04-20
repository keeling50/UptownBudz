//
//  UserSettings.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/20/24.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseCore

enum AuthenticationState {
    case authenticated
    case unauthenticated
}

class UserSettings: ObservableObject {
    @Published var needsAuthentication = true
    @Published var isAuthenticated = false
    @Published var notificationsEnabled: Bool = false
    @Published var volumeLevel: Double = 0.5
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    @Published var darkModeEnabled: Bool  = UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            didSet {
                UserDefaults.standard.set(darkModeEnabled, forKey: "darkModeEnabled")
                // Update UserDefaults and possibly notify other parts of the app
            }
        }
    @Published var colorScheme: ColorScheme {
        didSet {
            UserDefaults.standard.set(colorScheme == .dark ? "dark" : "light", forKey: "colorScheme")
        }
    }
    
    init() {
        let savedScheme = UserDefaults.standard.string(forKey: "colorScheme") ?? "light"
        self.colorScheme = savedScheme == "light" ? .light : .dark
        self.darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        addAuthStateListener()
        //self.isAuthenticated = Auth.auth().currentUser != nil
    }
    private func addAuthStateListener() {
            authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
                withAnimation {
                    self?.isAuthenticated = user != nil
                }
            }
        }
    deinit {
            if let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle {
                Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
            }
        }
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Logged out successfully" + String(isAuthenticated))
            withAnimation {
                isAuthenticated = false
            }
        } catch let signOutError {
            print("Error signing out: %@", signOutError)
        }
        needsAuthentication = false
    }
//    func regularSignOut(completion: @escaping (Error?) -> Void) {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            completion(nil)
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//            completion(signOutError)
//        }
//    }
//    func logOut() {
//            do {
//                try Auth.auth().signOut()
//                //if let appSettings = Environment(\.managedObjectContext) as? UserSettings {
//                    self.authenticationState = .unauthenticated
//                //}// Additional logic to handle the successful logout, e.g., updating the UI or navigating to the login screen
//            } catch let signOutError as NSError {
//                print("Error signing out: %@", signOutError)
//                // Handle the error, possibly by displaying an alert to the user
//            }
//        }
    func updateColorSchemePreference(_ colorScheme: ColorScheme) {
            // Update the preference in UserDefaults and apply it globally if needed
            self.darkModeEnabled = (colorScheme == .dark)
        }
    func regularSignOut(completion: @escaping (Error?) -> Void) {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                completion(nil)
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
              completion(signOutError)
            }
        }
       
}



