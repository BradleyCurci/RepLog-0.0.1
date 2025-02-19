//
//  SignInView.swift
//  RepLog
//
//  Created by Brad Curci on 1/10/25.
//

import SwiftUI

struct SignInView: View {
    
    
    @StateObject private var tokenViewModel = TokenViewModel.shared
    @StateObject private var mainViewModel = MainViewModel.shared
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack() {
            
            VStack(spacing: 100) {
                Logo()
                
                
                VStack(spacing: 40) {
                    TextField("", text: $email)
                        .textFieldStyle(CustomTextField(label: "Email", text: $email))
                    
                    CustomSecureField(label: "Password", text: $password)
                }
            }
            Button("AUTOFILL") {
                email = "bradcurci91@gmail.com"
                password = "password"
            }
            
            Spacer()
            
            Button {
                Task {
                    let response = await tokenViewModel.loadToken(email: email, password: password)
                    if !response.0 {
                        print("error signing in")
                    } else {
                        if !KeychainManager.shared.save("email", value: email) {
                            print("Error saving email to keychain")
                        }
                        
                        if !KeychainManager.shared.save("password", value: password) {
                            print("Error saving password to keychain")
                        }
                        
                        mainViewModel.updateState(.loggedIn)
                    }
                }
            } label: {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.BG)
                    .background(.accent.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            
            Text("Don't have an account?")
                .foregroundStyle(.text.opacity(0.8))
                .font(.custom("montserrat", size: 14))
            
            Button("Sign Up") {
                AuthenticaitonViewModel.shared.updateState(.showingSignup)
            }
            .font(.custom("montserrat", size: 16))
            
        }
        .padding()
        .overlay(content: {
            if tokenViewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
            }
        })
        .bgLinearGradient()
    }
}

#Preview {
    SignInView()
}
