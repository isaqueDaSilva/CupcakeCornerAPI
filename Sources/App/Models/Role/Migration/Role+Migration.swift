//
//  Role+Migration.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent

extension Role {
    /// A Migration plan for perform actions into database.
    struct Migration: AsyncMigration {
        let roleSchemaName = SchemaName.role.rawValue
        
        func prepare(on database: any Database) async throws {
            let _ = try await database.enum(roleSchemaName)
                .case(Role.admin.rawValue)
                .case(Role.client.rawValue)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.enum(roleSchemaName)
                .delete()
        }
    }
}
