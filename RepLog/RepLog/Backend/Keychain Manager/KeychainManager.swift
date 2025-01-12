//
//  KeychainManager.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

import Foundation
import Security


class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    
    // Save an item to keychain
    func save(_ key: String, value: String) -> Bool {
        if let data  = value.data(using: .utf8) {
            let query: [String : Any] = [
                kSecClass as String         : kSecClassGenericPassword,
                kSecAttrAccount as String   : key,
                kSecValueData as String     : data
            ]
            
            // Delete the current item matching the save query
            SecItemDelete(query as CFDictionary)
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                // Error saving item
                print("Failed to save '\(key)' : '\(value)' to keychain\nStatus: \(status)")
                return false
            } else {
                return true
            }
        } else {
            // Error encoding
            print("Failed to encode '\(key)' : '\(value)'")
            return false
        }
    }
    
    
    // Get an item from keychain
    func get(_ key: String) -> String? {
        let query: [String : Any] = [
            kSecClass as String        : kSecClassGenericPassword,
            kSecAttrAccount as String  : key,
            kSecReturnData as String   : true,
            kSecMatchLimit as String   : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        
        // successfully found item matching key
        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            return value
        } else {
            print("Item with key '\(key)' not found")
            return nil
        }
    }
    
    
    // Delete an item from the keychain
    func delete(_ key: String) -> Bool {
        let query: [String : Any] = [
            kSecClass as String         : kSecClassGenericPassword,
            kSecAttrAccount as String   : key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            print("Failed to delete item with key '\(key)'")
            return false
        }
    }
}
