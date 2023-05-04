import Fluent
import Vapor

struct FluentUserService: UserService {
    let database: Database
    
    func add(user: User) async throws {
        try await user.create(on: database)
    }
    
    func getUser(id: UUID) async throws -> User? {
        try await User.find(id, on: database)
    }
    
    func getUser(username: String) async throws -> User? {
        try await User.query(on: database).filter(\.$username == username).first()
    }
    
    func getUser(siwaIdentifier: String) async throws -> User? {
        try await User.query(on: database).filter(\.$siwaIdentifier == siwaIdentifier).first()
    }

    func `for`(_ request: Request) -> Self {
        .init(database: request.db)
    }
}
