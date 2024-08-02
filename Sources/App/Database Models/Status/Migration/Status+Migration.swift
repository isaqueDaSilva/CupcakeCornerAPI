//
//  File.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent

extension Status {
    struct Migration: AsyncMigration {
        let statusSchemaName = SchemaName.status.rawValue
        
        func prepare(on database: any Database) async throws {
            let _ = try await database.enum(statusSchemaName)
                .case("ordered")
                .case("readyForDelivery")
                .case("delivered")
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.enum(statusSchemaName)
                .delete()
        }
    }
}
