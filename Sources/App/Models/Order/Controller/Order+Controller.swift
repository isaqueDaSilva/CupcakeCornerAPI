//
//  Order+Controller.swift
//
//
//  Created by Isaque da Silva on 8/6/24.
//

import Vapor

extension Order {
    /// Reunes all routes for manipulates an Order model.
    struct Controller: RouteCollection, ProtectedRoutesProtocol {
        let wsManager = WebSocketManager()
        
        func boot(routes: any RoutesBuilder) throws {
            let orderPath = routes.grouped("order")
            let protectedRoute = tokenProtectedRoute(with: orderPath)
            
            protectedRoute.post("create") { request async throws -> HTTPStatus in
                try await create(with: request)
            }
            
            protectedRoute.webSocket("channel") { request, wsChannel in
                connect(with: wsChannel, and: request)
            }
        }
        
        private func getUserInfo(with req: Request) async throws -> (UUID, Role) {
            let jwtToken = try req.auth.require(Payload.self)
            
            guard let user = try await User.query(on: req.db)
                .filter(\.$id, .equal, jwtToken.userID)
                .first()
            else {
                throw Abort(.notFound)
            }
            
            let userGetted = try user.read()
            
            return (userGetted.id, userGetted.role)
        }
        
        @Sendable
        private func create(with req: Request) async throws -> HTTPStatus {
            let (userID, userRole) = try await getUserInfo(with: req)
            
            guard userRole == .client else {
                throw Abort(.unauthorized)
            }
            
            let newOrderDTO = try req.content.decode(Create.self)
            
            guard let cupcake = try await Cupcake.query(on: req.db)
                .filter(\.$id, .equal, newOrderDTO.cupcakeID)
                .first(),
                  let cupcakeID = try? cupcake.requireID()
            else {
                throw Abort(.notFound)
            }
            
            let order = try await Service.create(
                with: req,
                newOrderDTO,
                userRole,
                userID,
                and: cupcakeID
            )
            
            wsManager.send(order, for: userID)
            
            return .ok
        }
        
        private func connect(
            with wsChannel: WebSocket,
            and req: Request
        ) {
            Task {
                do {
                    let (userID, userRole) = try await getUserInfo(with: req)
                    
                    await wsManager.connect(with: wsChannel, req, userID, and: userRole)
                    wsManager.messageHandler(with: wsChannel, and: req)
                } catch {
                    print("Failed to connect in this Web Socket channel.")
                }
            }
        }
    }
}
