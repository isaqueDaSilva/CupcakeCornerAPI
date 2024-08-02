//
//  File.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent

extension Role {
    struct Migration: AsyncMigration {
        let roleSchemaName = SchemaName.role.rawValue
        
        func prepare(on database: any Database) async throws {
            let _ = try await database.enum(roleSchemaName)
                .case("admin")
                .case("client")
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.enum(roleSchemaName)
                .delete()
        }
    }
}
