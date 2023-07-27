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

    @Published var gists = [Gist]()
    @Published var hasMoreGists = false
    @Published var isLoadingMoreGists = false

    private let client: GistHubAPIClient
    private let routerPath: RouterPath
    private var pagingCursor: String?

    public init(
        routerPath: RouterPath,
        client: GistHubAPIClient = DefaultGistHubAPIClient()
    ) {
        self.routerPath = routerPath
        self.client = client
    }

    func fetchGists(listsMode: GistListsMode) async {
        do {
            switch listsMode {
            case .allGists:
                let gistsResponse = try await client.gists(pageSize: Constants.pagingSize, cursor: nil)
                pagingCursor = gistsResponse.cursor
                hasMoreGists = gistsResponse.hasNextPage
                gists = gistsResponse.gists
                contentState = .content
                return
            case .starred:
                gists = try await client.starredGists()
            }
            self.gists = gists
            contentState = .content
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func fetchMoreGists(currentId: String) async {
        guard hasMoreGists, !isLoadingMoreGists, currentId == gists.last?.id ?? "" else {
            return
        }
        do {
            isLoadingMoreGists = true
            let gistsResponse = try await client.gists(pageSize: Constants.pagingSize, cursor: pagingCursor)
            pagingCursor = gistsResponse.cursor
            hasMoreGists = gistsResponse.hasNextPage
            gists.append(contentsOf: gistsResponse.gists)
            isLoadingMoreGists = false
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func insert(_ gist: Gist) {
        gists.insert(gist, at: 0)
    }

    func search(listMode: GistListsMode) {
        if searchText.isEmpty {
            Task {
                await fetchGists(listsMode: listMode)
            }
        } else {
            gists = gists.filter {
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

    func navigateToDetail(gistId: String) {
        routerPath.navigate(to: .gistDetail(gistId: gistId))
    }

    func presentNewGistSheet() {
        routerPath.presentedSheet = .newGist { [weak self] gist in
            self?.insert(gist)
            self?.routerPath.navigate(to: .gistDetail(gistId: gist.id))
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
        static let pagingSize = 6
    }
}
