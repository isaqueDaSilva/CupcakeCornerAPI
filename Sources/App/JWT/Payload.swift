//
//  Payload.swift
//
//
//  Created by Isaque da Silva on 02/08/24.
//

import JWT

struct Payload: JWTPayload {
    
    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var isAdmin: Bool
    
    func verify(using algorithm: some JWTKit.JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()
    }
}

extension Payload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case isAdmin = "admin"
    }
}
