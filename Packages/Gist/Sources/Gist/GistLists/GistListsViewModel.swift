//
//  HomeViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Models
import Networking
import Environment

@MainActor
public final class GistListsViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading
    @Published var searchText = ""

    @Published var gists: [Gist] = []
    @Published var isLoadingMoreGists = false
    @Published var sortOption: GistsSortOption = .created

    private let gistHubClient: GistHubAPIClient
    private let serverClient: GistHubServerClient
    private var pagingCursor: String?
    private var originalGists: [Gist] = []

    private var isSearchingGists: Bool = false

    private var currentGistsPage: Int = 1
    private var currentStarredPage: Int = 1
    private var currentDiscoverAllGistsPage: Int = 1
    private var currentDiscoverForkedGistsPage: Int = 1
    private var currentDiscoverStarredGistsPage: Int = 1
    private var hasMoreGists = false

    public init(
        gistHubClient: GistHubAPIClient = DefaultGistHubAPIClient(),
        serverClient: GistHubServerClient = DefaultGistHubServerClient()
    ) {
        self.gistHubClient = gistHubClient
        self.serverClient = serverClient
    }

    // MARK: - Side Effects - Public

    func fetchGists(
        mode: GistListsMode,
        refresh: Bool = false
    ) async {
        do {
            isLoadingMoreGists = true
            let newGists = try await fetchGistsByListsMode(mode: mode)
            if refresh {
                originalGists = newGists
                gists = newGists
            } else {
                originalGists.append(contentsOf: newGists)
                gists.append(contentsOf: newGists)
            }
            isLoadingMoreGists = false
            contentState = .content
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func fetchMoreGistsIfNeeded(currentGistID: String, mode: GistListsMode) async {
        guard !isSearchingGists else {
            return
        }
        guard hasMoreGists,
            !isLoadingMoreGists,
            let lastGistID = gists.last?.id,
            currentGistID == lastGistID else {
            return
        }
        await fetchGists(mode: mode)
    }

    func insert(_ gist: Gist) {
        gists.insert(gist, at: 0)
    }

    func search() {
        if searchText.isEmpty {
            // Restore the original list of gists
            gists = originalGists
            isSearchingGists = false
        } else {
            isSearchingGists = true
            gists = originalGists.filter {
                if let fileNames = $0.files?.map({ String($0.key) }), let loginName = $0.owner?.login {
                let fileNameCondition = fileNames.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
                    let loginNameCondition = loginName.localizedCaseInsensitiveContains(searchText)
                    let descriptionCondition = ($0.description ?? "").localizedCaseInsensitiveContains(searchText)
                    return !fileNameCondition.isEmpty || loginNameCondition || descriptionCondition
                }
                return false
            }
        }
    }

    func refreshGists(mode: GistListsMode) async {
        guard searchText.isEmpty else {
            return
        }
        contentState = .loading
        hasMoreGists = false
        currentStarredPage = 1
        currentDiscoverAllGistsPage = 1
        currentDiscoverStarredGistsPage = 1
        currentDiscoverForkedGistsPage = 1
        pagingCursor = nil
        await fetchGists(mode: mode, refresh: true)
    }

    // MARK: - Side Effects - Private

    private func fetchGistsByListsMode(mode: GistListsMode) async throws -> [Gist] {
        let gistsResponse: GistsResponse
        switch mode {
        case let .currentUserGists(filter):
            gistsResponse = try await gistHubClient.gists(
                pageSize: Constants.pagingSize,
                cursor: pagingCursor,
                privacy: filter,
                sortOption: sortOption
            )
            pagingCursor = gistsResponse.cursor
        case let .userStarredGists(userName):
            guard let userName else { return [] }
            gistsResponse = try await serverClient.starredGists(
                fromUserName: userName,
                page: currentStarredPage,
                sortOption: sortOption
            )
            currentStarredPage += 1
        case let .userGists(userName):
            gistsResponse = try await gistHubClient.gists(
                fromUserName: userName,
                pageSize: Constants.pagingSize,
                cursor: pagingCursor,
                sortOption: sortOption
            )
            pagingCursor = gistsResponse.cursor
        case let .discover(mode):
            switch mode {
            case .all:
                gistsResponse = try await serverClient.discoverGists(page: currentDiscoverAllGistsPage)
                currentDiscoverAllGistsPage += 1
            case .forked:
                gistsResponse = try await serverClient.discoverForkedGists(page: currentDiscoverForkedGistsPage)
                currentDiscoverForkedGistsPage += 1
            case .starred:
                gistsResponse = try await serverClient.discoverStarredGists(page: currentDiscoverForkedGistsPage)
                currentDiscoverStarredGistsPage += 1
            }
        }
        hasMoreGists = gistsResponse.hasNextPage
        return gistsResponse.gists
    }
}

extension GistListsViewModel {
    enum ContentState: Equatable {
        case loading
        case content
        case error(error: String)
    }

    enum Constants {
        static let pagingSize = 20
    }
}
