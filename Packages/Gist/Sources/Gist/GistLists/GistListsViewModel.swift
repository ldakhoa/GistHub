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

    private let client: GistHubAPIClient
    private var pagingCursor: String?
    private var originalGists: [Gist] = []
    private var isSearchingGists: Bool = false
    private var currentStarredPage: Int = 1
    private var hasMoreGists = false

    public init(
        client: GistHubAPIClient = DefaultGistHubAPIClient()
    ) {
        self.client = client
    }

    func fetchGists(listsMode: GistListsMode) async {
        do {
            isLoadingMoreGists = true
            switch listsMode {
            case .currentUserGists:
                let gistsResponse = try await client.gists(pageSize: Constants.pagingSize, cursor: pagingCursor)
                pagingCursor = gistsResponse.cursor
                hasMoreGists = gistsResponse.hasNextPage
                originalGists.append(contentsOf: gistsResponse.gists)
                gists.append(contentsOf: gistsResponse.gists)
            case .currentUserStarredGists:
                let newGists = try await client.starredGists(page: currentStarredPage, perPage: Constants.pagingSize)
                hasMoreGists = !newGists.isEmpty
                currentStarredPage += 1
                originalGists.append(contentsOf: newGists)
                gists.append(contentsOf: newGists)
            case let .userGists(userName):
                let gistsResponse = try await client.gists(fromUserName: userName, pageSize: Constants.pagingSize, cursor: pagingCursor)
                pagingCursor = gistsResponse.cursor
                hasMoreGists = gistsResponse.hasNextPage
                originalGists.append(contentsOf: gistsResponse.gists)
                gists.append(contentsOf: gistsResponse.gists)
            }
            isLoadingMoreGists = false
            contentState = .content
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func fetchMoreGistsIfNeeded(currentGistID: String, listsMode: GistListsMode) async {
        guard !isSearchingGists else {
            return
        }
        guard hasMoreGists,
            !isLoadingMoreGists,
            let lastGistID = gists.last?.id,
            currentGistID == lastGistID else {
            return
        }
        await fetchGists(listsMode: listsMode)
    }

    func insert(_ gist: Gist) {
        gists.insert(gist, at: 0)
    }

    func search(listMode: GistListsMode) {
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
