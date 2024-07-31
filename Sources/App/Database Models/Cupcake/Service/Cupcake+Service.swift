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
        private static func getCupcake(with req: Request, and id: String) async throws -> Cupcake {
            let cupcakeID = UUID(uuidString: id)
            
            guard let cupcake = try await Cupcake.find(cupcakeID, on: req.db) else {
                throw Abort(.notFound, reason: "This cupcake not exist in Database")
            }
            
            return cupcake
        }
        
        static func create(from req: Request, and dto: Create) async throws -> Read {
            let newCupcake = Cupcake(from: dto)
            
            try await newCupcake.create(on: req.db)
            
            return try newCupcake.read()
        }
        
        static func get(from req: Request) async throws -> [Read] {
            let cupcakes = try await Cupcake.query(on: req.db).all()
            
            return try cupcakes.readAll()
        }
        
        static func update(with req: Request, _ id: String, and dto: Update) async throws -> Read {
            let cupcake = try await getCupcake(with: req, and: id)
            
            cupcake.update(from: dto)
            
            try await cupcake.save(on: req.db)
            
            return try cupcake.read()
        }
        
        static func delete(with req: Request, and id: String) async throws -> HTTPStatus {
            let cupcake = try await getCupcake(with: req, and: id)
            
            try await cupcake.delete(on: req.db)
            
            return .ok
        }
    }
}
