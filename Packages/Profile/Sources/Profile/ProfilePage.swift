//
//  ProfilePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject
import DesignSystem
import Models
import AppAccount
import Settings

public struct ProfilePage: View {
    @ObserveInjection private var inject

    let user: User?

    @ObservedObject private var viewModel = ProfileViewModel()
    let sessionManager: GitHubSessionManager

    public init(user: User, delegate: ProfileDelegate, sessionManager: GitHubSessionManager) {
        self.user = user
        self.sessionManager = sessionManager
        viewModel.delegate = delegate
    }

    public var body: some View {
        ZStack {
            if let user = user {
                makeMainView(user: user)
            } else {
                switch viewModel.contentState {
                case .loading:
                    ProgressView()
                case let .content(user):
                    makeMainView(user: user)
                case let .error(error):
                    Text(error)
                        .foregroundColor(Colors.danger.color)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    NavigationLink {
                        SettingView(user: user!, sessionManager: sessionManager) {
                            viewModel.logout()
                        }
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(Colors.accent.color)
                    }

                    let titlePreview = "\(user?.login ?? "") - Overview"
                    ShareLink(
                        item: user?.htmlURL ?? "",
                        preview: SharePreview(titlePreview, image: Image("default"))
                    ) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Colors.accent.color)
                    }
                }
            }
        }
        .toolbarBackground(UIColor.systemGroupedBackground.color, for: .navigationBar)
        .refreshable { fetchUser() }
        .enableInjection()
    }

    private func makeMainView(user: User) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                if let avatarURLString = user.avatarURL, let url = URL(string: avatarURLString) {
                    GistHubImage(url: url, width: 70, height: 70, cornerRadius: 35)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(user.name ?? "")
                        .font(.title2)
                        .bold()
                    Text("@\(user.login!)")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }
            }

            HStack {
                if let company = user.company {
                    imageText(imageName: "organization", title: company)
                }

                if let location = user.location {
                    imageText(imageName: "location", title: location)
                }

                if let email = user.email {
                    imageText(imageName: "at", title: email)
                }
            }

            HStack(spacing: 4) {
                Image("person")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 16, height: 16)
                    .foregroundColor(Colors.neutralEmphasisPlus.color)

                let followerText = user.followers ?? 0 > 1 ? "followers" : "follower"
                Text("\(user.followers ?? 0) ") +
                Text(followerText).foregroundColor(Colors.neutralEmphasisPlus.color)

                Text(" · ")

                let followingText = user.followers ?? 0 > 1 ? "followings" : "following"
                Text("\(user.following ?? 0) ") +
                Text(followingText).foregroundColor(Colors.neutralEmphasisPlus.color)
            }

            if let htmlURL = user.htmlURL,
               let url = URL(string: htmlURL) {
                Link(destination: url) {
                    HStack {
                        Spacer()
                        Text("View GitHub Profile")
                            .font(.callout)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(12)
                    .background(Colors.buttonBackground.color)
                    .foregroundColor(Colors.buttonForeground.color)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Colors.buttonBorder.color)
                    )
                }
                .padding(.top, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(24)
    }

    private func imageText(imageName: String, title: String) -> some View {
        HStack(spacing: 4) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Colors.neutralEmphasisPlus.color)
                .frame(width: 16, height: 16)
            Text(title)
                .font(.subheadline)
                .foregroundColor(Colors.neutralEmphasisPlus.color)
        }
    }

    private func fetchUser() {
        Task {
            await viewModel.fetchUser()
        }
    }
}
