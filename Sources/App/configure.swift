import NIOSSL
import Fluent
import FluentPostgresDriver
import JWT
import Vapor

/// Base configuration of the app.
public func configure(_ app: Application) async throws {
    // MARK: JWT Key Configuration
    guard let jwtSecret = Environment.get("JWT_SECRET") else {
        print("Failed to get a JWT secret.")
        return
    }
    
    await app.jwt.keys.add(hmac: .init(from: jwtSecret), digestAlgorithm: .sha256)
    
    // MARK: Database configuration.
    guard let databaseKey = Environment.get("DATABASE_KEY") else {
        await app.server.shutdown()
        throw Abort(.unauthorized)
    }
    
    try app.databases.use(.postgres(url: databaseKey), as: .psql)

    // MARK: Migrations.
    app.migrations.add(Status.Migration())
    app.migrations.add(PaymentMethod.Migration())
    app.migrations.add(Role.Migration())
    app.migrations.add(User.Migration())
    app.migrations.add(User.Seed())
    app.migrations.add(Token.Migration())
    app.migrations.add(Cupcake.Migration())
    app.migrations.add(Order.Migration())

    // MARK: Register Routes
    try routes(app)
}
