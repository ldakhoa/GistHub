import Networkable
import Models
import AppAccount
import GistHubGraphQL
import Apollo
import Foundation

public protocol UserAPIClient {
    /// Get authenticated user info.
    func user() async throws -> User

    /// Get the user info from user name.
    func user(fromUserName userName: String) async throws -> User

    func followers(
        fromUserName userName: String,
        pageSize: Int,
        cursor: String?
    ) async throws -> UsersResponse

    func followings(
        fromUserName userName: String,
        pageSize: Int,
        cursor: String?
    ) async throws -> UsersResponse
}

public final class DefaultUserAPIClient: UserAPIClient {
    // MARK: - Dependencies

    private let session: NetworkSession
    private let graphQLSession: GraphQLNetworkSession

    // MARK: - Initializer

    public init(
        session: NetworkSession = .github,
        graphQLSession: GraphQLNetworkSession = GraphQLNetworkSession()
    ) {
        self.session = session
        self.graphQLSession = graphQLSession
    }

    // MARK: - UserAPIClient

    public func user() async throws -> User {
        try await session.data(for: API.user)
    }

    public func user(fromUserName userName: String) async throws -> User {
        try await session.data(for: API.userFromUserName(userName: userName))
    }

    public func followers(
        fromUserName userName: String,
        pageSize: Int,
        cursor: String?
    ) async throws -> UsersResponse {
        let query = FollowersQuery(
            login: userName,
            first: GraphQLNullable(integerLiteral: pageSize),
            after: cursor.mapSome { $0 }
        )
        let data = try await graphQLSession.query(query)
        guard let followers = data.user?.followers else { throw ApolloError.responseError }
        let response: UsersResponse = UsersResponse(
            users: (followers.nodes ?? []).compactMap { $0?.toUser },
            cursor: followers.pageInfo.endCursor ?? "",
            hasNextPage: followers.pageInfo.hasNextPage
        )
        return response
    }

    public func followings(
        fromUserName userName: String,
        pageSize: Int,
        cursor: String?
    ) async throws -> UsersResponse {
        let query = FollowingsQuery(
            login: userName,
            first: GraphQLNullable(integerLiteral: pageSize),
            after: cursor.mapSome { $0 }
        )
        let data = try await graphQLSession.query(query)
        guard let following = data.user?.following else { throw ApolloError.responseError }
        let response: UsersResponse = UsersResponse(
            users: (following.nodes ?? []).compactMap { $0?.toUser },
            cursor: following.pageInfo.endCursor ?? "",
            hasNextPage: following.pageInfo.hasNextPage
        )
        return response
    }
}

extension DefaultUserAPIClient {
    enum API: Request {
        case user
        case userFromUserName(userName: String)

        var url: String {
            switch self {
            case .user:
                return "/user"
            case let .userFromUserName(userName):
                return "/users/\(userName)"
            }
        }

        var headers: [String: String]? {
            let appAccountsManager = AppAccountsManager()
            guard let focusedUserSession = appAccountsManager.focusedAccount else { return [:] }

            return [
                "Authorization": focusedUserSession.authorizationHeader,
                "Accept": "application/vnd.github+json"
            ]
        }

        var method: Networkable.Method {
            switch self {
            case .user, .userFromUserName:
                return .get
            }
        }

        func body() throws -> Data? {
            nil
        }
    }
}
