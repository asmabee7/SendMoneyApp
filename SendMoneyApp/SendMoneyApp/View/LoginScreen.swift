//
//  Untitled.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//


import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var store: StoreManager
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    @State private var isLoggedIn = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color(.secondarySystemBackground)
                    .ignoresSafeArea(.all)
                VStack {
                    Text(Constants.appTitle)
                        .font(.system(size: 22, weight: .regular))
                        .padding(.vertical, 10)
                    Text(Constants.appSubtitle)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.bottom, 80)
                    
                    
                    TextField(Constants.emailPlaceholder, text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 10)
                    SecureField(Constants.passwordPlaceholder, text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 10)
                        .padding(.bottom, 80)
                    
                    
                    Button(action: {
                        if username == Constants.username && password == Constants.password {
                            isLoggedIn = true
                            store.dispatch(action: .login(username: username, password: password))
                        } else {
                            showError = true
                        }
                    }) {
                        Text(Constants.signIn)                  
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.all, 10)
                            .background(Color(red: 105/255, green: 111/255, blue: 135/255))
                            .cornerRadius(25)
                            .padding(.horizontal, 30)
                    }
                    
                    .padding(.bottom, 100)
                    
                    Text(Constants.bottomMessage).font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                       
                    
                }
                .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Invalid Credentials."),
                        dismissButton: .cancel()
                    )
                }
                
            }
            .navigationTitle(Constants.signIn)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeScreen()
            }
            .environment(\.layoutDirection, store.state.currentLanguage == .arabic ? .rightToLeft : .leftToRight)
        }
        
    }
    
}


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
