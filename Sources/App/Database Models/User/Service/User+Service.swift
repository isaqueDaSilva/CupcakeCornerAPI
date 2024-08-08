//
//  User+Service.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent
import Vapor

extension User {
    enum Service {
        
        /// Gets an user based with your id.
        /// - Parameters:
        ///   - req: The current request model used for process the action.
        ///   - userID: The ID of the user that will be search.
        /// - Returns: Returns an ``User`` model.
        private static func getUser(with req: Request, and userID: UUID) async throws -> User {
            guard let user = try await User.find(userID, on: req.db) else {
                throw Abort(.notFound)
            }
            
            return user
        }
        
        /// Checks is the authenticate user is an admin for perform an action.
        /// - Parameter req: The current request model used for process the action.
        /// - Returns: Returns a boolean value that indicates if the user is admin or not.
        private static func isAdmin(with req: Request) async throws -> Bool {
            let jwtToken = try req.auth.require(Payload.self)
            
            guard let user = try? await getUser(with: req, and: jwtToken.userID),
                  user.role == .admin
            else {
                return false
            }
            
            return true
        }
        
        
        /// Creates a new User in the database
        /// - Parameters:
        ///   - req: The current request model used for process the action.
        ///   - dto: The ``User/Create`` model that is received from the request for create a new User
        /// - Returns: Returns a status that indicates if the action was finished with  successed or not.
        static func create(from req: Request, and dto: Create) async throws -> HTTPStatus {
            // If the new user is
            // marked as admin into your role,
            // will be checked if there is created by another admin.
            if dto.role == .admin {
                guard try await isAdmin(with: req) else {
                    throw Abort(.unauthorized)
                }
            }
            
            let passwordHash = try Bcrypt.hash(dto.password)
            let newUser = User(from: dto, and: passwordHash)
            
            try await newUser.save(on: req.db)
            
            return .ok
        }
        
        /// Find an User in database by your id and returns
        /// a ``User/Read`` for send back as result for user.
        /// - Parameters:
        ///   - req: The current request model used for process the action.
        ///   - id: The ID of the user that will be search.
        /// - Returns: Returns an ``User/Read`` model as result back to user thats makes the request.
        static func get(with req: Request, and id: UUID) async throws -> Read {
            let user = try await getUser(with: req, and: id)
            
            return try user.read()
        }
        
        /// Updates an User saved in the database.
        /// - Parameters:
        ///   - req: The current request model used for process the action.
        ///   - id: The ID of the user that will be search.
        ///   - dto: The ``User/Update`` that store all information for updates the User,
        /// - Returns: Returns an updated user.
        static func update(with req: Request, _ id: UUID, and dto: Update) async throws -> Read {
            let user = try await getUser(with: req, and: id)
            
            user.update(from: dto)
            
            try await user.save(on: req.db)
            
            return try user.read()
        }
        
        /// Delete an User in the database.
        /// - Parameters:
        ///   - req: The current request model used for process the action.
        ///   - id: The ID of the user that will be search.
        /// - Returns: Returns a status that indicates if the action was finished with  successed or not.
        static func delete(with req: Request, and id: UUID) async throws -> HTTPStatus {
            let user = try await getUser(with: req, and: id)
            
            try await user.delete(on: req.db)
            
            return .ok
        }
    }
}
