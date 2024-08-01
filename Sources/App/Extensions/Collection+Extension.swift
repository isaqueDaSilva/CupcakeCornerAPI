//
//  Collection+Extension.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Foundation

extension Collection where Element: DatabaseModel {
    /// Transform any Collection of any model that is conforming
    /// with the ``DatabaseModel`` protocol into a Read model.
    /// - Returns: Returns an array of Read model.
    func readAll() throws -> [Element.Read] {
        try self.map { model in
            try model.read()
        }
    }
}
