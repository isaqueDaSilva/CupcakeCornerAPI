//
//  User+LoginController.swift
//  
//
//  Created by Isaque da Silva on 03/08/24.
//

import Vapor

extension User {
    /// Reunes specifics routes for handle with the authentication and validates token.
    struct LoginController: RouteCollection, ProtectedRoutesProtocol {
        func boot(routes: any RoutesBuilder) throws {
            let userProtectedRoute = userProtectedRoute(by: routes)
            let tokenProtectedRoute = tokenProtectedRoute(with: routes)
            
            userProtectedRoute.post("login", ":type") { request async throws -> LoginResult in
                try await login(with: request)
            }
            
            tokenProtectedRoute.delete("user", "logout") { request async throws -> HTTPStatus in
                try await logout(with: request)
            }
        }
        
        private func getToken(with req: Request) throws -> Payload {
            try req.auth.require(Payload.self)
        }
        
        @Sendable
        private func login(with req: Request) async throws -> LoginResult {
            let user = try req.auth.require(User.self)
            
            let typeString = req.parameters.get("type")
            
            guard let typeString, let type = ApplicationType(rawValue: typeString) else {
                throw Abort(.notAcceptable)
            }
            
            switch type {
            case .forAdmin:
                guard user.role == .admin else {
                    throw Abort(.unauthorized)
                }
            case .forClient:
                guard user.role == .client else {
                    throw Abort(.unauthorized)
                }
            }
            
            let userID = try user.requireID()
            
            let payloadToken = try Payload(with: userID)
            
            let jwtToken = try await req.jwt.sign(payloadToken)
            
            let token = Token(with: payloadToken.id, and: userID)
            try await token.save(on: req.db)
            
            let userProfile = try user.read()
            let jwt = JWTToken(from: jwtToken)
            
            return .init(jwtToken: jwt, userProfile: userProfile)
        }
        
        @Sendable
        private func logout(with req: Request) async throws -> HTTPStatus {
            let jwtToken = try getToken(with: req)
            
            let user = try await User.find(jwtToken.userID, on: req.db)
            
            guard let user else {
                throw Abort(.notFound)
            }
            
            let token = try await user.$tokens.query(on: req.db)
                .filter(\.$jwtID, .equal, jwtToken.id)
                .first()
            
            guard let token else {
                throw Abort(.notFound)
            }
            
            try await token.delete(on: req.db)
            
            return .ok
        }
    }
}
