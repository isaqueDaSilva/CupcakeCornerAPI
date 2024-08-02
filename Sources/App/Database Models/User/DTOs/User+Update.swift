//
//  File.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Vapor

extension User {
    struct Update: Content {
        let name: String?
        let paymentMethod: PaymentMethod?
    }
}
