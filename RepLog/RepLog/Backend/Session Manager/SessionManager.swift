//
//  SessionManager.swift
//  RepLog
//
//  Created by Brad Curci on 1/27/25.
//

import Foundation

class SessionManager {
    
    static let shared = SessionManager()
    
    private init() {}
    
    var timer: Timer?
    
    var countdownTimer: Timer?
    var remainingSeconds: TimeInterval = 0
    
    
/*
    scheduleTokenRefresh is a member of the sessionManager than schedules
    bearer token regeneration. The bearer token is essential for any requests to
    The database, This function ensures the user always has a valid token.
*/
    func scheduleTokenRefresh() {
        
        Task {  // Fetch the users log status
            if let response = await StatusManagerViewModel.shared.fetchStatus().1 {
                
                let expirationString = response.expires_at
                let generationString = response.logged_in_since
                
                // format strings
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust as needed

                guard let expirationDate = dateFormatter.date(from: expirationString),
                      let generationDate = dateFormatter.date(from: generationString) else {
                    print("Error formatting dates")
                    return
                }
                
                
                let interval = expirationDate.timeIntervalSince(generationDate) // time between now and expiration
                remainingSeconds = expirationDate.timeIntervalSince(generationDate)
                
                guard interval > 0 else {
                    if timer == nil {
                        regenerateToken()
                    }
                    return
                }
                
                
                
                //MARK: DEBUGGING -----------------------------------------------------------------------------
                
//                DispatchQueue.main.async {
//                    print("remaining \(self.remainingSeconds)")
//                    self.countdownTimer?.invalidate()
//                    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//                        guard let self = self else { return }
//                    
//                        if self.remainingSeconds > 0 {
//                            print("Refreshing Token in \(Int(self.remainingSeconds)) seconds.")
//                            self.remainingSeconds -= 1
//                        } else {
//                            self.countdownTimer?.invalidate()
//                        }
//                    }
//                }
                 
                //MARK: DEBUGGING ------------------------------------------------------------------------------
                
                timer?.invalidate()
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                        self?.regenerateToken()
                    }
                }
            }
        }
    }
    
    func regenerateToken() {
        
        guard let email = KeychainManager.shared.get("email") else {
            print("Error regenerate token: Couldn't retrieve email from keychain")
            return
        }
        guard let password = KeychainManager.shared.get("password") else {
            print("Error regenerate token: Couldn't retrieve password from keychain")
            return
        }
        
        Task {
            let response = await TokenViewModel.shared.loadToken(email: email, password: password)
            if !response.0 {
                print("Error regenerating token: \(String(describing: response.1))")
            }
        }
    }
}
