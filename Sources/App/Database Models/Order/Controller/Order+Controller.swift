//
//  File.swift
//  
//
//  Created by Isaque da Silva on 8/6/24.
//

import Vapor

extension Order {
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
        
        private func getUser(with req: Request) async throws -> (UUID, Role) {
            let jwtToken = try req.auth.require(Payload.self)
            
            guard let user = try await User.find(jwtToken.userID, on: req.db) else {
                throw Abort(.notFound)
            }
            
            let userGetted = try user.read()
            
            return (userGetted.id, userGetted.role)
        }
        
        @Sendable
        private func create(with req: Request) async throws -> HTTPStatus {
            let (userID, userRole) = try await getUser(with: req)
            
            let newOrderDTO = try req.content.decode(Create.self)
            
            guard let cupcake = try await Cupcake.find(
                newOrderDTO.cupcakeID,
                on: req.db
            ), let cupackeID = try? cupcake.requireID() else {
                throw Abort(.notFound)
            }
            
            let order = try await Service.create(
                with: req,
                newOrderDTO,
                userRole,
                userID,
                and: cupackeID
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
                    let jwtToken = try req.auth.require(Payload.self)
                    guard let user = try await User.find(jwtToken.userID, on: req.db),
                          let userID = try? user.requireID()
                    else {
                        try await wsChannel.close(code: .unexpectedServerError)
                        return
                    }
                    
                    wsManager.connect(with: wsChannel, req, userID, and: user.role)
                } catch {
                    print("Failed to connect in this Web Socket channel.")
                }
            }
        }
    }
}
