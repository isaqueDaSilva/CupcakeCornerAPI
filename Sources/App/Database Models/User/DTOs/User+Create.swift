//
//  File.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Vapor

extension User {
    struct Create: Content {
        let name: String
        let email: String
        let password: String
        let role: Role
        let paymentMethod: PaymentMethod
    }
}
