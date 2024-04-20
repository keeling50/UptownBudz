//
//  SettingView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/18/24.
//
import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings

    //@EnvironmentObject var authService: UserSettings
    //@ObservedObject var userSettings = UserSettings()
    @Environment(\.colorScheme) var systemColorScheme: ColorScheme
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $userSettings.darkModeEnabled) {
                        Text("Dark Mode")
                        }
                        .onChange(of: userSettings.darkModeEnabled) { newValue in
                            // Persist the preference and apply it globally or locally as needed
                            userSettings.updateColorSchemePreference(newValue ? .dark : .light)
                        }
                }
                Section(header: Text("General")) {
                    Toggle(isOn: $userSettings.notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                    
                    Slider(value: $userSettings.volumeLevel, in: 0...1) {
                        Text("Volume")
                    }
                    .accessibilityValue(Text("Volume level is \(Int(userSettings.volumeLevel * 100)) percent"))
                }
                
                Section(header: Text("Account")) {
                    Button("Log Out") {
                        userSettings.logout()
                        
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(userSettings.darkModeEnabled ? .dark : .light)
    }
}
