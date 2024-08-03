//
//  File.swift
//  
//
//  Created by Isaque da Silva on 03/08/24.
//

import Vapor

extension User {
    struct JWTToken: Content {
        let token: String
    }
}
