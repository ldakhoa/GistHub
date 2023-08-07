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
    @Published public var comments = [Comment]()
    @Published public var contentState: ContentState = .loading
    @Published public var shouldScrollToComment = false
    @Published public var errorToastTitle = ""
    @Published public var showErrorToast = false
    @Published public var isLoadingMoreComments = false

    private var currentCommentsPage: Int = 1
    private var hasMoreComments: Bool = false
    private let client: CommentAPIClient

    public init(client: CommentAPIClient = DefaultCommentAPIClient()) {
        self.client = client
    }

    // MARK: - Side Effects - Public

    public func fetchMoreCommentsIfNeeded(currentCommentID: String?, gistID: String) async {
        guard
            hasMoreComments,
            let lastCommentID = comments.last?.nodeID,
            currentCommentID == lastCommentID
        else {
            return
        }

        await fetchComments(gistID: gistID)
    }

    public func fetchComments(
        gistID: String,
        refresh: Bool = false
    ) async {
        do {
            isLoadingMoreComments = true
            let newComments: [Comment] = try await fetchComments(from: gistID)

            if refresh {
                comments = newComments
            } else {
                comments.append(contentsOf: newComments)
            }

            isLoadingMoreComments = false
            contentState = .showContent
            shouldScrollToComment = false
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

    public func refreshComments(from gistID: String) async {
        currentCommentsPage = 1
        await fetchComments(gistID: gistID, refresh: true)
    }

    // MARK: - Side Effects - Private

    private func fetchComments(from gistID: String) async throws -> [Comment] {
        let comments = try await client.comments(
            gistID: gistID,
            page: currentCommentsPage,
            perPage: Constants.pagingSize
        )
        currentCommentsPage += 1
        hasMoreComments = !comments.isEmpty
        return comments
    }
}

extension CommentViewModel {
    public enum ContentState {
        case loading
        case showContent
        case error(error: String)
    }

    public enum Constants {
        static let pagingSize = 20
    }
}
