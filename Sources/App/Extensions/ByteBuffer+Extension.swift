//
//  ByteBuffer+Extension.swift
//
//
//  Created by Isaque da Silva on 8/7/24.
//

import Vapor

extension ByteBuffer {
    /// Gets the bytes in buffer and transform into some ``Order/WebSocketMessage`` model.
    /// - Parameter model: Describe what type of the message will be decoded.
    /// - Returns: Returns ``Order/WebSocketMessage`` model for use in the aplication.
    func decodeWebSocketMessage<T: Content>(_ model: T.Type) throws -> Order.WebSocketMessage<T> {
        let webSocketMessage = try JSONDecoder().decode(Order.WebSocketMessage<T>.self, from: self)
        
        return webSocketMessage
    }
}
