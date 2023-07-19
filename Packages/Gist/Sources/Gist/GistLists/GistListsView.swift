//
//  HomePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject
import Models
import Environment
import DesignSystem
import Utilities

public struct GistListsView: View {
    @ObserveInjection private var inject
    @EnvironmentObject private var currentAccount: CurrentAccount
    @StateObject private var routerPath = RouterPath()
    @StateObject private var viewModel: GistListsViewModel
    @State private var showingNewGistView = false
    @State private var showingGistDetail = false
    @State private var selectedGist: Gist?

    // MARK: - Dependencies

    private let listsMode: GistListsMode
    private let user: User

    // MARK: - Initializer

    // StateObject accepts an @autoclosure which only allocates the view model once when the view gets on screen.
    public init(
        listsMode: GistListsMode,
        user: User,
        viewModel: @escaping () -> GistListsViewModel
    ) {
        self.listsMode = listsMode
        self.user = user
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    public var body: some View {
        ZStack {
            List {
                switch viewModel.contentState {
                case .loading:
                    ForEach(Gist.placeholders) { gist in
                        GistListDetailView(gist: gist)
                            .redacted(reason: .placeholder)
                    }
                case let .content(gists):
                    ForEach(gists) { gist in
                        HStack {
                            GistListDetailView(gist: gist)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.navigateToDetail(gistId: gist.id)
                        }
                        .contextMenu {
                            contextMenu(gist: gist)
                        } preview: {
                            contextMenuPreview(gist: gist)
                        }
                    }
                    // TODO: Research and apply new NavigationStack
                    if let selectedGist = selectedGist {
                        NavigationLink(
                            destination: GistDetailView(
                                gistId: selectedGist.id,
                                shouldReloadGistListsView: { fetchGists() })
                            .environmentObject(UserStore(user: user)),
                            isActive: $showingGistDetail
                        ) {
                            EmptyView()
                        }
                    }
                case let .error(error):
                    Text(error)
                        .foregroundColor(Colors.danger.color)
                }
            }
        }
        .listRowBackground(Colors.danger.color)
        .listStyle(.plain)
        .animation(.default, value: viewModel.searchText)
        .navigationTitle(Text(listsMode.navigationTitle))
        .toolbar {
            if listsMode == .allGists {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewGistView.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .renderingMode(.template)
                            .foregroundColor(Colors.accent.color)
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
        .sheet(isPresented: $showingNewGistView) {
            ComposeGistView(style: .createGist) { newGist in
                viewModel.insert(newGist)
                selectedGist = newGist
                showingGistDetail.toggle()
            }
        }
        .enableInjection()
    }

    @ViewBuilder
    private func contextMenu(gist: Gist) -> some View {
        let titlePreview = "\(gist.owner?.login ?? "")/\(gist.files?.fileName ?? "")"
        ShareLink(
            item: gist.htmlURL ?? "",
            preview: SharePreview(titlePreview, image: Image(systemName: "home"))
        ) {
            Label("Share via...", systemImage: "square.and.arrow.up")
        }
    }

    @ViewBuilder
    private func contextMenuPreview(gist: Gist) -> some View {
        // Put in NavigationStack to solve size issues
        NavigationStack {
            GistDetailView(gistId: gist.id) {}
                .environmentObject(currentAccount)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(UIColor.secondarySystemGroupedBackground.color, for: .navigationBar)
                .navigationTitle("\(gist.owner?.login ?? "") / \(gist.files?.fileName ?? "")")
        }
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
               let fileName: String = files.fileName,
               let createdAt = gist.createdAt,
               let updatedAt = gist.updatedAt {
                HStack(alignment: .center, spacing: 6) {
                    if
                        let avatarURLString = gist.owner?.avatarURL,
                        let url = URL(string: avatarURLString)
                    {
                        GistHubImage(url: url)
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
