//
//  UserModel.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent
import Vapor

/// A representation of the User data.
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
    /// Creates a new User from the ``Create`` DTO model.
    /// - Parameters:
    ///   - dto: A ``Create`` model that comes from a request.
    ///   - passwordHash: A cauculated hash of the password for stores into database.
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
    /// Transform a ``User`` model into a ``Read`` model
    /// for send into a request.
    /// - Returns: Returs a ``Read`` model.
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
    /// Updates an existing ``User`` model
    /// from a ``Update`` dto that comes from a Request.
    /// - Parameter dto: An ``Update`` that comes from a Request.
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

extension User {
    /// Checks if the current user is an admin.
    /// - Parameter req: The current Request type utilized in the request.
    /// - Returns: Returns an boolean value that indicates if the user is or not an admin.
    static func isAdmin(with req: Request) async throws -> Bool {
        let jwtToken = try req.auth.require(Payload.self)
        
        guard let user = try await User.find(jwtToken.userID, on: req.db),
              user.role == .admin
        else {
            return false
        }
        
        return true
    }
}
