//
//  Token+Migration.swift
//  
//
//  Created by Isaque da Silva on 04/08/24.
//

import Fluent

extension Token {
    /// A Migration plan for perform actions into database.
    struct Migration: AsyncMigration {
        private let tokenSchemaName = SchemaName.token.rawValue
        private let userSchemaName = SchemaName.user.rawValue
        
        func prepare(on database: any Database) async throws {
            try await database.schema(tokenSchemaName)
                .id()
                .field(FieldName.jwtID.key, .uuid, .required)
                .field(FieldName.user.key, .uuid, .references(userSchemaName, "id"))
                .field(FieldName.isValid.key, .bool, .required)
                .unique(on: FieldName.jwtID.key)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(tokenSchemaName)
                .delete()
        }
    }
}
