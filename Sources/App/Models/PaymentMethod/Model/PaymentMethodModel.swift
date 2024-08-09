//
//  PaymentMethodModel.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Foundation

/// Representation of the cases suporteds for payment in the store.
enum PaymentMethod: String, Codable {
    case cash, creditCard, debitCard, isAdmin
}
