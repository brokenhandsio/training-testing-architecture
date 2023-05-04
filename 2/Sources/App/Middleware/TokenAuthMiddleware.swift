import Vapor

struct TokenAuthMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let bearerAuthorization = request.headers.bearerAuthorization else {
            return try await next.respond(to: request)
        }
        
        guard let token = try await request.services.tokenService.getToken(value: bearerAuthorization.token) else {
            return try await next.respond(to: request)
        }
        
        guard let user = try await request.services.userService.getUser(id: token.$user.id) else {
            throw Abort(.internalServerError)
        }
        
        request.auth.login(token)
        request.auth.login(user)
        return try await next.respond(to: request)
    }
}
