//
//  User+Read.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Vapor

extension User {
    /// It's responsable to creates an model for send in a request.
    struct Read: Content {
        let id: UUID
        let name: String
        let email: String
        let role: Role
        let paymentMethod: PaymentMethod
    }
}
