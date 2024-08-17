//
//  TokenModel.swift
//  
//
//  Created by Isaque da Silva on 04/08/24.
//

import Fluent
import Foundation
import Vapor

/// Data representation of the Token
final class Token: Model, @unchecked Sendable {
    static let schema = SchemaName.token.rawValue
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldName.jwtID.key)
    var jwtID: UUID
    
    @Parent(key: FieldName.user.key)
    var user: User
    
    @Field(key: FieldName.isValid.key)
    var isValid: Bool
    
    init() { }
    
    init(
        id: UUID? = nil,
        with jwtID: UUID,
        and user: User.IDValue
    ) {
        self.id = id
        self.jwtID = jwtID
        self.$user.id = user
        self.isValid = true
    }
}

extension Token {
    
    /// Updates ``isValid`` parameter and determinates if this token is valid or not.
    /// - Parameter isValid: The value that indicates if this token is valid or not,
    func update(isValid: Bool) {
        self.isValid = isValid
    }
}
