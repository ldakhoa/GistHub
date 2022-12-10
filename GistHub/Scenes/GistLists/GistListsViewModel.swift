//
//  HomeViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI

@MainActor final class GistListsViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading

    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
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
            contentState = .content(gists: gists)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }
}

extension GistListsViewModel {
    enum ContentState {
        case loading
        case content(gists: [Gist])
        case error(error: String)
    }
}
