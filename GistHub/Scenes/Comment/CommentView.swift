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

    @State private var showContentActionConfirmedDialog = false
    @State private var showDeleteConfirmedDialog = false
    @ObserveInjection private var inject

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
                            Text("· \(createdAt.agoString())")
                                .foregroundColor(Colors.neutralEmphasisPlus.color)
                        }

                        Spacer()

                        Button {
                            showContentActionConfirmedDialog.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Colors.neutralEmphasisPlus.color)
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
            Text(.init(comment.body ?? ""))
                .font(.callout)
        }
        .confirmationDialog("", isPresented: $showContentActionConfirmedDialog) {
            Button("Delete", role: .destructive) {
                showDeleteConfirmedDialog.toggle()
            }

            Button("Edit") {}

            Button("Quote reply") {}
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
        .enableInjection()
    }
}
