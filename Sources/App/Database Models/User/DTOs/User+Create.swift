//
//  User+Create.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Vapor

extension User {
    /// It's responsable to decoding a ``Create`` Model
    /// that comes from a Request.
    struct Create: Content {
        let name: String
        let email: String
        let password: String
        let role: Role
        let paymentMethod: PaymentMethod
    }
}
