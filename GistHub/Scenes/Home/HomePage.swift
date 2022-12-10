//
//  HomePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject

struct HomePage: View {
    @ObserveInjection private var inject
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            switch viewModel.contentState {
            case .loading:
                ProgressView()
            case let .content(gists):
                List {
                    Section {
                        ForEach(gists) { gist in
                            PlainNavigationLink {
                                GistDetailPage()
                            } label: {
                                buildGistDetailView(gist: gist)
                            }
                        }

                    } header: {
                        Text("Today")
                    }
                    .headerProminence(.increased)

                }
            case let .error(error):
                Text(error)
                    .foregroundColor(Colors.danger.color)
            }
        }
        .navigationTitle(Text("All Gists"))
        .onLoad { fetchGists() }
        .refreshable { fetchGists() }
        .enableInjection()
    }

    private func buildGistDetailView(gist: Gist) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if let files = gist.files,
                let fileName: String = files.keys.first {
                HStack {
                    Group {
                        Text(gist.owner?.login ?? "") + Text(" / ") + Text(fileName).bold()
                    }
                    .lineLimit(2)

                    Spacer()

                    Text(gist.createdAt?.agoString(style: .short) ?? "")
                        .font(.subheadline)
                        .foregroundColor(Colors.neutralEmphasis.color)
                }

                if let description = gist.description, !description.isEmpty {
                    Text(description)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .font(.subheadline)
                }

                HStack(alignment: .center) {
                    footerItem(title: "\(files.keys.count) files", imageName: "file-code")
                    let commentTitle = gist.comments ?? 0 > 1 ? "comments" : "comment"
                    footerItem(title: "\(gist.comments ?? 0) \(commentTitle)", imageName: "comment")
                }
            }
        }
    }

    private func footerItem(title: String, imageName: String) -> some View {
        HStack(alignment: .center, spacing: 2) {
            Image(imageName)
                .resizable()
                .frame(width: 16, height: 16)
            Text(title)
                .font(.footnote)
        }
    }

    private func fetchGists() {
        Task {
            await viewModel.fetchGists()
        }
    }
}
