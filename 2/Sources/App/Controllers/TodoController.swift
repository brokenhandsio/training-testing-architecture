import Fluent
import Vapor

struct TodoController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: getAllHandler)
        
        let protected = todos.grouped(TokenAuthMiddleware(), Token.guardMiddleware())
        protected.get("mine", use: getMineHnadler)
    }

    func getAllHandler(req: Request) async throws -> [Todo] {
        try await req.services.todoService.getTodos()
    }
    
    func getMineHnadler(req: Request) async throws -> [Todo] {
        let user = try req.auth.require(User.self)
        let todos = try await req.services.todoService.getTodos(for: user)
        return todos
    }
}
