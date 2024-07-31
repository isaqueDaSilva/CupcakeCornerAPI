//
//  Cupcake+Read.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake {
    struct Read: Content, Sendable {
        let id: UUID
        let flavor: String
        let coverImage: Data
        let ingredients: [String]
        let price: Double
        let createAt: Date
    }
}
