//
//  Order+WebSocketClient.swift
//
//
//  Created by Isaque da Silva on 8/7/24.
//

import Vapor

extension Order {
    /// An representation of the Client that is connected into WebSocket channel.
    final class WebSocketClient: @unchecked Sendable {
        private let id: UUID
        private let role: Role
        private let socket: WebSocket
        private var data: Receive?
        
        func getID() -> UUID { id }
        func getRole() -> Role { role }
        func getSocket() -> WebSocket { socket }
        
        func getData() throws -> Receive {
            guard let data else {
                throw Abort(.notFound)
            }
            
            return data
        }
        
        func insert(_ data: Receive) {
            self.data = data
        }
        
        func removeData() { self.data = nil }
        
        init(id: UUID, role: Role, socket: WebSocket, data: Receive?) {
            self.id = id
            self.role = role
            self.socket = socket
            self.data = data
        }
    }
}
