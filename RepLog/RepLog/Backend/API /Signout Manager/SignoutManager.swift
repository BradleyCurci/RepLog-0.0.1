//
//  SignoutManager.swift
//  RepLog
//
//  Created by Brad Curci on 2/19/25.
//

import Foundation

class SignoutManager {
    
    static let shared = SignoutManager()
    
    private init() {}
    
    func signout() async throws -> SignoutModel {
        let url = "https://api.tadabase.io/api/v1.1/2ejlW2BQo9/auth/logout"
        let result: SignoutModel = try await APIClient.shared.asyncRequest(
            baseURL: url,
            method: "POST",
            printResponse: true
        )
        
        return result
    }
}

class SignoutManagerViewModel: ObservableObject {
    
    static let shared = SignoutManagerViewModel()
    
    private init() {}
    
    @Published var response: SignoutModel?
    @Published var error: String?
    @Published var isLoading: Bool = false
    
    func signout() async -> Bool {
        DispatchQueue.main.async {
            self.error = nil
            self.isLoading = true
        }
        
        do {
            
            let response = try await SignoutManager.shared.signout()
            
            DispatchQueue.main.async {
                self.response = response
                self.isLoading = false
            }
            
            SessionManager.shared.timer?.invalidate()
            
            return true
            
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.isLoading = false
            }
            
            return false
        }
    }
}

struct SignoutModel: Codable {
    var status: String
    var msg: String
}
