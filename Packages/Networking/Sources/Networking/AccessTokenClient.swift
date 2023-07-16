//
//  AccessTokenClient.swift
//  GistHub
//
//  Created by Khoa Le on 17/12/2022.
//

import Foundation
import Combine
import Networkable
import Models
import Environment

public struct AccessTokenUser: Codable {
    public let token: String
    public let username: String
}

public protocol AccessTokenClient {
    func requestAccessToken(
        code: String,
        promise: @escaping (Result<AccessTokenUser, Error>) -> Void
    )

    func verifyPersonalAccessTokenRequest(token: String) async throws -> User
}

public struct DefaultAccessTokenClient: AccessTokenClient {
    private let session: NetworkableSession

    public init(session: NetworkableSession = NetworkSession.accessToken) {
        self.session = session
    }

    public func requestAccessToken(
        code: String,
        promise: @escaping (Result<AccessTokenUser, Error>) -> Void
    ) {
        session.dataTask(
            for: API.accessToken(code: code),
            resultQueue: nil,
            decoder: JSONDecoder()
        ) { (result: Result<GitHubAccessToken, Error>) in
            switch result {
            case let .success(response):
                Task { @MainActor in
                    do {
                        let user = try await verifyPersonalAccessTokenRequest(token: response.accessToken)
                        let accessTokenUser = AccessTokenUser(token: response.accessToken, username: user.login ?? "")
                        promise(.success(accessTokenUser))
                    } catch let error {
                        promise(.failure(error))
                    }
                }
            case let .failure(error):
                promise(.failure(error))
            }
        }
    }

    public func verifyPersonalAccessTokenRequest(token: String) async throws -> User {
        try await session.data(
            for: API.user(token: token),
            decoder: JSONDecoder())
    }

    enum API: Request {
        case accessToken(code: String)
        case user(token: String)

        var url: String {
            switch self {
            case .accessToken:
                return "/login/oauth/access_token"
            case .user:
                return "https://api.github.com/user"
            }
        }

        var headers: [String: String]? {
            switch self {
            case .accessToken:
                return [
                    "Accept": "application/json",
                    "Content-Type": "application/json"
                ]
            case let .user(token):
                return ["Authorization": "token \(token)"]
            }

        }

        var method: Networkable.Method {
            switch self {
            case .accessToken:
                return .post
            case .user:
                return .get
            }
        }

        func body() throws -> Data? {
            switch self {
            case let .accessToken(code):
                let request = GitHubAccessTokenRequest(
                    code: code,
                    clientId: Secrets.GitHub.clientId,
                    clienSecret: Secrets.GitHub.clientSecret)
                return try? JSONEncoder().encode(request)
            default:
                return nil
            }

        }
    }
}

struct GitHubAccessToken: Codable {
    public let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

struct GitHubAccessTokenRequest: Encodable {
    let code: String
    let clientId: String
    let clienSecret: String

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.code, forKey: .code)
        try container.encode(self.clientId, forKey: .clientId)
        try container.encode(self.clienSecret, forKey: .clienSecret)
    }

    enum CodingKeys: String, CodingKey {
        case code
        case clientId = "client_id"
        case clienSecret = "client_secret"
    }
}
