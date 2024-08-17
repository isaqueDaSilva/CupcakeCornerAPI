//
//  Order+Migration.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent

extension Order {
    /// Makes migration of the Order model in database.
    struct Migration: AsyncMigration {
        let orderSchemaName = SchemaName.order.rawValue
        let userSchemaName = SchemaName.user.rawValue
        let cupcakeSchemaName = SchemaName.cupcakes.rawValue
        let statusSchemaName = SchemaName.status.rawValue
        let idFieldKey = FieldKey(stringLiteral: "id")
        
        /// Creates a new table for ``Order`` model in database.
        func prepare(on database: any Database) async throws {
            let status = try await database.enum(statusSchemaName).read()
            
            try await database.schema(orderSchemaName)
                .id()
                .field(FieldName.user.key, .uuid, .references(userSchemaName, idFieldKey, onDelete: .setNull))
                .field(FieldName.cupcake.key, .uuid, .references(cupcakeSchemaName, idFieldKey, onDelete: .setNull))
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
        
        /// Perform some changes in ``Order`` table in database
        /// like update or delete action.
        func revert(on database: any Database) async throws {
            try await database.schema(orderSchemaName)
                .delete()
        }
    }
}
