//
//  ProtectedRoutesProtocol.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

protocol ProtectedRoutesProtocol { }

extension ProtectedRoutesProtocol {
    func userProtectedRoute(by routes: RoutesBuilder) -> RoutesBuilder {
        let userAuthenticator = User.authenticator()
        let userGuardMiddleware = User.guardMiddleware()
        
        return routes.grouped(userAuthenticator, userGuardMiddleware)
    }
    
    func tokenProtectedRoute(with routes: RoutesBuilder) -> RoutesBuilder {
        let tokenAuthenticator = Payload.authenticator()
        let tokenGuardMiddleware = Payload.guardMiddleware()
        
        return routes.grouped(tokenAuthenticator, tokenGuardMiddleware)
    }
}
