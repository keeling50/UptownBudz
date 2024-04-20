//
//  ContentView.swift
//  UPTOWNBB
//
//  Created by Kendall Keeling on 3/8/24.
//

import SwiftUI
import FirebaseAuth
import Foundation

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = false
    @State private var LoginORCreate = false
    @State private var NOAccess = false
    @StateObject private var viewModel = CreateAccountViewModel()
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @EnvironmentObject var authService: UserSettings
    
    var body: some View {
            NavigationView {
                VStack {
                    //CircleImage()
                    //    .frame(height: 300)
                    
                    VStack (alignment: .leading){
                        Text("Uptown Budz")
                            .font(.title)
                            .foregroundColor(.red)
                        Text("Fashion App")
                            .font(.subheadline)
                    }
                    VStack(spacing: 16) {
                        Picker("", selection: $LoginORCreate) {
                            Text("Log In")
                                .tag(false)
                            Text("Create Account")
                                .tag(true)
                        }.pickerStyle(SegmentedPickerStyle())
                            .padding()
                        if LoginORCreate {
                            Text("Welcome").font(.headline)
                            TextField("Username", text: $viewModel.username)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 280, height: 45, alignment: .center)
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 280, height: 45, alignment: .center)
                            SecureField("Password", text: $viewModel.password)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 280, height: 45, alignment: .center)
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 280, height: 45, alignment: .center)
                            TextField("Name", text: $email)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 280, height: 45, alignment: .center)
                            Spacer()// Insert your "Create Account" form or view here
                        } else {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 280, height: 45, alignment: .center)
                            SecureField("Password", text: $password)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 280, height: 45, alignment: .center)
                            Spacer()
                            // Insert your "Log In" form or view here
                        }
                        NavigationLink(destination : HomeView(cart: CartView()), isActive : $isLogin){
                        }
                        Button(action: {
                            if LoginORCreate {
                                createUser()
                                //authService.regularCreateAccount(email: $email, password: $password)
                            } else {
                                loginUser()
                            }
                        }, label: {
                            Text(LoginORCreate ? "Create Account" : "Log In")
                                .foregroundColor(.white)
                        }).frame(width: 280, height: 45, alignment: .center)
                            .background(Color.blue)
                            .cornerRadius(8)
                        
                    }.navigationBarBackButtonHidden(true)
                }
                .alert(isPresented: $NOAccess) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage))
                }
                .padding()
                .foregroundColor(.black)
                .background(Image("DALL·E 2024-03-23 13.48.45 ").resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                )
                
            }}
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // Handle login
            if let error = error {
                self.alertTitle = "Login Failed"
                self.alertMessage = error.localizedDescription
                self.NOAccess = true
            } else {
                // Update app's authentication state on success
                if let appSettings = Environment(\.managedObjectContext) as? UserSettings {
//                    appSettings.authenticationState = .authenticated
                }
                self.isLogin = true  // Assuming you navigate based on this
            }
        }
    }
        
    class CreateAccountViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var confirmPassword: String = ""
        @Published var termsAccepted: Bool = false

        // Simple validation
        var isFormValid: Bool {
            !username.isEmpty && !email.isEmpty && password == confirmPassword && termsAccepted
        }
    }
    private func createUser() {
        guard viewModel.isFormValid else {
            self.alertTitle = "Invalid Form"
            self.alertMessage = "Please make sure your form is correctly filled out."
            self.NOAccess = true
            return
        }

        Auth.auth().createUser(withEmail: viewModel.email, password: viewModel.password) { result, error in
            // Handle account creation
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
           LoginView()
        }
    }
}
