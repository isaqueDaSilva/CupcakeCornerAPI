//
//  File.swift
//  
//
//  Created by Isaque da Silva on 04/08/24.
//

import Fluent
import Foundation
import Vapor

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
        and user: User.IDValue,
        isValid: Bool = true
    ) {
        self.id = id
        self.jwtID = jwtID
        self.$user.id = user
        self.isValid = isValid
    }
}

extension Token {
    func update(isValid: Bool) {
        self.isValid = isValid
    }
}
