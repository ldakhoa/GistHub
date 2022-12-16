//
//  CommentViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import SwiftUI

@MainActor final class CommentViewModel: ObservableObject {
    @Published var showLoading = false
    @Published var comments = [Comment]()
    @Published var contentState: ContentState = .loading
    @Published var shouldScrollToComment = false

    private let client: CommentAPIClient

    init(client: CommentAPIClient = DefaultCommentAPIClient()) {
        self.client = client
    }

    func createComment(gistID: String, body: String) async throws {
        do {
            let comment = try await client.createComment(gistID: gistID, body: body)
            self.comments.append(comment)
            self.contentState = .showContent
            shouldScrollToComment = true
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func fetchComments(gistID: String) async {
        do {
            let comments = try await client.comments(gistID: gistID)
            self.comments = comments
            contentState = .showContent
            shouldScrollToComment = true
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    func deleteComments(gistID: String, commentID: Int) async {
        do {
            try await client.deleteComment(gistID: gistID, commentID: commentID)
            self.comments.removeAll { $0.id == commentID }
            contentState = .showContent
            shouldScrollToComment = false
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    enum ContentState {
        case loading
        case showContent
        case error(error: String)
    }
}
