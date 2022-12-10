//
//  GistDetailViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import Combine

@MainActor final class GistDetailViewModel: ObservableObject {
    @Published var contentState: ContentState = .idling
    @Published var starButtonState: StarButtonState = .idling

    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    func starGist(gistID: String) async {
        do {
            try await client.starGist(gistID: gistID)
            await isStarred(gistID: gistID)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func unstarGist(gistID: String) async {
        do {
            try await client.unstarGist(gistID: gistID)
            await isStarred(gistID: gistID)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func isStarred(gistID: String) async {
        do {
            try await client.isStarred(gistID: gistID)
            starButtonState = .starred
        } catch {
            starButtonState = .unstarred
        }
    }
}

extension GistDetailViewModel {
    enum ContentState {
        case idling
        case error(error: String)
    }

    enum StarButtonState {
        case idling
        case starred
        case unstarred
    }
}
