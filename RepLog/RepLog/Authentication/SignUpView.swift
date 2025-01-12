//
//  SignUpView.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var viewModel = SignUpViewModel.shared
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }
            
            TextField("Email", text: $email)
            TextField("Username", text: $username)
            SecureField("Password", text: $password)
            SecureField("Confirm Password", text: $confirmPassword)
            
            Button("AUTO") {
                firstName = "John"
                lastName = "Doe"
                email = "john@doe.com"
                username = "johndoe"
                password = "password"
                confirmPassword = "password"
            }
            
            Button {
                let user = SignUpModel(name: "\(firstName) \(lastName)", email: email, username: username, password: password)
                Task {
                    await viewModel.signUp(data: user)
                }
            } label: {
                Text("Signup")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.blue)
            }
            
            Button("Show signin") {
                AuthenticaitonViewModel.shared.updateState(.showingSignIn)
            }
        }
    }
}

#Preview {
    SignUpView()
}
