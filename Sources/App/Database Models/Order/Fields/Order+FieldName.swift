//
//  Order+FieldName.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent
import Vapor

extension Order {
    /// Field keys collection of all properties of the Order model in database.
    enum FieldName: String, FieldKeysProtocol, ValidationProtocol {
        case user = "user_id"
        case cupcake = "cupcake_id"
        case quantity = "quantity"
        case extraFrosting = "extra_frosting"
        case addSprinkles = "add_sprinkles"
        case finalPrice = "final_price"
        case status = "status"
        case orderTime = "order_time"
        case readyForDeliveryTime = "ready_for_delivery_time"
        case deliveredTime = "delivered_time"
        
        var key: FieldKey {
            FieldKey(stringLiteral: self.rawValue)
        }
        
        var validationKey: ValidationKey {
            ValidationKey(stringLiteral: self.rawValue)
        }
    }
}
