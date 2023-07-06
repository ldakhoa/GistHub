//
//  CommentViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import SwiftUI
import Models
import Networking

@MainActor
public final class CommentViewModel: ObservableObject {
    @Published var showLoading = false
    @Published var comments = [Comment]()
    @Published var contentState: ContentState = .loading
    @Published var shouldScrollToComment = false
    @Published var errorToastTitle = ""
    @Published var showErrorToast = false

    private let client: CommentAPIClient

    init(client: CommentAPIClient = DefaultCommentAPIClient()) {
        self.client = client
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

    func createComment(gistID: String, body: String, completion: () -> Void) async {
        do {
            let comment = try await client.createComment(gistID: gistID, body: body)
            self.comments.append(comment)
            self.contentState = .showContent
            shouldScrollToComment = true
            completion()
        } catch {
            showErrorToast = true
            errorToastTitle = error.localizedDescription
        }
    }

    func updateComment(
        gistID: String,
        commentID: Int,
        body: String,
        completion: () -> Void
    ) async {
        do {
            let comment = try await client.updateComment(gistID: gistID, commentID: commentID, body: body)
            if let index = comments.firstIndex(where: { $0.id == commentID }) {
                comments[index] = comment
            }
            self.contentState = .showContent
            shouldScrollToComment = false
            completion()
        } catch {
            showErrorToast = true
            errorToastTitle = error.localizedDescription
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
