@testable import App
import Foundation
import XCTVapor

extension TestWorld {
    func addTodos() async throws {
        let user = User(id: UUID(), name: "Alice", password: "password")
        let todo1 = Todo(id: UUID(), title: "Buy milk", userID: user.id!)
        let todo2 = Todo(id: UUID(), title: "Walk the dog", userID: user.id!)
        try await context.todoService.add(todo: todo1)
        try await context.todoService.add(todo: todo2)
    }
}