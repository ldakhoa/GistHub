import Foundation
import Networkable
import Models

public protocol GistHubServerClient {
    /// Get starred gists from the user name.
    func starredGists(fromUserName userName: String) async throws -> [Gist]
}

public final class DefaultGistHubServerClient: GistHubServerClient {
    private let session: NetworkSession

    public init(session: NetworkSession = .gisthubapp) {
        self.session = session
    }

    public func starredGists(fromUserName userName: String) async throws -> [Gist] {
        try await session.data(for: API.starredGist(userName: userName))
    }
}

extension DefaultGistHubServerClient {
    enum API: Request {
        case starredGist(userName: String)

        var url: String {
            switch self {
            case let .starredGist(userName):
                return "/users/\(userName)/starred"
            }
        }

        var headers: [String: String]? {
            nil
        }

        var method: Networkable.Method {
            .get
        }

        func body() throws -> Data? {
            nil
        }
    }
}
