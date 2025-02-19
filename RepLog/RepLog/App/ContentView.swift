//
//  ContentView.swift
//  RepLog
//
//  Created by Brad Curci on 1/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = MainViewModel.shared
    
    var body: some View {
        switch viewModel.currentState {
            case .authentication:
                AuthController()
            case .loading:
                ZStack {
                    Color.black.opacity(0.3)
                    ProgressView()
                }
                .ignoresSafeArea()
            case .loggedIn:
                TabBar()
        }
    }
}


class MainViewModel: ObservableObject {
    
    static let shared  = MainViewModel()
    
    private init() {}
    
    @Published var currentState: State = .authentication
    
    enum State {
        case authentication
        case loading
        case loggedIn
    }
    
    func updateState(_ to: State) {
        DispatchQueue.main.async {
            self.currentState = to
        }
    }
    
}


#Preview {
    ContentView()
}
