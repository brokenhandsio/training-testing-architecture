@testable import App
import Vapor

actor FakeTodoService: TodoService {
    var todos: [Todo] = []

    func getTodos() async throws -> [Todo] {
        todos
    }

    func add(todo: Todo) async throws {
        todos.append(todo)
    }

    func remove(todo: Todo) async throws {
        todos.removeAll { $0.id == todo.id }
    }

    func update(todo: Todo) async throws {
        todos.removeAll { $0.id == todo.id }
        todos.append(todo)
    }

    func getTodos(for user: User) async throws -> [Todo] {
        try todos.filter { try $0.$user.id == user.requireID() }
    }

    func getTodo(id: UUID) async throws -> Todo? {
        todos.first { $0.id == id }
    }

    nonisolated func `for`(_ request: Request) -> Self {
        self
    }
}