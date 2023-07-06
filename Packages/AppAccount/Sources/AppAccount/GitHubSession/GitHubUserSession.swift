//
//  GitHubUserSession.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import Foundation

public class GitHubUserSession: NSObject, NSCoding, Identifiable {
    public enum Keys {
        static let token = "token"
        static let authMethod = "authMethod"
        static let username = "username"
    }

    public enum AuthMethod: String {
        case oauth
        case pat
    }

    let token: String
    let authMethod: AuthMethod

    var username: String?

    public init(
        token: String,
        authMethod: AuthMethod,
        username: String?
    ) {
        self.token = token
        self.authMethod = authMethod
        self.username = username
    }

    convenience required public init?(coder: NSCoder) {
        guard let token = coder.decodeObject(forKey: Keys.token) as? String else { return nil }
        let storedAuthMethod = coder.decodeObject(forKey: Keys.authMethod) as? String
        let authMethod = storedAuthMethod.flatMap(AuthMethod.init) ?? .oauth
        let username = coder.decodeObject(forKey: Keys.username) as? String
        self.init(
            token: token,
            authMethod: authMethod,
            username: username
        )
    }

    public func encode(with coder: NSCoder) {
        coder.encode(token, forKey: Keys.token)
        coder.encode(authMethod.rawValue, forKey: Keys.authMethod)
        coder.encode(username, forKey: Keys.username)
    }
}

extension GitHubUserSession {
    public var authorizationHeader: String {
        switch authMethod {
        case .oauth:
            return "Bearer \(token)"
        case .pat:
            return "token \(token)"
        }
    }
}
