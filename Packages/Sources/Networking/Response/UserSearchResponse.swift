import Foundation
import Models
import GistHubGraphQL

public struct UserSearchResponse {
    public let users: [User]
    public let cursor: String
    public let hasNextPage: Bool

    init(data: UserSearchQuery.Data) {
        self.hasNextPage = data.search.pageInfo.hasNextPage
        self.cursor = data.search.pageInfo.endCursor ?? ""

        let users = data.search.edges?
            .compactMap { $0?.node?.toUser } ?? []
        self.users = users
    }
}
