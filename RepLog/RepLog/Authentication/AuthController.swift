//
//  AuthController.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

import SwiftUI

struct AuthController: View {
    
    @StateObject private var viewModel = AuthenticaitonViewModel.shared
    
    var body: some View {
        switch viewModel.currentState {
            case .initial:
                InitialView()
            case .showingSignIn:
                SignInView()
            case .showingSignup:
                SignUpView()
            case .signedIn:
                Text("Signed In")
        }
    }
}


class AuthenticaitonViewModel: ObservableObject {
    
    static let shared = AuthenticaitonViewModel()
    
    private init() {}
    
    @Published var currentState: AuthState = .initial
    
    enum AuthState {
        case showingSignIn
        case showingSignup
        case signedIn
        case initial
    }
    
    func updateState(_ to: AuthState) {
        DispatchQueue.main.async {
            self.currentState = to
        }
    }
}

#Preview {
    AuthController()
}
