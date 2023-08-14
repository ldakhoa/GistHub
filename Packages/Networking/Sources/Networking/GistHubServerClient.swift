import Foundation
import Networkable
import Models

public protocol GistHubServerClient {
    /// Get starred gists from the user name.
    func starredGists(fromUserName userName: String, page: Int) async throws -> GistsResponse

    func discoverGists(page: Int) async throws -> GistsResponse
    func discoverStarredGists(page: Int) async throws -> GistsResponse
    func discoverForkedGists(page: Int) async throws -> GistsResponse

    func search(
        from query: String,
        page: Int,
        language: String,
        sortOption: GistSearchResultSortOption
    ) async throws -> GistSearchResult
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

    public func discoverGists(page: Int) async throws -> GistsResponse {
        let gists: [Gist] = try await session.data(for: API.discoverGists(page: page))
        return GistsResponse(gists: gists, hasNextPage: !gists.isEmpty)
    }

    public func discoverStarredGists(page: Int) async throws -> GistsResponse {
        let gists: [Gist] = try await session.data(for: API.discoverStarredGists(page: page))
        return GistsResponse(gists: gists, hasNextPage: !gists.isEmpty)
    }

    public func discoverForkedGists(page: Int) async throws -> GistsResponse {
        let gists: [Gist] = try await session.data(for: API.discoverForkedGists(page: page))
        return GistsResponse(gists: gists, hasNextPage: !gists.isEmpty)
    }

    public func search(
        from query: String,
        page: Int,
        language: String,
        sortOption: GistSearchResultSortOption
    ) async throws -> GistSearchResult {
        try await session.data(
            for: API.search(query: query,
            page: page,
            language: language,
            sortOption: sortOption)
        )
    }
}

extension DefaultGistHubServerClient {
    enum API: Request {
        case starredGists(userName: String, page: Int)
        case discoverGists(page: Int)
        case discoverStarredGists(page: Int)
        case discoverForkedGists(page: Int)
        case search(query: String, page: Int, language: String, sortOption: GistSearchResultSortOption)

        var url: String {
            switch self {
            case let .starredGists(userName, page):
                return "/users/\(userName)/starred?page=\(page)"
            case let .discoverGists(page):
                return "/discover?page=\(page)"
            case let .discoverStarredGists(page):
                return "/discover/starred?page=\(page)"
            case let .discoverForkedGists(page):
                return "/discover/forked?page=\(page)"
            case let .search(query, page, language, gistSearchResultSortOption):
                return "/search?q=\(query)&l=\(language)&p=\(page)&o=\(gistSearchResultSortOption.sortOption.direction)&s=\(gistSearchResultSortOption.sortOption.field.rawValue)"
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
