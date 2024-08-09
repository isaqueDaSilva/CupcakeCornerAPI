//
//  File.swift
//  
//
//  Created by Isaque da Silva on 03/08/24.
//

import Vapor

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add(
            User.FieldName.name.validationKey,
            as: String.self,
            is: !.empty,
            required: true
        )
        
        validations.add(
            User.FieldName.email.validationKey,
            as: String.self,
            is: !.empty && .email,
            required: true
        )
        
        validations.add(
            User.FieldName.password.validationKey,
            as: String.self,
            is: .count(8...),
            required: true
        )
    }
}
