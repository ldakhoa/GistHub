//
//  GistDetailViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import Combine
import Networking
import Models

@MainActor final class GistDetailViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading
    @Published var starButtonState: StarButtonState = .loading
    @Published var gist: Gist!
    @Published var isFetchingGist: Bool = true

    private let gistHubClient: GistHubAPIClient
    private let commentClient: CommentAPIClient

    init(
        gistHubClient: GistHubAPIClient = DefaultGistHubAPIClient(),
        commentClient: CommentAPIClient = DefaultCommentAPIClient()
    ) {
        self.gistHubClient = gistHubClient
        self.commentClient = commentClient
    }

    func starGist() async {
        do {
            let starred = try await gistHubClient.starGist(gistID: gist.nodeID!)
            starButtonState = starred ? .starred : .unstarred
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func unstarGist() async {
        do {
            let starred = try await gistHubClient.unstarGist(gistID: gist.nodeID!)
            starButtonState = starred ? .starred : .unstarred
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func isStarred(gistID: String) async {
        do {
            let starred = try await gistHubClient.isStarred(gistID: gistID)
            starButtonState = starred ? .starred : .unstarred
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func gist(gistID: String) async {
        contentState = .loading
        do {
            async let gist = gistHubClient.gist(fromGistID: gistID)
            self.gist = try await gist
            contentState = try await .content(gist: gist)
            isFetchingGist = false
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func deleteGist(gistID: String) async {
        do {
            try await gistHubClient.deleteGist(fromGistID: gistID)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }
}

// MARK: - ContentState

extension GistDetailViewModel {
    enum ContentState {
        case loading
        case content(gist: Gist)
        case error(error: String)
    }

    enum StarButtonState {
        case loading
        case starred
        case unstarred
    }
}
