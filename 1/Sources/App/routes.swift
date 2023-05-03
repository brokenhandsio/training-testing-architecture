import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    try app.register(collection: TodoController())
    try app.register(collection: UsersController())
}
