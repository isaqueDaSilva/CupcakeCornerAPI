//
//  DatabaseOperation.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Foundation

protocol DatabaseOperation {
    associatedtype Create
    associatedtype Read: Codable
    associatedtype Update
    
    init(from dto: Create)
    func read() throws -> Read
    func update(from dto: Update)
}
