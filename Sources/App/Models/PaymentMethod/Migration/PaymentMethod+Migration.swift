//
//  PaymentMethod+Migration.swift
//
//
//  Created by Isaque da Silva on 02/08/24.
//

import Fluent

extension PaymentMethod {
    /// A Migration plan for perform actions into database.
    struct Migration: AsyncMigration {
        let paymentMethodSchemaName = SchemaName.paymentMethod.rawValue
        
        func prepare(on database: any Database) async throws {
            let _ = try await database.enum(paymentMethodSchemaName)
                .case("cash")
                .case("creditCard")
                .case("debitCard")
                .case("isAdmin")
                .create()
        }
        
        func revert(on database: any Database) async throws {
            try await database.enum(paymentMethodSchemaName)
                .delete()
        }
    }
}
