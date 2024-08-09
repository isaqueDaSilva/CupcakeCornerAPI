//
//  StatusModel.swift
//  
//
//  Created by Isaque da Silva on 01/08/24.
//

import Foundation

/// Representation of the status cases that ``Order`` can have.
enum Status: String, Codable {
    case ordered, readyForDelivery, delivered
}
