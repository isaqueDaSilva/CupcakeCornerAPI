//
//  Cupcake+FieldName.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent
import Vapor

extension Cupcake {
    /// It's responsable to store all field names for a Cupcake Model.
    enum FieldName: String, FieldKeysProtocol, ValidationProtocol {
        case flavor = "flavor"
        case coverImage = "cover_image"
        case ingredients = "ingredients"
        case price = "price"
        case createdAt = "created_at"
        
        /// Creates a `FieldKey` for every filed name case.
        var key: FieldKey {
            FieldKey(stringLiteral: self.rawValue)
        }
        
        /// Creates a `ValidationKey` for every field name case.
        var validationKey: ValidationKey {
            ValidationKey(stringLiteral: self.rawValue)
        }
    }
}
