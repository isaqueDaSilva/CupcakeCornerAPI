//
//  Cupcake+FieldName.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent
import Vapor

extension Cupcake {
    enum FieldName: String, FieldKeysProtocol, ValidationProtocol {
        case flavor = "flavor"
        case coverImage = "cover_image"
        case ingredients = "ingredients"
        case price = "price"
        case createdAt = "created_at"
        
        var key: FieldKey {
            FieldKey(stringLiteral: self.rawValue)
        }
        
        var validationKey: ValidationKey {
            ValidationKey(stringLiteral: self.rawValue)
        }
    }
}
