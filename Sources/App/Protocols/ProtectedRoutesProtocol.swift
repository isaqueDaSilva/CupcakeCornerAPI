//
//  ProtectedRoutesProtocol.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

protocol ProtectedRoutesProtocol { }

extension ProtectedRoutesProtocol {
    /// Creates an route protected by user authenticated.
    /// - Parameter routes: The top level route that used for aggregates some middleware
    ///  of User model to chek if has an user logged in the request and them perform the action that he wants.
    /// - Returns: Returns protected route that works only with some user authenticated.
    func userProtectedRoute(by routes: RoutesBuilder) -> RoutesBuilder {
        let userAuthenticator = User.authenticator()
        let userGuardMiddleware = User.guardMiddleware()
        
        return routes.grouped(userAuthenticator, userGuardMiddleware)
    }
    
    /// Creates an route protected by token authenticated.
    /// - Parameter routes: The top level route that used for aggregates the middlewares
    ///  of JWT token to chek if the token is valid and them perform the action that he wants.
    /// - Returns: Returns protected route that works only with valid JWT tokens.
    func tokenProtectedRoute(with routes: RoutesBuilder) -> RoutesBuilder {
        let tokenAuthenticator = Payload.authenticator()
        let tokenGuardMiddleware = Payload.guardMiddleware()
        
        return routes.grouped(tokenAuthenticator, tokenGuardMiddleware)
    }
}
