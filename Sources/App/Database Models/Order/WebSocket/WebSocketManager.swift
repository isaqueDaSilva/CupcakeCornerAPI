//
//  File.swift
//  
//
//  Created by Isaque da Silva on 8/7/24.
//

import Vapor

// MARK: Typealias
typealias WSManager = Order.WebSocketManager
typealias WSClient = Order.WebSocketClient
typealias OrderService = Order.Service
typealias Message = Order.WebSocketMessage

// MARK: Manager
extension Order {
    final class WebSocketManager: @unchecked Sendable {
        private var clients = [WSClient]()
        
        func connect(
            with wsChannel: WebSocket,
            _ request: Request,
            _ userID: UUID,
            and userRole: Role
        ) {
            wsChannel.onBinary { [weak self] (webSocket, buffer) async in
                guard let self else { return }
                
                self.binaryMessage(
                    with: buffer,
                    webSocket,
                    request,
                    userID,
                    and: userRole
                )
            }
            
            wsChannel.onText { [weak self] webSocket, _ in
                guard let self else { return }
                
                self.textMessage(with: webSocket)
            }
            
            wsChannel.onPing { [weak self] webSocket, _ in
                guard let self else { return }
                
                self.sendPongMessage(in: webSocket)
            }
            
            wsChannel.onClose.whenComplete { [weak self] webSocket in
                guard let self else { return }
                
                self.close(wsChannel)
            }
        }
    }
}

// MARK: WS message handler methods

// Binary data handler
extension WSManager {
    private func binaryMessage(
        with buffer: ByteBuffer,
        _ webSocket: WebSocket,
        _ request: Request,
        _ userID: UUID,
        and userRole: Role
    ) {
        if let message = try? buffer.decodeWebSocketMessage(Order.Receive.self) {
            if let client = self.get(by: webSocket) {
                client.insert(message.data)
                self.notify(client, with: request)
            } else {
                let client = WSClient(
                    id: userID,
                    role: userRole,
                    socket: webSocket,
                    data: message.data
                )
                
                self.add(client)
                
                self.notify(client, with: request)
            }
        }
    }
}

extension WSManager {
    private func textMessage(with wsChannel: WebSocket) {
        Task {
            try? await wsChannel.close(code: .unacceptableData)
            
            do {
                try self.removeBy(wsChannel)
            } catch {
                print("Falied to delete client by your current WebSocket with \(error.localizedDescription)")
            }
        }
    }
}

extension WSManager {
    private func close(_ wsChannel: WebSocket) {
        do {
            try self.removeBy(wsChannel)
        } catch {
            print("Falied to close this channel with \(error.localizedDescription)")
        }
    }
}

// MARK: WS communicator handler methods

// Ping handler
extension WSManager {
    private func sendPongMessage(in webSocket: WebSocket) {
        webSocket.onText { ws, message in
            let messageData = try? JSONEncoder().encode(message)
            
            guard let messageData else {
                ws.sendPing()
                return
            }
            
            ws.sendPing(messageData)
        }
    }
}

// Notify client
extension WSManager {
    private func notify(_ client: WSClient, with request: Request) {
        let clientID = client.getID()
        let webSocket = client.getSocket()
        let clientRole = client.getRole()
        
        guard !webSocket.isClosed else { return }
        
        guard let data = try? client.getData() else {
            Task {
                try? await webSocket.close(code: .unacceptableData)
            }
            
            return
        }
        
        switch data {
        case .get:
            Task {
                do {
                    try await getAllOrders(
                        with: request, 
                        webSocket,
                        clientRole,
                        and: clientID
                    )
                } catch {
                    try? await webSocket.close(code: .unacceptableData)
                    print("Falied to send orders with \(error.localizedDescription)")
                }
            }
        case .update(let updatedOrder):
            Task {
                do {
                    try await updateAnOrder(
                        with: client,
                        request,
                        and: updatedOrder
                    )
                } catch {
                    try? await webSocket.close(code: .unacceptableData)
                    print("Falied to updated order with \(error.localizedDescription)")
                }
            }
        case .disconnect:
            do {
                try removeBy(client)
            } catch {
                Task {
                    try? await webSocket.close(code: .unacceptableData)
                    print("Falied to remove client with \(error.localizedDescription)")
                }
            }
        }
    }
}

// Get All orders
extension WSManager {
    private func getAllOrders(
        with request: Request,
        _ currentWS: WebSocket,
        _ clientRole: Role,
        and clientID: UUID
    ) async throws{
        let allOrders = try await OrderService.read(
            with: request,
            clientRole,
            and: clientID
        )
        
        let orders: Order.Send = .allOrders(allOrders)
        let message = Message(data: orders)
        send(message, in: currentWS)
    }
}

// Update an Order
extension WSManager {
    private func updateAnOrder(
        with client: WSClient,
        _ request: Request,
        and updatedOrderDTO: Order.Update
    ) async throws {
        let (updatedOrder, userID) = try await OrderService.update(
            with: request,
            client.getRole(),
            and: updatedOrderDTO
        )
        
        let message = Message(data: updatedOrder)
        let admins = self.admins
        let userClient = self.get(by: userID)
        
        for admin in admins {
            self.send(message, in: admin.getSocket())
        }
        
        client.removeData()
        
        guard let userClient else { return }
        
        self.send(message, in: userClient.getSocket())
    }
}

// Send message
extension WSManager {
    private func send<M: Encodable>(_ message: M, in currentWS: WebSocket) {
        guard let data = try? JSONEncoder().encode(message) else {
            Task {
                try await currentWS.close(code: .unexpectedServerError)
            }
            return
        }
        
        currentWS.send([UInt8](data))
    }
}

extension WSManager {
    func send(_ order: Order.Read, for client: UUID) {
        let sendNewOrder: Order.Send = .newOrder(order)
        let message = Message<Order.Send>(data: sendNewOrder)
        
        let admins = self.admins
        let client = self.get(by: client)
        
        for admin in admins {
            self.send(message, in: admin.getSocket())
        }
        
        guard let client else { return }
        
        let clientWS = client.getSocket()
        
        self.send(message, in: clientWS)
    }
}

extension WSManager {
    private var admins: [WSClient] {
        clients.filter({ $0.getRole() == .admin })
    }
}

// MARK: Client list manipulator methods.
extension WSManager {
    private func allClients() -> [WSClient] { clients }
    
    private func add(_ client: WSClient) {
        clients.append(client)
    }
    
    private func get(by webSocket: WebSocket) -> WSClient? {
        let wsClient = clients.first { $0.getSocket() === webSocket }
        
        return wsClient
    }
    
    private func get(by id: UUID) -> WSClient? {
        let wsClient = clients.first { $0.getID() == id }
        
        return wsClient
    }
    
    private func removeBy(_ socket: WebSocket) throws {
        let clientIndex = clients.firstIndex { $0.getSocket() === socket }
        
        guard let clientIndex else {
            throw Abort(.notFound)
        }
        
        clients.remove(at: clientIndex)
    }
    
    private func removeBy(_ client: WSClient) throws {
        let index = clients.firstIndex(where: { $0.getID() == client.getID() })
        
        guard let index else { throw Abort(.notFound) }
        
        clients.remove(at: index)
    }
}
