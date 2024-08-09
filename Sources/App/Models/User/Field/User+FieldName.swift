//
//  User+FieldName.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent
import Vapor

extension User {
    /// It's responsable to store all field names for a User Model.
    enum FieldName: String, FieldKeysProtocol, ValidationProtocol {
        case name = "name"
        case email = "email"
        case passwordHash = "password_hash"
        case password = "password"
        case confirmPassword = "confirm_password"
        case role = "role"
        case paymentMethod = "payment_method"
        
        var key: FieldKey {
            FieldKey(stringLiteral: self.rawValue)
        }
        
        var validationKey: ValidationKey {
            ValidationKey(stringValue: self.rawValue) ?? "" 
        }
    }
}
