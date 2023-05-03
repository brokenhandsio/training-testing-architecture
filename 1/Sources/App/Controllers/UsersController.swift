import Fluent
import Vapor

struct UsersController: RouteCollection {

    let memoryStore: MemoryStore

    init(memoryStore: MemoryStore) {
        self.memoryStore = memoryStore
    }

    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("users")
    }
}
