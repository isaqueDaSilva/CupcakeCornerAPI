//
//  File.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Vapor

extension User {
    struct Read: Content {
        let id: UUID
        let name: String
        let email: String
        let role: Role
        let paymentMethod: PaymentMethod
    }
}
