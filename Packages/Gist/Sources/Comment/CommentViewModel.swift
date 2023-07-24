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
    @Published public var showLoading = false
    @Published public var comments = [Comment]()
    @Published public var contentState: ContentState = .loading
    @Published public var shouldScrollToComment = false
    @Published public var errorToastTitle = ""
    @Published public var showErrorToast = false

    private let client: CommentAPIClient

    public init(client: CommentAPIClient = DefaultCommentAPIClient()) {
        self.client = client
    }

    public func fetchComments(gistID: String) async {
        do {
            let comments = try await client.comments(gistID: gistID)
            self.comments = comments
            contentState = .showContent
            shouldScrollToComment = true
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    public func createComment(gistID: String, body: String) async {
        do {
            let comment = try await client.createComment(gistID: gistID, body: body)
            self.comments.append(comment)
            self.contentState = .showContent
            shouldScrollToComment = true
        } catch {
            showErrorToast = true
            errorToastTitle = error.localizedDescription
        }
    }

    public func updateComment(
        gistID: String,
        commentID: Int,
        body: String
    ) async {
        do {
            let comment = try await client.updateComment(gistID: gistID, commentID: commentID, body: body)
            if let index = comments.firstIndex(where: { $0.id == commentID }) {
                comments[index] = comment
            }
            self.contentState = .showContent
            shouldScrollToComment = false
        } catch {
            showErrorToast = true
            errorToastTitle = error.localizedDescription
        }
    }

    public func deleteComments(gistID: String, commentID: Int) async {
        do {
            try await client.deleteComment(gistID: gistID, commentID: commentID)
            self.comments.removeAll { $0.id == commentID }
            contentState = .showContent
            shouldScrollToComment = false
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }

    public enum ContentState {
        case loading
        case showContent
        case error(error: String)
    }
}
