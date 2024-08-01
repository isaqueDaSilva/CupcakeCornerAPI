//
//  Cupcake+Create.swift
//  
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake {
    /// It's responsable to decoding a Create Model
    /// that comes from a Request.
    struct Create: Content, Sendable {
        let flavor: String
        let coverImage: Data
        let ingredients: [String]
        let price: Double
    }
}
