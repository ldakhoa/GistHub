import Foundation
import Vapor

public struct User: Content, Codable, Equatable {
    public var userName: String?
    public var avatarUrl: String?

    public init(userName: String? = nil, avatarUrl: String? = nil) {
        self.userName = userName
        self.avatarUrl = avatarUrl
    }
}
