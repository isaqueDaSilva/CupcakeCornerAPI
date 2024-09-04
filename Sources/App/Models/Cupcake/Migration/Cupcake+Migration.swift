//
//  Cupcake+Migration.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent

extension Cupcake {
    /// Creates a Migration plan for Cupcake model to handle with the database.
    struct Migration: AsyncMigration {
        let schemaName = SchemaName.cupcakes.rawValue
        
        func prepare(on database: any Database) async throws {
            try await database.schema(schemaName)
                .id()
                .field(FieldName.flavor.key, .string, .required)
                .field(FieldName.coverImage.key, .data, .required)
                .field(FieldName.ingredients.key, .array(of: .string), .required)
                .field(FieldName.price.key, .double, .required)
                .field(FieldName.createdAt.key, .string)
                .unique(on: FieldName.flavor.key)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(schemaName)
                .delete()
        }
    }
}
