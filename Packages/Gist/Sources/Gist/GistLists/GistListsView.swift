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
    @EnvironmentObject private var routerPath: RouterPath

    // MARK: - Dependencies

    private let listsMode: GistListsMode
    @StateObject private var viewModel: GistListsViewModel = GistListsViewModel()
    @State private var progressViewId = 0

    // MARK: - Initializer

    public init(listsMode: GistListsMode) {
        self.listsMode = listsMode
    }

    // MARK: - View

    public var body: some View {
        ZStack {
            List {
                switch viewModel.contentState {
                case .loading:
                    ForEach(Gist.placeholders) { gist in
                        GistListsRowView(gist: gist)
                            .redacted(reason: .placeholder)
                    }
                case .content:
                    ForEach(viewModel.gists) { gist in
                        HStack {
                            GistListsRowView(gist: gist)
                                .onAppear {
                                    Task {
                                        await viewModel.fetchMoreGistsIfNeeded(lastGistId: gist.id, listsMode: listsMode)
                                    }
                                }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            routerPath.navigate(to: .gistDetail(gistId: gist.id))
                        }
                        .contextMenu {
                            contextMenu(gist: gist)
                        } preview: {
                            contextMenuPreview(gist: gist)
                        }
                    }

                    if viewModel.isLoadingMoreGists {
                        HStack(alignment: .center) {
                            Spacer()
                            ProgressView()
                                .id(progressViewId)
                                .onAppear {
                                    progressViewId += 1
                                }
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                case .error:
                    ErrorView(
                        title: "Cannot Connect",
                        message: "Something went wrong. Please try again."
                    ) {
                        fetchGists()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .animation(.linear, value: viewModel.gists)

            if listsMode == .currentUserGists {
                newGistFloatingButton
            }
        }
        .listRowBackground(Colors.listBackground.color)
        .listStyle(.plain)
        .animation(.default, value: viewModel.searchText)
        .navigationTitle(Text(listsMode.navigationTitle))
        .onLoad { fetchGists() }
        .refreshable { fetchGists() }
        .searchable(text: $viewModel.searchText, prompt: listsMode.promptSearchText)
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: viewModel.searchText) { _ in
            viewModel.search(listMode: listsMode)
        }
        .enableInjection()
    }

    @ViewBuilder
    private var newGistFloatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                GistHubButton(
                    imageName: "plus",
                    foregroundColor: Color.white,
                    background: Colors.accent.color,
                    padding: 16.0,
                    radius: 32.0
                ) {
                    routerPath.presentedSheet = .newGist { gist in
                        viewModel.insert(gist)
                        routerPath.navigate(to: .gistDetail(gistId: gist.id))
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }

    // MARK: - Context Menu

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
            GistDetailView(gistId: gist.id)
                .environmentObject(currentAccount)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(UIColor.secondarySystemGroupedBackground.color, for: .navigationBar)
                .navigationTitle("\(gist.owner?.login ?? "") / \(gist.files?.fileName ?? "")")
        }
    }

    // MARK: - Side Effects

    private func fetchGists() {
        Task {
            await viewModel.fetchGists(listsMode: listsMode)
        }
    }
}
