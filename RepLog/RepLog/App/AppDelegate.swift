//
//  AppDelegate.swift
//  RepLog
//
//  Created by Brad Curci on 1/27/25.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        MainViewModel.shared.updateState(.loading)
        
        guard let email = KeychainManager.shared.get("email") else {
            DispatchQueue.main.async {
                MainViewModel.shared.updateState(.authentication)
            }
            
            return false
        }
        
        guard let password = KeychainManager.shared.get("password") else {
            DispatchQueue.main.async {
                MainViewModel.shared.updateState(.authentication)
            }
            
            return false
        }
        
        Task {
            let tokenResponse = await TokenViewModel.shared.loadToken(email: email, password: password)
            
            if !tokenResponse.0 {
                print("Unable to generate token. Redirecting to login")
                MainViewModel.shared.updateState(.authentication)
                return false
            }
            
            return true
        }
        
        MainViewModel.shared.updateState(.loggedIn)
        return true
    }
}
