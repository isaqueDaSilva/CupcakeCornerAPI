//
//  CupcakeModel.swift
//
//
//  Created by Isaque da Silva on 31/07/24.
//

import Fluent
import Vapor

/// A representation of the Cupcake data.
final class Cupcake: DatabaseModel, @unchecked Sendable {
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

extension Cupcake {
    /// Creates a new Cupcake from the ``Create`` Model.
    /// - Parameter dto: A ``Create`` model that comes from a request.
    convenience init(
        from dto: Create,
        and req: Request? = nil
    ) {
        self.init(
            flavor: dto.flavor,
            coverImage: dto.coverImage,
            ingredients: dto.ingredients,
            price: dto.price
        )
    }
}

extension Cupcake {
    /// Transform a ``Cupcake`` model into a ``Read`` model
    /// for send into a request.
    /// - Returns: Returs a ``Read`` model.
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
}

extension Cupcake {
    /// Updates an existing ``Cupcake`` model
    /// from a ``Update`` dto that comes from a Request.
    /// - Parameter dto: An ``Update`` that comes from a Request.
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
