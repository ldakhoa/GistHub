//
//  CommentAPIClient.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import Foundation
import Networkable
import Models
import AppAccount

protocol CommentAPIClient {
    /// Get comments of the gist.
    func comments(gistID: String) async throws -> [Comment]

    /// Create a gist comment
    func createComment(gistID: String, body: String) async throws -> Comment

    /// Update a gist comment
    func updateComment(gistID: String, commentID: Int, body: String) async throws -> Comment

    /// Delete a gist comment
    func deleteComment(gistID: String, commentID: Int) async throws
}

final class DefaultCommentAPIClient: CommentAPIClient {
    private let session: NetworkSession

    init(session: NetworkSession = .github) {
        self.session = session
    }

    func comments(gistID: String) async throws -> [Comment] {
        try await session.data(for: API.comments(gistID: gistID))
    }

    func createComment(gistID: String, body: String) async throws -> Comment {
        try await session.data(for: API.createComment(gistID: gistID, body: body))
    }

    func updateComment(gistID: String, commentID: Int, body: String) async throws -> Comment {
        try await session.data(for: API.updateComment(gistID: gistID, commentID: commentID, body: body))
    }

    func deleteComment(gistID: String, commentID: Int) async throws {
        try await session.data(for: API.deleteComment(gistID: gistID, commentID: commentID))
    }
}

extension DefaultCommentAPIClient {
    enum API: Request {
        case comments(gistID: String)
        case createComment(gistID: String, body: String)
        case updateComment(gistID: String, commentID: Int, body: String)
        case deleteComment(gistID: String, commentID: Int)

        var headers: [String: String]? {
            let userSessionManager = GitHubSessionManager()
            return [
                "Authorization": userSessionManager.focusedUserSession!.authorizationHeader,
                "Accept": "application/vnd.github+json"
            ]
        }

        var url: String {
            switch self {
            case let .comments(gistID),
                let .createComment(gistID, _):
                return "/gists/\(gistID)/comments"
            case let .updateComment(gistID, commentID, _),
                let .deleteComment(gistID, commentID):
                return "/gists/\(gistID)/comments/\(commentID)"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .comments:
                return .get
            case .createComment:
                return .post
            case .updateComment:
                return .patch
            case .deleteComment:
                return .delete
            }
        }

        func body() throws -> Data? {
            switch self {
            case let .createComment(_, body),
                let .updateComment(_, _, body):
                let request: [String: String] = ["body": body]
                return try? JSONEncoder().encode(request)
            default:
                return nil
            }
        }
    }
}
