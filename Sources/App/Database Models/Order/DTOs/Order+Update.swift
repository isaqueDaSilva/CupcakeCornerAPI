//
//  File.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Vapor

extension Order {
    struct Update: Content, Sendable {
        let id: UUID
        let status: Status
    }
}
