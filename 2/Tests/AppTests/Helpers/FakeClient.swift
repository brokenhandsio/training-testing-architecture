import Vapor

class FakeClient: Client {

    var eventLoop: EventLoop
    var statusToReturn: HTTPStatus = .ok

    init(eventLoop: EventLoop) {
        self.eventLoop = eventLoop
    }

    private(set) var urlRequested: String?
    private(set) var methodUsed: HTTPMethod?
    private(set) var requestBody: Data?
    func send(_ request: ClientRequest) -> EventLoopFuture<ClientResponse> {
        self.urlRequested = request.url.string
        self.methodUsed = request.method
        if var body = request.body {
            self.requestBody = body.readData(length: body.readableBytes)
        }
        let response = ClientResponse(status: self.statusToReturn)
        return self.eventLoop.future(response)
    }

    func delegating(to eventLoop: EventLoop) -> Client {
        self.eventLoop = eventLoop
        return self
    }
}