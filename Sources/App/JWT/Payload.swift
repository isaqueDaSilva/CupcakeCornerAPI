//
//  Payload.swift
//
//
//  Created by Isaque da Silva on 02/08/24.
//

import Foundation
import JWT
import Vapor

struct Payload: Content, Authenticatable, JWTPayload {
    
    // The token is valid for 14 days after your creation.
    let expirationTime: TimeInterval = (60 * 60 * 24 * 14)
    
    let subject: SubjectClaim
    let expiration: ExpirationClaim
    let userID: UUID
    
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
    
    init(with userID: UUID) throws {
        guard let subjectClaim = Environment.get("CUPCAKE_CORNER_JWTSUB") else {
            print("CUPCAKE_CORNER_JWTSUB was not found.")
            throw Abort(.notFound)
        }
        
        self.subject = .init(value: subjectClaim)
        self.expiration = .init(value: Date().addingTimeInterval(expirationTime))
        self.userID = userID
    }
}

extension Payload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case userID = "user_id"
    }
}
