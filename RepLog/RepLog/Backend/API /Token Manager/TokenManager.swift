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
    
    func fetchToken(email: String, password: String) async throws -> TokenModel {
        
        // Generate User Token
        let url = "https://api.tadabase.io/api/v1.1/2ejlW2BQo9/auth/login" // login component
        let result: TokenModel = try await APIClient.shared.asyncRequest(
            baseURL: url,
            method: "POST",
            parameters: ["email":email, "password":password, "remember":60],
            tokenRequired: false,
            printResponse: false,
            printStatusCode: false
        )
        
        return result
        
    }
}

class TokenViewModel: ObservableObject {
    
    static let shared = TokenViewModel()
    
    private init() {}
    
    @Published var token: TokenModel?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func loadToken(email: String, password: String) async -> (Bool, String?) {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            let fetchTokenResult = try await TokenManager.shared.fetchToken(email: email, password: password)
            
            // successfully retrieved token from TB
            DispatchQueue.main.async {
                
                // save token to keychain
                if !KeychainManager.shared.save("userToken", value: fetchTokenResult.token) {
                    
                    // Failed to save user token to keychain
                    print("Failed to save token to keychain")
                } else {
                    
                    // schedule token refresh if user token is successfully saved
                    SessionManager.shared.scheduleTokenRefresh()
                }
                
                self.isLoading = false
            }
            
            // Success
            return (true, nil)
            
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                print(self.error!)
                self.isLoading = false
            }
            
            //Failure
            return (false, error.localizedDescription)
        }
    }
    
    
    // retrieve user token
    func retrieveTokenFromKeychain() -> String? {
        guard let token = KeychainManager.shared.get("userToken") else {
            return nil
        }
        return token
    }
}
