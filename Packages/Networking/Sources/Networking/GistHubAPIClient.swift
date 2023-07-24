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
import os

public protocol GistHubAPIClient: Client {
    /// Allows you to add a new gist with one or more files.
    func create(description: String?, files: [String: File], public: Bool) async throws -> Gist

    /// List gists for the authenticated user.
    func gists() async throws -> [Gist]

    /// List the authenticated user's starred gist.
    func starredGists() async throws -> [Gist]

    /// Get authenticated user info.
    func user() async throws -> User

    /// Star a gist.
    /// - Parameter gistID: ID of the gist to be starred
    /// - Returns: Bool value indicating if the gist is starred
    func starGist(gistID: String) async throws -> Bool

    /// Unstar a gist.
    /// - Parameter gistID: ID of the gist to be unstarred
    /// - Returns: Bool value indicating if the gist is starred
    func unstarGist(gistID: String) async throws -> Bool

    /// Check if gist is starred.
    func isStarred(gistID: String) async throws

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

    /// Update a gist description
    @discardableResult
    func updateDescription(
        fromGistID gistID: String,
        description: String?
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

    public func gists() async throws -> [Gist] {
        try await session.data(for: API.gists)
    }

    public func starredGists() async throws -> [Gist] {
        try await session.data(for: API.starredGists)
    }

    public func user() async throws -> User {
        try await session.data(for: API.user)
    }

    public func starGist(gistID: String) async throws -> Bool {
        let mutation = AddStarMutation(input: AddStarInput(starrableId: gistID))
        let data = try await graphQLSession.mutate(mutation)
        guard let starred = data.addStar?.starrable?.viewerHasStarred else {
            throw ApolloError()
        }
        return starred
    }

    public func unstarGist(gistID: String) async throws -> Bool {
        let mutation = RemoveStarMutation(input: RemoveStarInput(starrableId: gistID))
        let data = try await graphQLSession.mutate(mutation)
        guard let starred = data.removeStar?.starrable?.viewerHasStarred else {
            throw ApolloError()
        }
        return starred
    }

    public func isStarred(gistID: String) async throws {
        try await session.data(for: API.isStarred(gistID: gistID))
    }

    public func gist(fromGistID gistID: String) async throws -> Gist {
        try await session.data(for: API.gist(gistID: gistID))
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
    public func updateDescription(
        fromGistID gistID: String,
        description: String?
    ) async throws -> Gist {
        try await session.data(for: API.updateGistDescription(
            gistID: gistID,
            description: description
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
    }

    enum API: Request {
        case create(description: String?, files: [String: File], public: Bool)
        case gists
        case starredGists
        case user
        case starGist(gistID: String)
        case unstarGist(gistID: String)
        case isStarred(gistID: String)
        case gist(gistID: String)
        case updateGist(
            gistID: String,
            description: String?,
            files: [String: File?]
        )
        case updateGistDescription(
            gistID: String,
            description: String?
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
            case .starredGists:
                return "/gists/starred"
            case .user:
                return "/user"
            case let .starGist(gistID),
                let .unstarGist(gistID),
                let .isStarred(gistID):
                return "/gists/\(gistID)/star"
            case let .gist(gistID),
                let .deleteGist(gistID),
                let .updateGist(gistID, _, _),
                let .updateGistDescription(gistID, _):
                return "/gists/\(gistID)"
            case .createIssue:
                return "/repos/\(Constants.owner)/\(Constants.repo)/issues"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .create, .createIssue:
                return .post
            case .gists, .starredGists, .user, .isStarred, .gist:
                return .get
            case .starGist:
                return .put
            case .unstarGist, .deleteGist:
                return .delete
            case .updateGist, .updateGistDescription:
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

            case let .updateGistDescription(_, description):
                struct Request: Codable {
                    let description: String?
                }
                let request = Request(description: description)
                return try? JSONEncoder().encode(request)
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
