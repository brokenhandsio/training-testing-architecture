import Fluent
import Vapor
import JWT

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.post(use: createUser)
        
        let authRoutes = routes.grouped("auth")
        let loginRoutes = authRoutes.grouped("login").grouped(UserAuthMiddleware(), User.guardMiddleware())
        loginRoutes.post(use: loginUser)
        
        authRoutes.post("apple", use: appleAuthHandler)
    }
    
    func createUser(_ req: Request) async throws -> Token {
        let user = try req.content.decode(User.self)
        user.password = try await req.password.async.hash(user.password)
        user.id = user.id ?? UUID()
        try await req.services.userService.add(user: user)
        let token = try user.generateToken()
        try await req.services.tokenService.add(token: token)
        return token
    }
    
    func loginUser(_ req: Request) async throws -> Token {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await req.services.tokenService.add(token: token)
        return token
    }
    
    func appleAuthHandler(_ req: Request) async throws -> Token {
        let data = try req.content.decode(SignInWithAppleToken.self)
        let siwaToken = try await req.jwt.apple.verify(data.token)
        let user: User
        if let userFound = try await req.services.userService.getUser(siwaIdentifier: siwaToken.subject.value) {
            user = userFound
        } else {
            guard let email = siwaToken.email, let name = data.name else {
                throw Abort(.badRequest)
            }
            user = User(id: UUID(), name: name, username: email, password: UUID().uuidString, siwaIdentifier: siwaToken.subject.value)
            try await req.services.userService.add(user: user)
        }
        let token = try user.generateToken()
        try await req.services.tokenService.add(token: token)
        return token
    }
}

struct SignInWithAppleToken: Content {
    let token: String
    let name: String?
}
