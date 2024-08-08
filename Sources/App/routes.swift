import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: User.Controller())
    try app.register(collection: User.LoginController())
    try app.register(collection: Cupcake.Controller())
    try app.register(collection: Order.Controller())
}
