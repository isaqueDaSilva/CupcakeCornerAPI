//
//  Collection+Extension.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent

extension Collection where Element: DatabaseOperation {
    func readAll() throws -> [Element.Read] {
        try self.map { model in
            try model.read()
        }
    }
}
