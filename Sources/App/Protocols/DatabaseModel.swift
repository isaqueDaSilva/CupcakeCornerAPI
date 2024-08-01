//
//  DatabaseModel.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent
import Vapor

/// A protocol that enables to create an schema for the database
/// and a Read model based on the model saved
/// for send in the request.
protocol DatabaseModel: Model, Content {
    associatedtype Read
    func read() throws -> Read
}
