//
//  CupcakeModel.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent
import Foundation
import Vapor

final class Cupcake: Model, Content, @unchecked Sendable {
    static let schema = SchemaName.cupcakes.rawValue
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldName.flavor.key)
    var flavor: String
    
    @Field(key: FieldName.coverImage.key)
    var coverImage: Data
    
    @Field(key: FieldName.ingredients.key)
    var ingredients: [String]
    
    @Field(key: FieldName.price.key)
    var price: Double
    
    @Timestamp(key: FieldName.createdAt.key, on: .create)
    var createAt: Date?
    
    init() { }
    
    private init(
        id: UUID? = nil,
        flavor: String,
        coverImage: Data,
        ingredients: [String],
        price: Double,
        createAt: Date? = nil
    ) {
        self.id = id
        self.flavor = flavor
        self.coverImage = coverImage
        self.ingredients = ingredients
        self.price = price
        self.createAt = createAt
    }
}

extension Cupcake: DatabaseOperation {
    convenience init(from dto: Create) {
        self.init(
            flavor: dto.flavor,
            coverImage: dto.coverImage,
            ingredients: dto.ingredients,
            price: dto.price
        )
    }
    
    func read() throws -> Read {
        guard let id, let createAt else {
            throw Abort(.notAcceptable)
        }
        
        return Read(
            id: id,
            flavor: self.flavor,
            coverImage: self.coverImage,
            ingredients: self.ingredients,
            price: self.price,
            createAt: createAt
        )
    }
    
    func update(from dto: Update) {
        if let updatedFlavor = dto.flavor, updatedFlavor != flavor {
            flavor = updatedFlavor
        }
        
        if let updatedCoverImage = dto.coverImage, updatedCoverImage != coverImage {
            coverImage = updatedCoverImage
        }
        
        if let updateIngredients = dto.ingredients, updateIngredients != ingredients {
            ingredients = updateIngredients
        }
        
        if let updatedPrice = dto.price, updatedPrice != price {
            price = updatedPrice
        }
    }
}
