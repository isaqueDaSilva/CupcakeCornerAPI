//
//  EnsureAdminUserMiddleware.swift
//
//
//  Created by Isaque da Silva on 03/08/24.
//

import Vapor

/// Checks if the User is an admin for perfom some actions.
struct EnsureAdminUserMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let user = request.auth.get(User.self), user.role == .admin else {
            throw Abort(.unauthorized)
        }
        
        return try await next.respond(to: request)
    }
}
