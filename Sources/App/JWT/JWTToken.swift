//
//  File.swift
//  
//
//  Created by Isaque da Silva on 03/08/24.
//

import Vapor

struct JWTToken: Content, Sendable {
    let token: String
    
    init(from token: String) {
        self.token = token
    }
}
