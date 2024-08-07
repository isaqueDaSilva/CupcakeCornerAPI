//
//  File.swift
//  
//
//  Created by Isaque da Silva on 8/7/24.
//

import Vapor

extension ByteBuffer {
    func decodeWebSocketMessage<T: Content>(_ model: T.Type) throws -> WebSocketMessage<T> {
        let webSocketMessage = try JSONDecoder().decode(WebSocketMessage<T>.self, from: self)
        
        return webSocketMessage
    }
}
