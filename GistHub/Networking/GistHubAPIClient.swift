//
//  GistHubAPIClient.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import Networkable

protocol GistHubAPIClient {
    /// List gists for the authenticated user.
    func gists() async throws -> [Gist]

    /// List the authenticated user's starred gist.
    func starredGists() async throws -> [Gist]

    /// Get authenticated user info.
    func user() async throws -> User

    /// Star a gist.
    func starGist(gistID: String) async throws

    /// Unstar a gist.
    func unstarGist(gistID: String) async throws

    /// Check if gist is starred.
    func isStarred(gistID: String) async throws

    /// Get a gist.
    func gist(fromGistID gistID: String) async throws -> Gist

    /// Delete a gist.
    func deleteGist(fromGistID gistID: String) async throws

    /// Get comments of the gist.
    func comments(gistID: String) async throws -> [Comment]
}

final class DefaultGistHubAPIClient: GistHubAPIClient {
    private let session: NetworkSession

    init(session: NetworkSession = .github) {
        self.session = session
    }

    func gists() async throws -> [Gist] {
        try await session.data(for: API.gists)
    }

    func starredGists() async throws -> [Gist] {
        try await session.data(for: API.starredGists)
    }

    func user() async throws -> User {
        try await session.data(for: API.user)
    }

    func starGist(gistID: String) async throws {
        try await session.data(for: API.starGist(gistID: gistID))
    }

    func unstarGist(gistID: String) async throws {
        try await session.data(for: API.unstarGist(gistID: gistID))
    }

    func isStarred(gistID: String) async throws {
        try await session.data(for: API.isStarred(gistID: gistID))
    }

    func gist(fromGistID gistID: String) async throws -> Gist {
        try await session.data(for: API.gist(gistID: gistID))
    }

    func deleteGist(fromGistID gistID: String) async throws {
        try await session.data(for: API.deleteGist(gistID: gistID))
    }

    func comments(gistID: String) async throws -> [Comment] {
        try await session.data(for: API.comments(gistID: gistID))
    }
}

extension DefaultGistHubAPIClient {
    enum API: Request {
        case gists
        case starredGists
        case user
        case starGist(gistID: String)
        case unstarGist(gistID: String)
        case isStarred(gistID: String)
        case gist(gistID: String)
        case deleteGist(gistID: String)
        case comments(gistID: String)

        var headers: [String: String]? {
            return [
                "Authorization": "Bearer \(PRIVATE_TOKEN)",
                "Accept": "application/vnd.github+json"
            ]
        }

        var url: String {
            switch self {
            case .gists:
                return "/gists"
            case .starredGists:
                return "/gists/starred"
            case .user:
                return "/user"
            case let .starGist(gistID),
                let .unstarGist(gistID),
                let .isStarred(gistID):
                return "/gists/\(gistID)/star"
            case let .gist(gistID), let .deleteGist(gistID):
                return "/gists/\(gistID)"
            case let .comments(gistID):
                return "/gists/\(gistID)/comments"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .gists, .starredGists, .user, .isStarred, .gist, .comments:
                return .get
            case .starGist:
                return .put
            case .unstarGist, .deleteGist:
                return .delete
            }
        }

        func body() throws -> Data? {
            nil
        }
    }
}