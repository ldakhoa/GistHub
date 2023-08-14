import SwiftUI
import Models
import Networking

@MainActor
final class SearchGistListsViewModel: ObservableObject {
    @Published var gists: [Gist] = []
    @Published var searchResultLanguageSelected: String = ""
    @Published var searchResultLanguages: [GistSearchResultLanguage] = []
    @Published var contentState: ContentState = .loading
    @Published var isLoadingMoreGists = false
    @Published var sortOption: GistSearchResultSortOption = .bestMatch

    private var hasMoreGists = false
    private var searchGistsPage: Int = 1

    private let serverClient: GistHubServerClient

    init(serverClient: GistHubServerClient = DefaultGistHubServerClient()) {
        self.serverClient = serverClient
    }

    func fetchGists(from query: String, refresh: Bool = false) async {
        do {
            isLoadingMoreGists = true
            let newGists = try await fetchNewGists(from: query)
            if refresh {
                gists = newGists
            } else {
                gists.append(contentsOf: newGists)
            }
            isLoadingMoreGists = false
            contentState = .content
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func fetchMoreGistsIfNeeded(query: String, currentGistID: String) async {
        guard hasMoreGists,
            !isLoadingMoreGists,
            let lastGistID = gists.last?.id,
            currentGistID == lastGistID else {
            return
        }
        await fetchGists(from: query)
    }

    func refreshGists(from query: String) async {
        contentState = .loading
        hasMoreGists = false
        searchGistsPage = 1
        await fetchGists(from: query, refresh: true)
    }

    private func fetchNewGists(from query: String) async throws -> [Gist] {
        let gistSearchResult = try await serverClient.search(
            from: query,
            page: searchGistsPage,
            sortOption: sortOption
        )
        searchGistsPage += 1
        let gists = gistSearchResult.gists
        hasMoreGists = !gists.isEmpty
        searchResultLanguages = gistSearchResult.languages ?? []
        return gists
    }

    enum ContentState: Equatable {
        case loading
        case content
        case error(error: String)
    }
}
