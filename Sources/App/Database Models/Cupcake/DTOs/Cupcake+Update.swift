//
//  Cupcake+Update.swift
//  
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake {
    struct Update: Content, Sendable {
        let flavor: String?
        let coverImage: Data?
        let ingredients: [String]?
        let price: Double?
    }
}
