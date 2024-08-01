//
//  File.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Vapor

extension Order {
    struct Create: Content, Sendable {
        let cupcakeID: UUID
        let quantity: Int
        let extraFrosting: Bool
        let addSprinkles: Bool
        let finalPrice: Double
    }
}
