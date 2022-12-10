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
}

extension DefaultGistHubAPIClient {
    enum API: Request {
        case gists
        case starredGists

        var headers: [String: String]? {
            return [
                "Authorization": "Bearer \(PRIVATE_TOKEN)"
            ]
        }

        var url: String {
            switch self {
            case .gists:
                return "/gists"
            case .starredGists:
                return "/gists/starred"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .gists, .starredGists:
                return .get
            }
        }

        func body() throws -> Data? {
            nil
        }
    }
}
