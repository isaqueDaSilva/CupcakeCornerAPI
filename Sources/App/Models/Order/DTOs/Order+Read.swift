//
//  Order+Read.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Vapor

extension Order {
    /// This DTO model is responsable for send
    /// a ``Order`` model into a readable format.
    struct Read: Content, Sendable {
        let id: UUID
        let userName: String
        let paymentMethod: PaymentMethod?
        let cupcake: UUID?
        let quantity: Int
        let extraFrosting: Bool
        let addSprinkles: Bool
        let finalPrice: Double
        let status: Status
        let orderTime: Date
        let readyForDeliveryTime: Date?
        let deliveredTime: Date?
    }
}
