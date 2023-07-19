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
    private let client: GistHubAPIClient
    private let routerPath: RouterPath

    public init(
        routerPath: RouterPath,
        client: GistHubAPIClient = DefaultGistHubAPIClient()
    ) {
        self.routerPath = routerPath
        self.client = client
    }

    func fetchGists(listsMode: GistListsMode) async {
        do {
            let gists: [Gist]
            switch listsMode {
            case .allGists:
                gists = try await client.gists()
            case .starred:
                gists = try await client.starredGists()
            }
            self.gists = gists
            contentState = .content(gists: gists)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func insert(_ gist: Gist) {
        gists.insert(gist, at: 0)
        contentState = .content(gists: gists)
    }

    func search() {
        if searchText.isEmpty {
            contentState = .content(gists: self.gists)
        } else {
            let newGists = gists.filter {
                if let fileNames = $0.files?.map({ String($0.key) }), let loginName = $0.owner?.login {
                let fileNameCondition = fileNames.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
                    let loginNameCondition = loginName.localizedCaseInsensitiveContains(searchText)
                    let descriptionCondition = ($0.description ?? "").localizedCaseInsensitiveContains(searchText)
                    return !fileNameCondition.isEmpty || loginNameCondition || descriptionCondition
                }
                return false
            }
            contentState = .content(gists: newGists)
        }
    }

    func navigateToDetail(gistId: String) {
        routerPath.navigate(to: .gistDetail(gistId: gistId))
    }
}

extension GistListsViewModel {
    enum ContentState {
        case loading
        case content(gists: [Gist])
        case error(error: String)
    }
}
