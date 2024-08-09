//
//  User+Update.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Vapor

extension User {
    /// It's responsable to decoding an ``Update`` model
    /// that comes from a request
    struct Update: Content {
        let name: String?
        let paymentMethod: PaymentMethod?
    }
}
