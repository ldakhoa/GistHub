import Foundation
import KeychainSwift
import Models

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

    func save() throws {
    }

    static func getAll() -> [AppAccount] {
        []
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
}
