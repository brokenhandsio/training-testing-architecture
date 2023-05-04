import Fluent
import Vapor

struct TodoController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
    }

    func printAllTodos(req: Request) async throws -> HTTPStatus {
        #warning("Implement me!")
        return .ok
    }
}
