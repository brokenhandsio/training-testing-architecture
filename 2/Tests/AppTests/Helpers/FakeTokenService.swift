@testable import App
import Vapor

actor FakeTokenService: TokenService {
    var tokens: [Token] = []

    func getToken(value: String) async throws -> Token? {
        self.tokens.first(where: { $0.value == value })
    }
    
    func add(token: Token) async throws {
        self.tokens.append(token)
    }

    nonisolated func `for`(_ request: Request) -> Self {
        self
    }
}
