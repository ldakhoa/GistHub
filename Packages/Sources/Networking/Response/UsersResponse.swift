import OrderedCollections
import Models
import GistHubGraphQL
import Foundation

public struct UsersResponse {
    public let users: [User]
    public let cursor: String
    public let hasNextPage: Bool

    init(
        users: [User],
        cursor: String = "",
        hasNextPage: Bool
    ) {
        self.users = users
        self.cursor = cursor
        self.hasNextPage = hasNextPage
    }
}
