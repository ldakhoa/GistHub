import Foundation
import Models
import GistHubGraphQL

public struct StargazersResponse {
    public let users: [User]
    public let cursor: String
    public let hasNextPage: Bool

    init(data: StargazersFromGistDetailQuery.Data) {
        let stargazers = data.viewer.gist?.stargazers
        self.hasNextPage = stargazers?.pageInfo.hasNextPage ?? false
        self.cursor = stargazers?.pageInfo.endCursor ?? ""
        let users = stargazers?.nodes?.compactMap {
            $0?.toUser
        } ?? []
        self.users = users
    }
}
