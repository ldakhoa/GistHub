//
//  HomePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject
import Kingfisher

struct GistListsView: View {
    @ObserveInjection private var inject
    @StateObject private var viewModel = GistListsViewModel()
    @State private var showingNewGistView = false

    let listsMode: GistListsMode

    var body: some View {
        ZStack {
            switch viewModel.contentState {
            case .loading:
                ProgressView()
            case let .content(gists):
                List {
                    ForEach(gists) { gist in
                        PlainNavigationLink {
                            GistDetailView(gist: gist)
                        } label: {
                            GistListDetailView(gist: gist)
                        }
                    }
                    .listRowBackground(Colors.listBackground.color)
                }
                .listStyle(.plain)
            case let .error(error):
                Text(error)
                    .foregroundColor(Colors.danger.color)
            }
        }
        .navigationTitle(Text(listsMode.navigationTitle))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingNewGistView.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                        .renderingMode(.template)
                        .foregroundColor(Colors.accent.color)
                }
                .sheet(isPresented: $showingNewGistView) {
                    NavigationView {
                        NewGistView()
                    }
                }
            }
        }
        .onLoad { fetchGists() }
        .refreshable { fetchGists() }
        .searchable(text: $viewModel.searchText, prompt: listsMode.promptSearchText)
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: viewModel.searchText) { _ in
            viewModel.search()
        }
        .enableInjection()
    }

    private func fetchGists() {
        Task {
            await viewModel.fetchGists(listsMode: listsMode)
        }
    }
}

private struct GistListDetailView: View {
    let gist: Gist

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let files = gist.files,
               let fileName: String = files.keys.first,
               let createdAt = gist.createdAt,
               let updatedAt = gist.updatedAt {
                HStack(alignment: .center, spacing: 6) {
                    if
                        let avatarURLString = gist.owner?.avatarURL,
                        let url = URL(string: avatarURLString)
                    {
                        KFImage
                            .url(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .cornerRadius(12)
                    }
                    Text(gist.owner?.login ?? "")
                        .font(.subheadline)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }

                HStack(alignment: .center, spacing: 2) {
                    Text(fileName)
                        .bold()

                    if !(gist.public ?? true) {
                        Image(systemName: "lock")
                            .font(.subheadline)
                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                            .padding(.leading, 2)
                    }
                }

                if let description = gist.description, !description.isEmpty {
                    Text(description)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .font(.subheadline)
                        .lineLimit(2)
                }

                if createdAt == updatedAt {
                    Text("Created \(createdAt.agoString())")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .font(.caption)
                } else {
                    Text("Last active \(createdAt.agoString())")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .font(.caption)
                }

                HStack(alignment: .center) {
                    let fileTitle = files.keys.count > 1 ? "files" : "file"
                    footerItem(title: "\(files.keys.count) \(fileTitle)", imageName: "file-code")
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
                .renderingMode(.template)
                .frame(width: 16, height: 16)
            Text(title)
                .font(.footnote)
        }
        .foregroundColor(Colors.neutralEmphasisPlus.color)
        .padding(.top, 2)
    }
}
