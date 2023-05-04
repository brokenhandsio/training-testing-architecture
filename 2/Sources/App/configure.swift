import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // register migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateTodo())
    app.migrations.add(CreateToken())

    try await app.autoMigrate()

    app.services.todoService.use { app in
        FluentTodoService(database: app.db)
    }
    
    app.services.userService.use { app in
        FluentUserService(database: app.db)
    }
    
    app.services.tokenService.use { app in
        FluentTokenService(database: app.db)
    }

    // register routes
    try routes(app)
}
