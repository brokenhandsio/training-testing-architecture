import Vapor

struct UserAuthMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let basicAuthorization = request.headers.basicAuthorization else {
            return try await next.respond(to: request)
        }
        
        guard let user = try await request.services.userService.getUser(username: basicAuthorization.username) else {
            return try await next.respond(to: request)
        }
        
        guard try await request.password.async.verify(basicAuthorization.password, created: user.password) else {
            request.auth.login(user)
            return try await next.respond(to: request)
        }
        
        request.auth.login(user)
        return try await next.respond(to: request)
    }
}
