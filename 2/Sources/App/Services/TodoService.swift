import Vapor

protocol TodoService {
    func getTodos() async throws -> [Todo]
    func add(todo: Todo) async throws
    func remove(todo: Todo) async throws
    func update(todo: Todo) async throws
    func getTodos(for user: User) async throws -> [Todo]
    func getTodo(id: UUID) async throws -> Todo?
    func `for`(_ request: Request) -> Self
}

extension Application.Services {
    var todoService: Application.Service<TodoService> {
        .init(application: self.application)
    }
}

extension Request.Services {
    var todoService: TodoService {
        self.request.application.services.todoService.service.for(request)
    }
}