//
//  CommentView.swift
//  GistHub
//
//  Created by Khoa Le on 12/12/2022.
//

import SwiftUI
import Kingfisher
import Inject

struct CommentView: View {
    private let comment: Comment
    private let gistID: String
    @ObservedObject private var viewModel: CommentViewModel
    @EnvironmentObject var userStore: UserStore

    @State private var showContentActionConfirmedDialog = false
    @State private var showDeleteConfirmedDialog = false
    @State private var showPlainTextEditorView = false
    @State private var showQuoteCommentTextEditor = false
    @ObserveInjection private var inject
    @State private var commentMarkdownHeight: CGFloat = 0

    init(comment: Comment, gistID: String, viewModel: CommentViewModel) {
        self.comment = comment
        self.gistID = gistID
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                if
                    let avatarURLString = comment.user.avatarURL,
                    let url = URL(string: avatarURLString)
                {
                    KFImage
                        .url(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(24)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(comment.user.login ?? "")
                            .bold()
                        if let createdAt = comment.createdAt {
                            Text("· \(createdAt.agoString(style: .short).replacingOccurrences(of: ". ago", with: ""))")
                                .foregroundColor(Colors.neutralEmphasisPlus.color)
                        }

                        if comment.createdAt != comment.updatedAt {
                            Text("· edited")
                                .foregroundColor(Colors.neutralEmphasisPlus.color)
                        }

                        Spacer()

                        Button {
                            showContentActionConfirmedDialog.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Colors.neutralEmphasisPlus.color)
                                .frame(width: 30, height: 40)
                                .contentShape(Rectangle())
                        }
                    }

                    if let authorAssociation = comment.authorAssociation, authorAssociation == "OWNER" {
                        Text("Author")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Colors.badgeBackground.color)
                            .foregroundColor(Colors.badgeForeground.color)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Colors.badgeBorder.color)
                            )
                            .cornerRadius(16)
                    }
                }
            }
            Spacer(minLength: 12)

            MarkdownUI(
                markdown: comment.body ?? "",
                markdownHeight: $commentMarkdownHeight,
                mode: .comment)
            .frame(height: commentMarkdownHeight)
            .padding(.horizontal, -16)
        }
        .confirmationDialog("", isPresented: $showContentActionConfirmedDialog) {
            if comment.user.id == userStore.user.id {
                Button("Delete", role: .destructive) {
                    showDeleteConfirmedDialog.toggle()
                }
            }

            if comment.user.id == userStore.user.id {
                Button("Edit") {
                    showPlainTextEditorView.toggle()
                }
            }

            Button("Quote reply") {
                showQuoteCommentTextEditor.toggle()
            }
        }
        .confirmationDialog(
            "Are you sure you want to delete this?",
            isPresented: $showDeleteConfirmedDialog,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteComments(gistID: gistID, commentID: comment.id ?? 0)
                }
            }
        }
        .sheet(isPresented: $showPlainTextEditorView) {
            PlainTextEditorView(
                style: .updateComment,
                content: comment.body ?? "",
                gistID: gistID,
                commentID: comment.id,
                navigationTitle: "Edit Comment",
                placeholder: "Write a comment...",
                commentViewModel: viewModel)
        }
        .sheet(isPresented: $showQuoteCommentTextEditor) {
            PlainTextEditorView(
                style: .comment,
                content: quoteBody(body: comment.body ?? ""),
                gistID: gistID,
                navigationTitle: "Write Comment",
                placeholder: "Write a comment...",
                commentViewModel: viewModel)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .enableInjection()
    }

    private func quoteBody(body: String) -> String {
        let result = "> "
        let newBody = body.replacingOccurrences(of: "\n", with: "\n> ")
        let newLine = "\n\n"
        return result + newBody + newLine
    }
}
