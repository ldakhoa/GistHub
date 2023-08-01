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

    private let gistHubClient: GistHubAPIClient
    private let serverClient: GistHubServerClient
    private var pagingCursor: String?
    private var originalGists: [Gist] = []
    private var isSearchingGists: Bool = false
    private var currentStarredPage: Int = 1
    private var hasMoreGists = false
    private let listsMode: GistListsMode

    public init(
        gistHubClient: GistHubAPIClient = DefaultGistHubAPIClient(),
        serverClient: GistHubServerClient = DefaultGistHubServerClient(),
        listsMode: GistListsMode
    ) {
        self.gistHubClient = gistHubClient
        self.serverClient = serverClient
        self.listsMode = listsMode
    }

    func fetchGists(refresh: Bool = false) async {
        do {
            isLoadingMoreGists = true
            let newGists = try await fetchGistsByListsMode()
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

    private func fetchGistsByListsMode() async throws -> [Gist] {
        let gistsResponse: GistsResponse
        switch listsMode {
        case .currentUserGists:
            gistsResponse = try await gistHubClient.gists(pageSize: Constants.pagingSize, cursor: pagingCursor)
            pagingCursor = gistsResponse.cursor
        case let .userStarredGists(userName):
            guard let userName else { return [] }
            gistsResponse = try await serverClient.starredGists(fromUserName: userName, page: currentStarredPage)
            currentStarredPage += 1
        case let .userGists(userName):
            gistsResponse = try await gistHubClient.gists(fromUserName: userName, pageSize: Constants.pagingSize, cursor: pagingCursor)
            pagingCursor = gistsResponse.cursor
        }
        hasMoreGists = gistsResponse.hasNextPage
        return gistsResponse.gists
    }

    func fetchMoreGistsIfNeeded(currentGistID: String) async {
        guard !isSearchingGists else {
            return
        }
        guard hasMoreGists,
            !isLoadingMoreGists,
            let lastGistID = gists.last?.id,
            currentGistID == lastGistID else {
            return
        }
        await fetchGists()
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

    func refreshGists() async {
        guard searchText.isEmpty else {
            return
        }
        hasMoreGists = false
        currentStarredPage = 1
        pagingCursor = nil
        await fetchGists(refresh: true)
    }
}

extension GistListsViewModel {
    enum ContentState {
        case loading
        case content
        case error(error: String)
    }

    enum Constants {
        static let pagingSize = 20
    }
}
