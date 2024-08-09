//
//  User+Seed.swift
//  
//
//  Created by Isaque da Silva on 8/7/24.
//

import Fluent
import Vapor

extension User {
    /// A default user admin to make login in the system and creates orhers admin.
    struct Seed: AsyncMigration {
        let adminName = Environment.get("ADMIN_NAME")
        let adminEmail = Environment.get("ADMIN_EMAIL")
        let adminPassword = Environment.get("ADMIN_PASSWORD")
        
        func prepare(on database: Database) async throws {
            guard let adminName, let adminEmail, let adminPassword else {
                throw Abort(.notAcceptable)
            }
            
            let user = Create(
                name: adminName,
                email: adminEmail,
                password: adminPassword,
                role: .admin,
                paymentMethod: .isAdmin
            )
            
            let passwordHash = try Bcrypt.hash(adminPassword)
            
            let admin = User(from: user, and: passwordHash)
            
            try await admin.create(on: database)
        }
        
        func revert(on database: Database) async throws {
            try await User.query(on: database)
                .delete()
        }
    }
}
