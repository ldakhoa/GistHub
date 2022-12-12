//
//  CommentView.swift
//  GistHub
//
//  Created by Khoa Le on 12/12/2022.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    let comment: Comment

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
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
