//
//  SignUpManager.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

import Foundation

class SignUpManager {
    
    static var shared = SignUpManager()
    
    private init() {}
    
    func signUp(data: [String : Any]) async throws -> SignUpResponseModel {
        let url = "https://api.tadabase.io/api/v1/data-tables/4MXQJdrZ6v/records"
        let result: SignUpResponseModel = try await APIClient.shared.asyncRequest(
            baseURL: url,
            method: "POST",
            parameters: data,
            tokenRequired: false,
            printResponse: true
        )
        
        return result
    }
    
}

class SignUpViewModel: ObservableObject {
    
    static let shared = SignUpViewModel()
    
    private init() {}
    
    @Published var response: SignUpResponseModel?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func signUp(data: SignUpModel) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            
            let apiResponse = try await SignUpManager.shared.signUp(data: dictionary ?? [:])
             
            DispatchQueue.main.async {
                self.isLoading = false
                self.response = apiResponse
            }
            
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                print(self.error!)
                self.isLoading = false
            }
        }
    }
}
