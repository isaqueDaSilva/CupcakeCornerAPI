//
//  Token+FieldName.swift
//  
//
//  Created by Isaque da Silva on 04/08/24.
//

import Fluent

extension Token {
    /// It's responsable to store all field names for a Token Model.
    enum FieldName: String, FieldKeysProtocol {
        case jwtID = "jwt_id"
        case user = "user_id"
        case isValid = "is_valid"
        
        var key: FieldKey {
            FieldKey(stringLiteral: self.rawValue)
        }
    }
}
