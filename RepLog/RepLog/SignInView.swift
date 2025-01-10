//
//  SignInView.swift
//  RepLog
//
//  Created by Brad Curci on 1/10/25.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = TokenViewModel.shared
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack {
            
            TextField("Email", text: $email)
            
            SecureField("Password", text: $password)
            
            Button("AUTOFILL") {
                email = "bradcurci91@gmail.com"
                password = "password"
            }
            
            Button {
                print("Button Clicked")
                Task {
                    await viewModel.loadToken(email: email, password: password)
                }
            } label: {
                Text("Sign in")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.blue)
            }
            
        }
        .padding()
        .overlay(content: {
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView()
            }
        })
    }
}
//
//#Preview {
//    SignInView()
//}
