//
//  StatusManager.swift
//  RepLog
//
//  Created by Brad Curci on 1/27/25.
//

import Foundation

/// Status Manager is the driving function of the replog session manager. The Status manager must reliably call the status of the users token and indicate whether or not it is time to regenerate a token.

class StatusManager {
    
    static let shared = StatusManager()
    
    private init() {}
    
    func fetchStatus() async throws -> StatusModel {
        let url = "https://api.tadabase.io/api/v1.1/2ejlW2BQo9/auth/status?"
        let result: StatusModel = try await APIClient.shared.asyncRequest(
            baseURL: url,
            method: "POST",
            printResponse: false,
            printStatusCode: false
        )
        
        return result
    }
}

class StatusManagerViewModel: ObservableObject {
    
    static let shared = StatusManagerViewModel()
    
    private init() {}
    
    @Published var response: StatusModel?
    @Published var error: String?
    @Published var isLoading: Bool = false
    
    func fetchStatus() async -> (Bool, StatusModel?) {
        DispatchQueue.main.async {
            self.error = nil
            self.isLoading = true
        }
        
        do {
            let response = try await StatusManager.shared.fetchStatus()
            
            DispatchQueue.main.async {
                self.response = response
                self.isLoading = false
            }
            
            return (true, response)
            
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.isLoading = false
            }
            
            return (false, nil)
        }
    }
}

struct StatusModel: Codable {
    var status: String
    var msg: String
    var expires_at: String
    var logged_in_since: String
    var user_id: String
}
