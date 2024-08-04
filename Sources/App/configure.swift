import NIOSSL
import Fluent
import FluentPostgresDriver
import JWT
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    let hostname = "api.cupcakecorner"
    let port = 8443
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.http.server.configuration.supportVersions = [.two]
    app.http.server.configuration.hostname = hostname
    app.http.server.configuration.port = port
    
    try await app.server.start(address: .hostname(hostname, port: port))
    
    guard let jwtSecret = Environment.get("JWT_SECRET") else {
        print("Failed to get a JWT secret.")
        return
    }
    
    await app.jwt.keys.add(hmac: .init(from: jwtSecret), digestAlgorithm: .sha256)
    
    // MARK: Database configuration.
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    // MARK: Migrations.
    app.migrations.add(Cupcake.Migration())

    // register routes
    try routes(app)
}
