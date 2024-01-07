import Foundation
import KeychainSwift
import Models

public enum AuthMethod: String, Codable {
    case oauth
    case pat
}

public struct AppAccount: Codable, Identifiable, Hashable {

    public let token: String
    public let authMethod: AuthMethod
    public var username: String?

    public var id: String {
        token
    }

    public init(
        token: String,
        authMethod: AuthMethod,
        username: String? = nil
    ) {
        self.token = token
        self.authMethod = authMethod
        self.username = username
    }
}

public extension AppAccount {
    private static var keychain: KeychainSwift {
        let keychain = KeychainSwift()
#if !DEBUG && !targetEnvironment(simulator)
        keychain.accessGroup = AppInfo.keychainGroup
#endif
        return keychain
    }

    var authorizationHeader: String {
        switch authMethod {
        case .oauth:
            return "Bearer \(token)"
        case .pat:
            return "token \(token)"
        }
    }

}
