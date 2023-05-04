import Fluent
import Vapor

struct FluentTokenService: TokenService {
    let database: Database
    
    func add(token: Token) async throws {
        try await token.create(on: database)
    }
    
    func getToken(value: String) async throws -> Token? {
        try await Token.query(on: database).filter(\.$value == value).first()
    }

    func `for`(_ request: Request) -> Self {
        .init(database: request.db)
    }
}
