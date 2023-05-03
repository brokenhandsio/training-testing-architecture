import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    let memoryStore = MemoryStore()

    try app.register(collection: TodoController(memoryStore: memoryStore))
    try app.register(collection: UsersController(memoryStore: memoryStore))
}
