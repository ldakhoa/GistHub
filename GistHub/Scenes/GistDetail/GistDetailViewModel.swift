//
//  GistDetailViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import Combine

@MainActor final class GistDetailViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading
    @Published var starButtonState: StarButtonState = .idling
    @Published var commentContentState: CommentContentState = .loading

    private let gistHubClient: GistHubAPIClient
    private let commentClient: CommentAPIClient

    init(
        gistHubClient: GistHubAPIClient = DefaultGistHubAPIClient(),
        commentClient: CommentAPIClient = DefaultCommentAPIClient()
    ) {
        self.gistHubClient = gistHubClient
        self.commentClient = commentClient
    }

    func starGist(gistID: String) async {
        do {
            try await gistHubClient.starGist(gistID: gistID)
            await isStarred(gistID: gistID)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func unstarGist(gistID: String) async {
        do {
            try await gistHubClient.unstarGist(gistID: gistID)
            await isStarred(gistID: gistID)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func isStarred(gistID: String) async {
        do {
            try await gistHubClient.isStarred(gistID: gistID)
            starButtonState = .starred
        } catch {
            starButtonState = .unstarred
        }
    }

    func gist(gistID: String) async {
        do {
            async let gist = gistHubClient.gist(fromGistID: gistID)
            contentState = try await .content(gist: gist)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func comments(gistID: String) async {
        do {
            async let comments = commentClient.comments(gistID: gistID)
            commentContentState = try await .content(comments: comments)
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
        case idling
        case starred
        case unstarred
    }

    enum CommentContentState {
        case loading
        case content(comments: [Comment])
        case error(error: String)
    }
}
