@testable import App
import Vapor

actor FakeUserService: UserService {
    var users: [User] = []

    func add(user: App.User) async throws {
        self.users.append(user)
    }
    
    func getUser(id: UUID) async throws -> App.User? {
        self.users.first(where: { $0.id == id })
    }
    
    func getUser(username: String) async throws -> App.User? {
        self.users.first(where: { $0.username == username })
    }
    
    func getUser(siwaIdentifier: String) async throws -> User? {
        self.users.first(where: { $0.siwaIdentifier == siwaIdentifier })
    }

    nonisolated func `for`(_ request: Request) -> Self {
        self
    }
}
