import Fluent
import Vapor

struct FluentTodoService: TodoService {
    let database: Database

    func getTodos() async throws -> [Todo] {
        try await Todo.query(on: database).all()
    }

    func add(todo: Todo) async throws {
        try await todo.save(on: database)
    }

    func remove(todo: Todo) async throws {
        try await todo.delete(on: database)
    }

    func update(todo: Todo) async throws {
        try await todo.update(on: database)
    }

    func getTodos(for user: User) async throws -> [Todo] {
        try await Todo.query(on: database)
            .filter(\.$user.$id == user.requireID())
            .all()
    }

    func getTodo(id: UUID) async throws -> Todo? {
        try await Todo.find(id, on: database)
    }

    func `for`(_ request: Request) -> Self {
        .init(database: request.db)
    }
}