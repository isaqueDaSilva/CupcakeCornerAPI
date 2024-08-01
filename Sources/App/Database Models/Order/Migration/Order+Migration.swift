//
//  File.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent

extension Order {
    struct Migration: AsyncMigration {
        let orderSchemaName = SchemaName.order.rawValue
        let userSchemaName = SchemaName.user.rawValue
        let cupcakeSchemaName = SchemaName.cupcakes.rawValue
        let statusSchemaName = SchemaName.status.rawValue
        let idFieldKey = FieldKey(stringLiteral: "id")
        
        func prepare(on database: any Database) async throws {
            let status = try await database.enum(statusSchemaName).read()
            
            try await database.schema(orderSchemaName)
                .id()
                .field(FieldName.user.key, .uuid, .references(userSchemaName, idFieldKey))
                .field(FieldName.cupcake.key, .uuid, .references(cupcakeSchemaName, idFieldKey))
                .field(FieldName.quantity.key, .int, .required)
                .field(FieldName.extraFrosting.key, .bool, .required)
                .field(FieldName.addSprinkles.key, .bool, .required)
                .field(FieldName.finalPrice.key, .double, .required)
                .field(FieldName.status.key, status, .required)
                .field(FieldName.orderTime.key, .string)
                .field(FieldName.readyForDeliveryTime.key, .date)
                .field(FieldName.deliveredTime.key, .date)
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.schema(orderSchemaName)
                .delete()
        }
    }
}
