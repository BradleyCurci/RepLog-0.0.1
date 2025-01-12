//
//  TokenModel.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

struct TokenModel: Codable {
    var token: String
    var user_id: String
    var expires_at: String
    var logged_in_since: String
    var status: String
}
