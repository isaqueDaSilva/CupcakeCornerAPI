//
//  File.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent
import Vapor

extension User {
    enum Service {
        private static func getUser(with req: Request, and id: String) async throws -> User {
            let userID = UUID(uuidString: id)
            
            guard let user = try await User.find(userID, on: req.db) else {
                throw Abort(.notFound)
            }
            
            return user
        }
        
        static func create(from req: Request, and dto: Create) async throws -> Read {
            let passwordHash = try Bcrypt.hash(dto.password)
            let newUser = User(from: dto, and: passwordHash)
            
            try await newUser.save(on: req.db)
            
            return try newUser.read()
        }
        
        static func get(with req: Request, and id: String) async throws -> Read {
            let user = try await getUser(with: req, and: id)
            
            return try user.read()
        }
        
        static func update(with req: Request, _ id: String, and dto: Update) async throws -> Read {
            let user = try await getUser(with: req, and: id)
            
            user.update(from: dto)
            
            try await user.save(on: req.db)
            
            return try user.read()
        }
        
        static func delete(with req: Request, and id: String) async throws -> HTTPStatus {
            let user = try await getUser(with: req, and: id)
            
            try await user.delete(on: req.db)
            
            return .ok
        }
    }
}
