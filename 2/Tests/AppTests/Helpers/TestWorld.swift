import Vapor
@testable import App
import XCTVapor

struct TestWorld {

    static func create(stripeWebhookSecret: String = "some-secret-code", addTodos: Bool = true) async throws -> TestWorld {
        StackTrace.isCaptureEnabled = false
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let client = FakeClient(eventLoop: eventLoopGroup.next())
        let todoService = FakeTodoService()
        let userService = FakeUserService()
        let tokenService = FakeTokenService()
        
        setenv("STRIPE_WEBHOOK_SECRET", stripeWebhookSecret, 1)
        
        let application = Application(.testing, .shared(eventLoopGroup))

        try await configure(application)

        application.clients.use { _ in
            client
        }
        
        application.services.todoService.use { _ in
            todoService
        }
        
        application.services.userService.use { _ in
            userService
        }
        
        application.services.tokenService.use { _ in
            tokenService
        }

        let context = Context(
            app: application,
            stripeWebhookSecret: stripeWebhookSecret,
            client: client,
            todoService: todoService,
            userService: userService,
            tokenService: tokenService,
            eventLoopGroup: eventLoopGroup)
        
        let testWorld = TestWorld(context: context)

        if addTodos {
            try await testWorld.addTodos()
        }
        
        return testWorld
    }

    let context: Context

    init(context: Context) {
        self.context = context
    }

    struct Context {
        let app: Application
        let stripeWebhookSecret: String
        let client: FakeClient
        let todoService: FakeTodoService
        let userService: FakeUserService
        let tokenService: FakeTokenService
        let eventLoopGroup: EventLoopGroup
    }
    
    func shutdown() throws {
        context.app.shutdown()
        try context.eventLoopGroup.syncShutdownGracefully()
        unsetenv("STRIPE_WEBHOOK_SECRET")
    }
}
