//
//  TokenManager.swift
//  RepLog
//
//  Created by Brad Curci on 1/10/25.
//

import Foundation

class TokenManager {
    
    static let shared = TokenManager()
    
    private init() {}
    
    func fetchToken(email: String, password: String) async throws -> Bool {
        let url = "https://api.tadabase.io/api/v1.1/2ejlW2BQo9/auth/login"
        let result: String = try await APIClient.shared.asyncRequest(
            baseURL: url,
            method: "POST",
            parameters: ["email":email, "password":password],
            printResponse: true,
            printStatusCode: true
        )
        
        print(result)
        
        return true
        
    }
    
    func retrieveTokenFromKeychain() -> String? {
        return ""
    }
}

class TokenViewModel: ObservableObject {
    
    static let shared = TokenViewModel()
    
    private init() {}
    
    @Published var token: String?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func loadToken(email: String, password: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            let fetchTokenResult = try await TokenManager.shared.fetchToken(email: email, password: password)
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.token = fetchTokenResult ? "Token retrieved!" : "Token retrieval failed!"
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
