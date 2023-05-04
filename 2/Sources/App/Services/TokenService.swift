import Vapor

protocol TokenService {
    func add(token: Token) async throws
    func getToken(value: String) async throws -> Token?
    func `for`(_ request: Request) -> Self
}

extension Application.Services {
    var tokenService: Application.Service<TokenService> {
        .init(application: self.application)
    }
}

extension Request.Services {
    var tokenService: TokenService {
        self.request.application.services.tokenService.service.for(request)
    }
}
