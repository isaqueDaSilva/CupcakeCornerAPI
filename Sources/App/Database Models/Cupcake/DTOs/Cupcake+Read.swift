//
//  Cupcake+Read.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake {
    /// It's responsable to creates an model for send in a request.
    struct Read: Content, Sendable {
        let id: UUID
        let flavor: String
        let coverImage: Data
        let ingredients: [String]
        let price: Double
        let createAt: Date
    }
}
