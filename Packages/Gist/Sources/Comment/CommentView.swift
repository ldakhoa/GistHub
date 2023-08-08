//
//  CommentView.swift
//  GistHub
//
//  Created by Khoa Le on 12/12/2022.
//

import SwiftUI
import Models
import DesignSystem
import Markdown
import Editor
import Environment

public struct CommentView: View {
    private let comment: Comment
    private let gistID: String
    @ObservedObject private var viewModel: CommentViewModel
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var routerPath: RouterPath

    @State private var showContentActionConfirmedDialog = false
    @State private var showDeleteConfirmedDialog = false
    @State private var commentMarkdownHeight: CGFloat = 0

    public init(
        comment: Comment,
        gistID: String,
        viewModel: CommentViewModel
    ) {
        self.comment = comment
        self.gistID = gistID
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                if
                    let avatarURLString = comment.user?.avatarURL,
                    let url = URL(string: avatarURLString)
                {
                    GistHubImage(url: url, width: 44, height: 44, cornerRadius: 24)
                        .onTapGesture {
                            routerPath.navigateToUserProfileView(with: comment.user?.login ?? "ghost")
                        }
                }
                VStack(alignment: .leading, spacing: -6) {
                    HStack {
                        Text(comment.user?.login ?? "ghost")
                            .bold()
                            .onTapGesture {
                                routerPath.navigateToUserProfileView(with: comment.user?.login ?? "ghost")
                            }
                        if let createdAt = comment.createdAt {
                            Menu {
                                Button(role: .none) {} label: {
                                    Text("\(createdAt.formattedDate())")
                                        .font(.subheadline)
                                }
                            } label: {
                                Text("\(createdAt.agoString(style: .short).replacingOccurrences(of: ". ago", with: ""))")
                                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                            }

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
            if comment.user?.login == currentAccount.user?.login {
                Button("Delete", role: .destructive) {
                    showDeleteConfirmedDialog.toggle()
                }
            }

            if comment.user?.login == currentAccount.user?.login {
                Button("Edit") {
                    routerPath.presentedSheet = .markdownTextEditor(
                        style: .updateComment(content: comment.body ?? "")
                    ) { content in
                        Task {
                            guard let commentId = comment.id else { return }
                            await viewModel.updateComment(
                                gistID: gistID,
                                commentID: commentId,
                                body: content
                            )
                        }
                    }
                }
            }

            Button("Quote reply") {
                routerPath.presentedSheet = .markdownTextEditor(
                    style: .writeComment(content: quoteBody(body: comment.body ?? ""))
                ) { content in
                    Task {
                        await viewModel.createComment(
                            gistID: gistID,
                            body: content
                        )
                    }
                }
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
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func quoteBody(body: String) -> String {
        let result = "> "
        let newBody = body.replacingOccurrences(of: "\n", with: "\n> ")
        let newLine = "\n\n"
        return result + newBody + newLine
    }
}
