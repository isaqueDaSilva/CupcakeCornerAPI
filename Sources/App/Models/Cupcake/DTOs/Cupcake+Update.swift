//
//  Cupcake+Update.swift
//  
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake {
    /// It's responsable to decoding an ``Update`` model
    /// that comes from a request
    struct Update: Content, Sendable {
        let flavor: String?
        let coverImage: Data?
        let ingredients: [String]?
        let price: Double?
    }
}
