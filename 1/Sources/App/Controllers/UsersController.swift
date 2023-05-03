import Fluent
import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("users")
    }
}
