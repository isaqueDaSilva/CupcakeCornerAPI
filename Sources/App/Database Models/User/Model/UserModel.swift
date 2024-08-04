//
//  File.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent
import Vapor

final class User: DatabaseModel, @unchecked Sendable {
    static let schema = SchemaName.user.rawValue
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldName.name.key)
    var name: String
    
    @Field(key: FieldName.email.key)
    var email: String
    
    @Field(key: FieldName.passwordHash.key)
    var passwordHash: String
    
    @Enum(key: FieldName.role.key)
    var role: Role
    
    @Enum(key: FieldName.paymentMethod.key)
    var paymentMethod: PaymentMethod
    
    @Children(for: \.$user)
    var tokens: [Token]
    
    @Children(for: \.$user)
    var orders: [Order]
    
    init() { }
    
    private init(
        id: UUID? = nil,
        name: String,
        email: String,
        passwordHash: String,
        role: Role,
        paymentMethod: PaymentMethod
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.role = role
        self.paymentMethod = paymentMethod
    }
}

extension User {
    convenience init(from dto: Create, and passwordHash: String) {
        self.init(
            name: dto.name,
            email: dto.email,
            passwordHash: passwordHash,
            role: dto.role,
            paymentMethod: dto.paymentMethod
        )
    }
}

extension User {
    func read() throws -> Read {
        guard let id else {
            throw Abort(.notAcceptable)
        }
        
        return .init(
            id: id,
            name: self.name,
            email: self.email,
            role: self.role,
            paymentMethod: self.paymentMethod
        )
    }
}

extension User {
    func update(from dto: Update) {
        if let updatedName = dto.name,
           updatedName != name {
            name = updatedName
        }
        
        if let updatedPaymentMethod = dto.paymentMethod,
           updatedPaymentMethod != paymentMethod {
            paymentMethod = updatedPaymentMethod
        }
    }
}
