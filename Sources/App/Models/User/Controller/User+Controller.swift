//
//  User+Controller.swift
//  
//
//  Created by Isaque da Silva on 03/08/24.
//

import Vapor

extension User {
    struct Controller: RouteCollection, ProtectedRoutesProtocol {
        func boot(routes: any RoutesBuilder) throws {
            let userPath = routes.grouped("user")
            let protectedRoute = tokenProtectedRoute(with: userPath)
            
            userPath.post("create") { request async throws -> HTTPStatus in
                try await create(with: request)
            }
            
            protectedRoute.post("create-admin") { request async throws -> HTTPStatus in
                try await create(with: request)
            }
            
            protectedRoute.get("profile") { request async throws -> Read in
                try await get(with: request)
            }
            
            protectedRoute.patch("update") { request async throws -> Read in
                try await update(with: request)
            }
            
            protectedRoute.delete("delete") { request async throws -> HTTPStatus in
                try await delete(with: request)
            }
        }
        
        private func getUserId(with req: Request) async throws -> UUID {
            let jwtToken = try req.auth.require(Payload.self)
            
            let token = try await Token.query(on: req.db)
                .filter(\.$jwtID, .equal, jwtToken.id)
                .with(\.$user)
                .first()
            
            guard let token else {
                throw Abort(.unauthorized)
            }
        
            let userID = token.$user.id
            
            return userID
        }
        
        @Sendable
        private func create(with req: Request) async throws -> HTTPStatus {
            try Create.validate(content: req)
            let newUserDTO = try req.content.decode(Create.self)
            
            let status = try await Service.create(from: req, and: newUserDTO)
            
            return status
        }
        
        @Sendable
        private func get(with req: Request) async throws -> Read {
            let userID = try await getUserId(with: req)
            
            let user = try await Service.get(with: req, and: userID)
            
            return user
        }
        
        @Sendable
        private func update(with req: Request) async throws -> Read {
            let userID = try await getUserId(with: req)
            let updatedUserDTO = try req.content.decode(Update.self)
            
            let updatedUser = try await Service.update(with: req, userID, and: updatedUserDTO)
            
            return updatedUser
        }
        
        @Sendable
        private func delete(with req: Request) async throws -> HTTPStatus {
            let userID = try await getUserId(with: req)
            
            let status = try await Service.delete(with: req, and: userID)
            
            return status
        }
    }
}
