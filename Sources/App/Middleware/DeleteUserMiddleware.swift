//
//  File.swift
//  
//
//  Created by Isaque da Silva on 06/08/24.
//

import Fluent
import Vapor

extension User {
    struct DeleteUserMiddleware: AsyncMiddleware {
        func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
            let jwtToken = try request.auth.require(Payload.self)
            
            guard let user = try await User.find(jwtToken.userID, on: request.db) else {
                throw Abort(.notFound)
            }
            
            let orders = try await user.$orders.get(on: request.db)
            
            let undeliveredOrders = orders.filter( { $0.status != .delivered && $0.deliveredTime == nil } )
            
            guard undeliveredOrders.isEmpty else {
                throw Abort(.notAcceptable)
            }
            
            let tokens = try await user.$tokens.get(on: request.db)
            
            guard !tokens.isEmpty else {
                return try await next.respond(to: request)
            }
            
            for token in tokens {
                try await token.delete(on: request.db)
            }
            
            return try await next.respond(to: request)
        }
    }
}
