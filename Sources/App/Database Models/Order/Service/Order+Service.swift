//
//  Order+Service.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent
import Vapor

extension Order {
    /// Reunes all methos for manipulates
    /// an ``Order`` model into a specific route.
    enum Service {
        
        /// Creates a new ``Order`` in database.
        /// - Parameters:
        ///   - req: The current Request for perform some actions.
        ///   - dto: The ``Order/Create`` DTO for creates a
        ///    new ``Order``based into your data.
        ///   - userRole: The role of the user that is send a request.
        ///   - userID: The ID of the user that is send a request.
        ///   - cupcakeID: The ID of the ``Cupcake``
        ///    that the user is requsting.
        /// - Returns: Returns a ``Order/Read`` DTO for send into the route back to user.
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
        
        /// Fetch orders saved int the database for send back to user.
        /// - Parameters:
        ///   - req: The current Request for perform some actions.
        ///   - userRole: The role of the user that is send a request.
        ///   - userID: The ID of the user that is send a request.
        /// - Returns: Returns an array of ``Order/Read`` DTOs for send into the route back to user.
        static func read(
            with req: Request,
            _ userRole: Role,
            and userID: UUID
        ) async throws -> [Read] {
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
        
        
        /// Updates an ``Order`` into database.
        /// - Parameters:
        ///   - req: The current Request for perform some actions.
        ///   - userRole: The role of the user that is send a request.
        ///   - dto: An ``Order/Update`` DTO that is stores
        ///   all necessary informations for updates an ``Order`` into database.
        /// - Returns: Returns a ``Order/Read`` DTO for send into the route back to user.
        static func update(
            with req: Request,
            _ userRole: Role,
            and dto: Update
        ) async throws -> (Read, UUID) {
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
