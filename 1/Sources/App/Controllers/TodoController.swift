import Fluent
import Vapor

struct TodoController: RouteCollection {

    let memoryStore: MemoryStore

    init(memoryStore: MemoryStore) {
        self.memoryStore = memoryStore
    }

    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
    }

    func printAllTodos(req: Request) async throws -> HTTPStatus {
        #warning("Implement me!")
        return .ok
    }
}
