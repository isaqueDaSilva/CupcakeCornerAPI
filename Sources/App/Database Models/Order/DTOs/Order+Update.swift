//
//  Order+Update.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Vapor

extension Order {
    /// This DTO model is responsable to decoding
    /// updated informations about a some order saved.
    struct Update: Content, Sendable {
        let id: UUID
        let status: Status
    }
}
