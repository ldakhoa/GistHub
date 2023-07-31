import Foundation
import Networkable
import Models

public protocol GistHubServerClient {
    /// Get starred gists from the user name.
    func starredGists(fromUserName userName: String, page: Int) async throws -> GistsResponse
}

public final class DefaultGistHubServerClient: GistHubServerClient {
    private let session: NetworkSession

    public init(session: NetworkSession = .gisthubapp) {
        self.session = session
    }

    public func starredGists(fromUserName userName: String, page: Int) async throws -> GistsResponse {
        let gists: [Gist] = try await session.data(for: API.starredGists(userName: userName, page: page))
        return GistsResponse(gists: gists, hasNextPage: !gists.isEmpty)
    }
}

extension DefaultGistHubServerClient {
    enum API: Request {
        case starredGists(userName: String, page: Int)

        var url: String {
            switch self {
            case let .starredGists(userName, page):
                return "/users/\(userName)/starred?page=\(page)"
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
