//
//  GistHubAPIClient.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import Networkable
import Models
import AppAccount
import GistHubGraphQL
import Apollo

public protocol GistHubAPIClient {
    /// Allows you to add a new gist with one or more files.
    func create(description: String?, files: [String: File], public: Bool) async throws -> Gist

    /// List gists for the authenticated user.
    func gists(pageSize: Int, cursor: String?) async throws -> GistsResponse

    /// List gists for from the user name.
    func gists(fromUserName userName: String, pageSize: Int, cursor: String?) async throws -> GistsResponse

    /// List the authenticated user's starred gist.
    func starredGists(page: Int, perPage: Int) async throws -> GistsResponse

    /// Get authenticated user info.
    func user() async throws -> User

    /// Search users from query.
    func searchUsers(from query: String, cursor: String?) async throws -> UserSearchResponse

    /// Get the user from user name.
    func user(fromUserName userName: String) async throws -> User

    /// Star a gist.
    /// - Parameter gistID: ID of the gist to be starred
    /// - Returns: Bool value indicating if the gist is starred
    func starGist(gistID: String) async throws -> Bool

    /// Unstar a gist.
    /// - Parameter gistID: ID of the gist to be unstarred
    /// - Returns: Bool value indicating if the gist is starred
    func unstarGist(gistID: String) async throws -> Bool

    /// Check if gist is starred.
    func isStarred(gistID: String) async throws -> Bool

    /// Get a gist.
    func gist(fromGistID gistID: String) async throws -> Gist

    /// Update a gist
    ///
    /// Allows you to update a gist's description and to update, delete, or rename gist files.
    @discardableResult
    func updateGist(
        fromGistID gistID: String,
        fileName: String?,
        content: String?
    ) async throws -> Gist

    /// Update multiple files of a gist.
    ///
    /// - Parameters:
    /// - gistID: The ID of the gist you want to update.
    /// - description: Your desired new description.
    /// - files: The new list of files.
    @discardableResult
    func updateGist(
        fromGistID gistID: String,
        description: String?,
        files: [String: File?]
    ) async throws -> Gist

    /// Delete a gist.
    func deleteGist(fromGistID gistID: String) async throws

    /// Create an issue.
    /// - Parameters:
    ///   - title: The title of the issue.
    ///   - content: The contents of the issue.
    func createIssue(withTitle title: String, content: String?) async throws
}

public final class DefaultGistHubAPIClient: GistHubAPIClient {
    private let session: NetworkSession
    private let graphQLSession: GraphQLNetworkSession

    public init(
        session: NetworkSession = .github,
        graphQLSession: GraphQLNetworkSession = GraphQLNetworkSession()
    ) {
        self.session = session
        self.graphQLSession = graphQLSession
    }

    public func create(description: String?, files: [String: File], public: Bool) async throws -> Gist {
        try await session.data(for: API.create(description: description, files: files, public: `public`))
    }

    public func gists(pageSize: Int, cursor: String?) async throws -> GistsResponse {
        let inputCursor: GraphQLNullable<String>
        if let cursor {
            inputCursor = GraphQLNullable(stringLiteral: cursor)
        } else {
            inputCursor = GraphQLNullable.none
        }
        let query = GistsQuery(
            first: GraphQLNullable(integerLiteral: pageSize),
            after: inputCursor,
            privacy: GraphQLNullable(GistPrivacy.all),
            orderBy: GraphQLNullable(Constants.defaultGistsOrdering)
        )
        let data = try await graphQLSession.query(query)
        return GistsResponse(data: data.viewer.gists)
    }

    public func gists(fromUserName userName: String, pageSize: Int, cursor: String?) async throws -> GistsResponse {
        let inputCursor: GraphQLNullable<String>
        if let cursor {
            inputCursor = GraphQLNullable(stringLiteral: cursor)
        } else {
            inputCursor = GraphQLNullable.none
        }
        let query = GistsFromUserQuery(
            userName: userName,
            privacy: GraphQLNullable(GistPrivacy.all),
            first: GraphQLNullable(integerLiteral: pageSize),
            after: inputCursor,
            orderBy: GraphQLNullable(Constants.defaultGistsOrdering)
        )
        let data = try await graphQLSession.query(query)
        guard let gists = data.user?.gists else {
            throw ApolloError.responseError
        }
        return GistsResponse(data: gists)
    }

    public func starredGists(page: Int, perPage: Int) async throws -> GistsResponse {
        let gists: [Gist] = try await session.data(for: API.starredGists(page: page, perPage: perPage))
        return GistsResponse(gists: gists, hasNextPage: !gists.isEmpty)
    }

    public func user() async throws -> User {
        try await session.data(for: API.user)
    }

    public func starGist(gistID: String) async throws -> Bool {
        let mutation = AddStarMutation(input: AddStarInput(starrableId: gistID))
        let data = try await graphQLSession.mutate(mutation)
        guard let starred = data.addStar?.starrable?.viewerHasStarred else {
            throw ApolloError.responseError
        }
        return starred
    }

    public func user(fromUserName userName: String) async throws -> User {
        try await session.data(for: API.userFromUserName(userName: userName))
    }

    public func searchUsers(from query: String, cursor: String?) async throws -> UserSearchResponse {
        let inputCursor: GraphQLNullable<String>
        if let cursor {
            inputCursor = GraphQLNullable(stringLiteral: cursor)
        } else {
            inputCursor = GraphQLNullable.none
        }

        let query = UserSearchQuery(username: query, after: inputCursor)
        let data = try await graphQLSession.query(query)
        let userSearchResponse = UserSearchResponse(data: data)
        return userSearchResponse
    }

    public func unstarGist(gistID: String) async throws -> Bool {
        let mutation = RemoveStarMutation(input: RemoveStarInput(starrableId: gistID))
        let data = try await graphQLSession.mutate(mutation)
        guard let starred = data.removeStar?.starrable?.viewerHasStarred else {
            throw ApolloError.responseError
        }
        return starred
    }

    public func isStarred(gistID: String) async throws -> Bool {
        let query = IsStarredQuery(gistID: gistID)
        let data = try await graphQLSession.query(query)
        guard let starred = data.viewer.gist?.viewerHasStarred else {
            throw ApolloError.responseError
        }
        return starred
    }

    public func gist(fromGistID gistID: String) async throws -> Gist {
        let query = GistQuery(gistID: gistID)
        let data = try await graphQLSession.query(query)
        guard let gist = data.gist else {
            throw ApolloError.responseError
        }
        return gist
    }

    public func deleteGist(fromGistID gistID: String) async throws {
        try await session.data(for: API.deleteGist(gistID: gistID))
    }

    @discardableResult
    public func updateGist(
        fromGistID gistID: String,
        fileName: String?,
        content: String?
    ) async throws -> Gist {
        try await session.data(for: API.updateGist(
            gistID: gistID,
            description: nil,
            files: [fileName ?? "": File(content: content)]
        ))
    }

    @discardableResult
    public func updateGist(
        fromGistID gistID: String,
        description: String?,
        files: [String: File?]
    ) async throws -> Gist {
        try await session.data(for: API.updateGist(
            gistID: gistID,
            description: description,
            files: files
        ))
    }

    public func createIssue(withTitle title: String, content: String?) async throws {
        try await session.data(for: API.createIssue(title: title, content: content))
    }
}

extension DefaultGistHubAPIClient {
    enum Constants {
        static let repo = "GistHub"
        static let owner = "ldakhoa"
        static let defaultGistsOrdering = GistOrder(field: .case(.createdAt), direction: .case(.desc))
    }

    enum API: Request {
        case create(description: String?, files: [String: File], public: Bool)
        case gists
        case gistsFromUserName(userName: String)
        case starredGists(
            page: Int,
            perPage: Int
        )
        case user
        case userFromUserName(userName: String)
        case searchUsersFromQuery(query: String)
        case starGist(gistID: String)
        case unstarGist(gistID: String)
        case isStarred(gistID: String)
        case gist(gistID: String)
        case updateGist(
            gistID: String,
            description: String?,
            files: [String: File?]
        )
        case deleteGist(gistID: String)
        case createIssue(title: String, content: String?)

        var headers: [String: String]? {
            let appAccountsManager = AppAccountsManager()
            guard let focusedUserSession = appAccountsManager.focusedAccount else { return [:] }

            return [
                "Authorization": focusedUserSession.authorizationHeader,
                "Accept": "application/vnd.github+json"
            ]
        }

        var url: String {
            switch self {
            case .create, .gists:
                return "/gists"
            case let .gistsFromUserName(userName):
                return "/users/\(userName)/gists"
            case let .starredGists(page, perPage):
                return "/gists/starred?page=\(page)&per_page=\(perPage)"
            case .user:
                return "/user"
            case let .userFromUserName(userName):
                return "/users/\(userName)"
            case let .searchUsersFromQuery(query):
                return "/search/users?q=\(query)"
            case let .starGist(gistID),
                let .unstarGist(gistID),
                let .isStarred(gistID):
                return "/gists/\(gistID)/star"
            case let .gist(gistID),
                let .deleteGist(gistID),
                let .updateGist(gistID, _, _):
                return "/gists/\(gistID)"
            case .createIssue:
                return "/repos/\(Constants.owner)/\(Constants.repo)/issues"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .create, .createIssue:
                return .post
            case .gists, .starredGists, .user, .isStarred, .gist, .gistsFromUserName, .userFromUserName, .searchUsersFromQuery:
                return .get
            case .starGist:
                return .put
            case .unstarGist, .deleteGist:
                return .delete
            case .updateGist:
                return .patch
            }
        }

        func body() throws -> Data? {
            switch self {
            case let .create(description, files, `public`):
                struct Request: Codable {
                    let files: [String: File]
                    let description: String?
                    let `public`: Bool

                    func toData() throws -> Data? {
                        return try? JSONEncoder().encode(self)
                    }
                }
                let request = Request(files: files, description: description, public: `public`)
                return try? request.toData()

            case let .updateGist(_, description, updatedFiles):
                struct Request: Codable {
                    let description: String?
                    let files: [String: File?]?
                    func toData() throws -> Data? {
                        return try? JSONEncoder().encode(self)
                    }
                }
                let request = Request(description: description, files: updatedFiles)
                return try? request.toData()
            case let .createIssue(title, content):
                struct Request: Codable {
                    let title: String
                    let body: String?
                    let labels: [String]?
                }
                let request = Request(title: title, body: content, labels: ["bug"])
                return try? JSONEncoder().encode(request)
            default:
                return nil
            }
        }
    }
}
