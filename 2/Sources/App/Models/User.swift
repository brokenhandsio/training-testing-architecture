import Fluent
import Vapor

final class User: Model, Authenticatable {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String

    @Field(key: "password")
    var password: String
    
    @OptionalField(key: "siwaIdentifier")
    var siwaIdentifier: String?

    @Children(for: \.$user)
    var todos: [Todo]
    
    @Children(for: \.$user)
    var tokens: [Token]

    init() { }

    init(id: UUID? = nil, name: String, username: String, password: String, siwaIdentifier: String?) {
        self.id = id
        self.name = name
        self.username = username
        self.password = password
        self.siwaIdentifier = siwaIdentifier
        
    }
    
    struct Public: Content {
        let id: UUID
        let name: String
        let username: String
        let todos: [Todo]?
    }
    
    func convertToPublic() throws -> User.Public {
        try User.Public(id: self.requireID(), name: self.name, username: self.username, todos: self.$todos.value)
    }
}

extension User {
    func generateToken() throws -> Token {
        try .init(
            value: [UInt8].random(count: 32).base64,
            userID: self.requireID()
        )
    }
}

