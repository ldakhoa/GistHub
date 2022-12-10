//
//  GistHubAPIClient.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import Networkable

protocol GistHubAPIClient {
    /// List gists for the authenticated user
    func gists() async throws -> [Gist]
}

final class DefaultGistHubAPIClient: GistHubAPIClient {
    private let session: NetworkSession

    init(session: NetworkSession = .github) {
        self.session = session
    }

    func gists() async throws -> [Gist] {
        try await session.data(for: API.gists)
    }
}

extension DefaultGistHubAPIClient {
    enum API: Request {
        case gists

        var headers: [String: String]? {
            return [
                "Authorization": "Bearer \(PRIVATE_TOKEN)"
            ]
        }

        var url: String {
            switch self {
            case .gists:
                return "/gists"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .gists:
                return .get
            }
        }

        func body() throws -> Data? {
            nil
        }
    }
}
