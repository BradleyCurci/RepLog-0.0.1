//
//  InitialView.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        Text("Welcome to RepLog")
        Button("SignUp") {
            AuthenticaitonViewModel.shared.updateState(.showingSignup)
        }
    }
}

#Preview {
    InitialView()
}
