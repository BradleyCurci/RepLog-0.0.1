//
//  ProfileView.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = MainViewModel.shared
    var body: some View {
        Button("Logout") {
            
            viewModel.updateState(.loading)
            
            Task {
                
                // Terminate Token
                guard await SignoutManagerViewModel.shared.signout() else {
                    print("Failed to terminate Token")
                    return
                }
                
                // remove credentials from keychain
                guard KeychainManager.shared.delete("email"), KeychainManager.shared.delete("password") else {
                    print("error removing credentials from keychain")
                    return
                }
                
                
                DispatchQueue.main.async {
                    viewModel.updateState(.authentication)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
