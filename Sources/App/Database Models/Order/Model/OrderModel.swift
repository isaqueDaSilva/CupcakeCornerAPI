//
//  Order.swift
//
//
//  Created by Isaque da Silva on 01/08/24.
//

import Fluent
import Vapor

final class Order: DatabaseModel, @unchecked Sendable {
    static let schema = SchemaName.order.rawValue
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalParent(key: FieldName.user.key)
    var user: User?
    
    @OptionalParent(key: FieldName.cupcake.key)
    var cupcake: Cupcake?
    
    @Field(key: FieldName.quantity.key)
    var quantity: Int
    
    @Field(key: FieldName.extraFrosting.key)
    var extraFrosting: Bool
    
    @Field(key: FieldName.addSprinkles.key)
    var addSprinkles: Bool
    
    @Field(key: FieldName.finalPrice.key)
    var finalPrice: Double
    
    @Enum(key: FieldName.status.key)
    var status: Status
    
    @Timestamp(key: FieldName.orderTime.key, on: .create, format: .iso8601)
    var orderTime: Date?
    
    @OptionalField(key: FieldName.readyForDeliveryTime.key)
    var readyForDeliveryTime: Date?
    
    @OptionalField(key: FieldName.deliveredTime.key)
    var deliveredTime: Date?
    
    init() { }
    
    private init(
        id: UUID? = nil,
        user: User.IDValue?,
        cupcake: Cupcake.IDValue?,
        quantity: Int,
        extraFrosting: Bool,
        addSprinkles: Bool,
        finalPrice: Double,
        status: Status,
        orderTime: Date? = nil,
        readyForDeliveryTime: Date? = nil,
        deliveredTime: Date? = nil
    ) {
        self.id = id
        self.$user.id = user
        self.$cupcake.id = cupcake
        self.quantity = quantity
        self.extraFrosting = extraFrosting
        self.addSprinkles = addSprinkles
        self.finalPrice = finalPrice
        self.status = status
        self.orderTime = orderTime
        self.readyForDeliveryTime = readyForDeliveryTime
        self.deliveredTime = deliveredTime
    }
}

extension Order {
    convenience init(
        from dto: Create,
        _ cupcakeID: Cupcake.IDValue,
        and userID: User.IDValue
    ) {
        self.init(
            user: userID,
            cupcake: cupcakeID,
            quantity: dto.quantity,
            extraFrosting: dto.extraFrosting,
            addSprinkles: dto.addSprinkles,
            finalPrice: dto.finalPrice,
            status: .ordered
        )
    }
}

extension Order {
    func read() throws -> Read {
        guard let orderTime, let id else {
            throw Abort(.notAcceptable)
        }
        
        return .init(
            id: id,
            userName: self.user?.name ?? "User Deleted",
            paymentMethod: self.user?.paymentMethod,
            cupcake: try self.cupcake?.requireID(),
            quantity: self.quantity,
            extraFrosting: self.extraFrosting,
            addSprinkles: self.addSprinkles,
            finalPrice: self.finalPrice,
            status: self.status,
            orderTime: orderTime,
            readyForDeliveryTime: self.readyForDeliveryTime,
            deliveredTime: self.deliveredTime
        )
    }
}

extension Order {
    func update(from dto: Update) {
        if dto.status != status {
            status = dto.status
        }
        
        switch dto.status {
        case .readyForDelivery:
            readyForDeliveryTime = .now
        case .delivered:
            deliveredTime = .now
        default:
            break
        }
    }
}
