//
//  HomePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Models
import Environment
import DesignSystem
import Utilities

public struct GistListsView: View {
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var routerPath: RouterPath

    // MARK: - Dependencies

    @State private var listsMode: GistListsMode
    @StateObject private var viewModel: GistListsViewModel = GistListsViewModel()
    @State private var progressViewId = 0

    // MARK: - Initializer

    public init(listsMode: GistListsMode) {
        _listsMode = State(initialValue: listsMode)
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
                                        await viewModel.fetchMoreGistsIfNeeded(
                                            currentGistID: gist.id,
                                            mode: listsMode
                                        )
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
        .onLoad { fetchGists() }
        .refreshable { refreshGists() }
        .scrollDismissesKeyboard(.interactively)
        .modifyIf(listsMode.shouldShowMenuView) { view in
            view
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        menuView
                    }
                }
        }
        .modifyIf(listsMode.shouldShowSearch) { view in
            view
                .searchable(text: $viewModel.searchText, prompt: listsMode.promptSearchText)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.search()
                }
        }
        .navigationTitle(Text(listsMode.navigationTitle))
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

    @ViewBuilder
    private var menuView: some View {
        Menu {
            makeMenuButton(title: "All gists", image: "code24") {
                self.listsMode = .discover(mode: .all)
                refreshGists()
            }

            makeMenuButton(title: "Starred", image: "star") {
                self.listsMode = .discover(mode: .starred)
                refreshGists()
            }

            makeMenuButton(title: "Forked", image: "fork") {
                self.listsMode = .discover(mode: .forked)
                refreshGists()
            }

        } label: {
            Image(systemName: "chevron.down.circle")
                .fontWeight(.semibold)
                .foregroundColor(Colors.accent.color)
        }
    }

    private func makeMenuButton(
        title: String,
        image: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(role: role ?? .none, action: action) {
            Label(title, image: image)
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
                .environmentObject(routerPath)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(UIColor.secondarySystemGroupedBackground.color, for: .navigationBar)
                .navigationTitle("\(gist.owner?.login ?? "") / \(gist.files?.fileName ?? "")")
        }
    }

    // MARK: - Side Effects

    private func fetchGists() {
        Task {
            await viewModel.fetchGists(mode: self.listsMode)
        }
    }

    private func refreshGists() {
        Task {
            await viewModel.refreshGists(mode: self.listsMode)
        }
    }
}
