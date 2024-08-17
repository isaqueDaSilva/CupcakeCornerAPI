//
//  Cupcake+Service.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent
import Vapor

extension Cupcake {
    enum Service {
        /// Gets a Cupcake model correspondent with the id.
        /// - Parameters:
        ///   - req: A `Request` model that is current used for perfoming the action.
        ///   - id: The cupcake's id that is passed into a request header.
        /// - Returns: Returns a cupcake model correspondent with the id passed.
        private static func getCupcake(with req: Request, and id: String) async throws -> Cupcake {
            let cupcakeID = UUID(uuidString: id)
            
            guard let cupcake = try await Cupcake.find(cupcakeID, on: req.db) else {
                throw Abort(.notFound)
            }
            
            return cupcake
        }
        
        /// Create a new ``Cupcake`` model in the database.
        /// - Parameters:
        ///   - req: A `Request` model that is current used for perfoming the action.
        ///   - dto: The ``Cupcake/Create`` model that is received from a Request header.
        /// - Returns: Return a ``Cupcake/Read`` model for return as response from a Request.
        static func create(from req: Request, and dto: Create) async throws -> Read {
            let newCupcake = Cupcake(from: dto)
            
            try await newCupcake.create(on: req.db)
            
            return try newCupcake.read()
        }
        
        /// Gets all Cupcakes saved in the database.
        /// - Parameter req: A `Request` model that is current used for perfoming the action.
        /// - Returns: Returns an array of ``Cupcake/Read`` as response from a Request.
        static func get(from req: Request) async throws -> [Read] {
            let cupcakes = try await Cupcake.query(on: req.db).all()
            
            return try cupcakes.readAll()
        }
        
        /// Updates an existing Cupcake.
        /// - Parameters:
        ///   - req: A `Request` model that is current used for perfoming the action.
        ///   - id: The id for perfoming a fetch action in the database,
        ///   and find a ``Cupcake`` model correspondent.
        ///   - dto: The ``Cupcake/Update`` model that is received from a Request header.
        /// - Returns: Return a ``Cupcake/Read`` model for return as response from a Request.
        static func update(with req: Request, _ id: String, and dto: Update) async throws -> Read {
            let cupcake = try await getCupcake(with: req, and: id)
            
            cupcake.update(from: dto)
            
            try await cupcake.save(on: req.db)
            
            return try cupcake.read()
        }
        
        /// Deleting an existing Cupcake model
        /// - Parameters:
        ///   - req: A `Request` model that is current used for perfoming the action.
        ///   - id: The id for perfoming a fetch action in the database,
        ///   and find a ``Cupcake`` model correspondent.
        /// - Returns: Returns a `HTTPStatus` when the action is finished.
        static func delete(with req: Request, and id: String) async throws -> HTTPStatus {
            let cupcake = try await getCupcake(with: req, and: id)
            
            try await cupcake.delete(on: req.db)
            
            return .ok
        }
    }
}
