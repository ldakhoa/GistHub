//
//  CommentAPIClient.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import Foundation
import Networkable

protocol CommentAPIClient {
    /// Get comments of the gist.
    func comments(gistID: String) async throws -> [Comment]
}

final class DefaultCommentAPIClient: CommentAPIClient {
    private let session: NetworkSession

    init(session: NetworkSession = .github) {
        self.session = session
    }

    func comments(gistID: String) async throws -> [Comment] {
        try await session.data(for: API.comments(gistID: gistID))
    }
}

extension DefaultCommentAPIClient {
    enum API: Request {
        case comments(gistID: String)

        var headers: [String: String]? {
            return [
                "Authorization": "Bearer \(PRIVATE_TOKEN)",
                "Accept": "application/vnd.github+json"
            ]
        }

        var url: String {
            switch self {
            case let .comments(gistID):
                return "/gists/\(gistID)/comments"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .comments:
                return .get
            }
        }

        func body() throws -> Data? {
            return nil
        }
    }
}
