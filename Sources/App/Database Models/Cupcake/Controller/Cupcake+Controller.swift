//
//  Cupcake+Controller.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Vapor

extension Cupcake {
    struct Controller: RouteCollection, ProtectedRoutesProtocol {
        func boot(routes: any RoutesBuilder) throws {
            // TODO: Organize the routes...
        }
    }
    
    private func getID(with req: Request) throws -> String {
        guard let id = req.parameters.get("id") else {
            throw Abort(.notFound)
        }
        
        return id
    }
    
    private func create(with req: Request) async throws -> Read {
        try Create.validate(content: req)
        let dto = try req.content.decode(Create.self)
        
        return try await Service.create(from: req, and: dto)
    }
    
    private func get(with req: Request) async throws -> [Read] {
        try await Service.get(from: req)
    }
    
    private func update(with req: Request) async throws -> Read {
        let cupcakeID = try getID(with: req)
        let dto = try req.content.decode(Update.self)
        
        return try await Service.update(with: req, cupcakeID, and: dto)
    }
    
    private func delete(with req: Request) async throws -> HTTPStatus {
        let cupcakeID = try getID(with: req)
        
        return try await Service.delete(with: req, and: cupcakeID)
    }
}
