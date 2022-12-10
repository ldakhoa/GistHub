//
//  HomeViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI

@MainActor final class HomeViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading

    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    func fetchGists() async {
        do {
            let gists = try await client.gists()
            contentState = .content(gists: gists)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }
}

extension HomeViewModel {
    enum ContentState {
        case loading
        case content(gists: [Gist])
        case error(error: String)
    }
}
