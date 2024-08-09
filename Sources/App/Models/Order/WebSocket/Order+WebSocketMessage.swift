//
//  Order+WebSocketMessage.swift
//  
//
//  Created by Isaque da Silva on 8/7/24.
//

import Vapor

extension Order {
    /// A representation of the message that will be send or received into WS channel.
    struct WebSocketMessage<T: Content>: Content {
        let data: T
    }
}

extension Order {
    enum Send: Content, Sendable {
        case newOrder(Order.Read)
        case allOrders([Order.Read])
        case update(Order.Read)
    }
    
    enum Receive: Content, Sendable {
        case get
        case update(Order.Update)
        case disconnect
    }
}
