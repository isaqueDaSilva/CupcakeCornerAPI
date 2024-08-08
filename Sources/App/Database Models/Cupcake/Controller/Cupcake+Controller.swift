//
//  Cupcake+Controller.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake {
    /// Reunes all routes for manipulates a Cupcake model.
    struct Controller: RouteCollection, ProtectedRoutesProtocol {
        func boot(routes: any RoutesBuilder) throws {
            let cupcakePath = routes.grouped("cupcake")
            let tokenProtectedRoute = tokenProtectedRoute(with: cupcakePath)
            let adminProtectedRoute = tokenProtectedRoute.grouped(EnsureAdminUserMiddleware())
            
            tokenProtectedRoute.get("all") { request async throws -> [Read] in
                try await get(with: request)
            }
            
            adminProtectedRoute.on(.POST, "create", body: .collect(maxSize: "1mb")) { request async throws -> Read in
                try await create(with: request)
            }
            
            adminProtectedRoute.on(.PATCH, "update", ":id", body: .collect(maxSize: "1mb")) { request async throws -> Read in
                try await update(with: request)
            }
            
            adminProtectedRoute.delete("delete", ":id") { request async throws -> HTTPStatus in
                try await delete(with: request)
            }
        }
        
        private func getID(with req: Request) throws -> String {
            guard let id = req.parameters.get("id") else {
                throw Abort(.notFound)
            }
            
            return id
        }
        
        @Sendable
        private func create(with req: Request) async throws -> Read {
            try req.auth.require(Payload.self)
            try Create.validate(content: req)
            let dto = try req.content.decode(Create.self)
            
            return try await Service.create(from: req, and: dto)
        }
        
        @Sendable
        private func get(with req: Request) async throws -> [Read] {
            try req.auth.require(Payload.self)
            
            return try await Service.get(from: req)
        }
        
        @Sendable
        private func update(with req: Request) async throws -> Read {
            try req.auth.require(Payload.self)
            let cupcakeID = try getID(with: req)
            let dto = try req.content.decode(Update.self)
            
            return try await Service.update(with: req, cupcakeID, and: dto)
        }
        
        @Sendable
        private func delete(with req: Request) async throws -> HTTPStatus {
            try req.auth.require(Payload.self)
            let cupcakeID = try getID(with: req)
            
            return try await Service.delete(with: req, and: cupcakeID)
        }
    }
}
