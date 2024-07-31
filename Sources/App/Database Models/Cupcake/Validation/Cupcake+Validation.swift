//
//  Cupcake+Validation.swift
//  
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add(
            Cupcake.FieldName.flavor.validationKey,
            as: String.self,
            is: !.email,
            required: true
        )
        
        validations.add(
            Cupcake.FieldName.ingredients.validationKey,
            as: [String].self,
            is: !.empty,
            required: true
        )
        
        validations.add(
            Cupcake.FieldName.price.validationKey,
            as: Double.self,
            is: .range(1...),
            required: true
        )
    }
}
