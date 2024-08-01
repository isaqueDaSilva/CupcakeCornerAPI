//
//  File.swift
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
            and user: User
        ) async throws -> Read {
            let cupcake = try await Cupcake.find(dto.cupcakeID, on: req.db)
            
            guard user.role == .client else {
                throw Abort(.unauthorized)
            }
            
            guard let cupcakeID = try cupcake?.requireID(),
                  let userID = try? user.requireID()
            else {
                throw Abort(.internalServerError)
            }
            
            let newOrder = Order(from: dto, cupcakeID, and: userID)
            
            try await newOrder.create(on: req.db)
            
            return try newOrder.read()
        }
        
        static func read(with req: Request, and userRole: Role, and userID: UUID) async throws -> [Read] {
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
        
        static func update(with req: Request, _ userRole: Role, and dto: Update) async throws -> Read {
            guard userRole == .admin else {
                throw Abort(.unauthorized)
            }
            
            guard let order = try await Order.find(dto.id, on: req.db) else {
                throw Abort(.notFound)
            }
            
            order.update(from: dto)
            
            try await order.save(on: req.db)
            
            return try order.read()
        }
    }
}
