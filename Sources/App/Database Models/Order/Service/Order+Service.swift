//
//  Order+Service.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent
import Vapor

extension Order {
    enum Service {
        static func create(
            with req: Request,
            _ dto: Create,
            _ userRole: Role,
            _ userID: UUID,
            and cupcakeID: UUID
        ) async throws -> Read {
            guard userRole == .client else {
                throw Abort(.unauthorized)
            }
            
            let newOrder = Order(from: dto, cupcakeID, and: userID)
            
            try await newOrder.create(on: req.db)
            
            return try newOrder.read()
        }
        
        static func read(with req: Request, _ userRole: Role, and userID: UUID) async throws -> [Read] {
            let ordersQuery = Order.query(on: req.db)
            
            if userRole == .client {
                ordersQuery
                    .filter(\.$user.$id == userID)
            }
            
            let orders = try await ordersQuery
                .group(.or) { group in
                    group
                        .filter(\.$status == .ordered)
                        .filter(\.$status == .readyForDelivery)
                }
                .with(\.$user)
                .with(\.$cupcake)
                .all()
            
            return try orders.readAll()
        }
        
        static func update(with req: Request, _ userRole: Role, and dto: Update) async throws -> (Read, UUID) {
            guard userRole == .admin else {
                throw Abort(.unauthorized)
            }
            
            guard let order = try await Order.find(dto.id, on: req.db) else {
                throw Abort(.notFound)
            }
            
            order.update(from: dto)
            
            try await order.save(on: req.db)
            
            guard let userID = try order.user?.requireID() else {
                throw Abort(.notAcceptable)
            }
            
            guard let order = try? order.read() else {
                throw Abort(.notAcceptable)
            }
            return (order, userID)
        }
    }
}
