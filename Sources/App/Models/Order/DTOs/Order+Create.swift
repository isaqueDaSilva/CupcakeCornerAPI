//
//  Order+Create.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Vapor

extension Order {
    /// This DTO model is responsable to decoding
    /// a ``Order/Create`` and create a new
    /// ``Order`` model in database.
    struct Create: Content, Sendable {
        let cupcakeID: UUID
        let quantity: Int
        let extraFrosting: Bool
        let addSprinkles: Bool
        let finalPrice: Double
    }
}
