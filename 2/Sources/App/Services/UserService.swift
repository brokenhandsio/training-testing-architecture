import Vapor

protocol UserService {
    func add(user: User) async throws
    func getUser(id: UUID) async throws -> User?
    func getUser(username: String) async throws -> User?
    func getUser(siwaIdentifier: String) async throws -> User?
    func `for`(_ request: Request) -> Self
}

extension Application.Services {
    var userService: Application.Service<UserService> {
        .init(application: self.application)
    }
}

extension Request.Services {
    var userService: UserService {
        self.request.application.services.userService.service.for(request)
    }
}
