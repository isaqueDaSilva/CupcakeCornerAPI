//
//  File.swift
//  
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent

extension User {
    struct Migration: AsyncMigration {
        let userSchemaName = SchemaName.user.rawValue
        let roleSchemaName = SchemaName.role.rawValue
        let paymentMethodSchemaName = SchemaName.paymentMethod.rawValue
        
        func prepare(on database: any Database) async throws {
            
            let role = try await database.enum(roleSchemaName).read()
            let paymentMethod = try await database.enum(paymentMethodSchemaName).read()
            
            try await database.schema(userSchemaName)
                .id()
                .field(FieldName.name.key, .string, .required)
                .field(FieldName.email.key, .string, .required)
                .field(FieldName.passwordHash.key, .string, .required)
                .field(FieldName.role.key, role, .required)
                .field(FieldName.paymentMethod.key, paymentMethod, .required)
                .unique(on: FieldName.email.key)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(userSchemaName)
                .delete()
        }
    }
}
