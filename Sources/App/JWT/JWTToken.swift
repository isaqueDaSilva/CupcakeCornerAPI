//
//  JWTToken.swift
//
//
//  Created by Isaque da Silva on 03/08/24.
//

import Vapor

/// An representation of the token value for send for some user in the request.
struct JWTToken: Content, Sendable {
    let token: String
    
    init(from token: String) {
        self.token = token
    }
}
