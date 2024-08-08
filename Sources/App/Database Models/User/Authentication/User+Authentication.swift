//
//  User+Authentication.swift
//  
//
//  Created by Isaque da Silva on 03/08/24.
//

import Fluent
import Vapor

extension User: Authenticatable { }

extension User: ModelAuthenticatable {
    
    static var usernameKey: KeyPath<User, Field<String>> {
        \User.$email
    }
    
    static var passwordHashKey: KeyPath<User, Field<String>> {
        \User.$passwordHash
    }
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
