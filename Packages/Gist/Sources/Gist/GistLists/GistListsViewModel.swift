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
    private var pagingCursor: String?

    public init(
        client: GistHubAPIClient = DefaultGistHubAPIClient()
    ) {
        self.client = client
    }

    func fetchGists(listsMode: GistListsMode) async {
        do {
            switch listsMode {
            case .currentUserGists:
                let gistsResponse = try await client.gists(pageSize: Constants.pagingSize, cursor: nil)
                pagingCursor = gistsResponse.cursor
                hasMoreGists = gistsResponse.hasNextPage
                gists = gistsResponse.gists
            case .currentUserStarredGists:
                gists = try await client.starredGists()
            case let .userGists(userName):
                gists = try await client.gists(fromUserName: userName)
            }
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
