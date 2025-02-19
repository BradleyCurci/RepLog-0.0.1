//
//  SignUpModel.swift
//  RepLog
//
//  Created by Brad Curci on 1/11/25.
//

import Foundation

struct SignUpModel: Codable {
    var name: String
    var email: String
    var field_169: String
    var password: String
}

struct SignUpResponseModel: Codable {
    var type: String
    var msg: String
    var recordId: String
}
