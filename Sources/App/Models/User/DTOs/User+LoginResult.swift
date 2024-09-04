//
//  File.swift
//  
//
//  Created by Isaque da Silva on 8/31/24.
//

import Foundation
import Vapor

extension User {
    struct LoginResult: Content {
        let jwtToken: JWTToken
        let userProfile: Read
    }
}
