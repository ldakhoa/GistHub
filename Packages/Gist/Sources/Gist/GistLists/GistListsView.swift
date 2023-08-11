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
    @StateObject private var viewModel: GistListsViewModel = GistListsViewModel()
    @State private var progressViewId = 0
    @State private var selectedDiscoverGists: DiscoverGistsMode = .all

    // MARK: - Dependencies

    @State private var listsMode: GistListsMode

    // MARK: - Initializer

    public init(listsMode: GistListsMode) {
        _listsMode = State(initialValue: listsMode)
    }

    // MARK: - View

    public var body: some View {
        List {
            Section {
                switch viewModel.contentState {
                case .loading:
                    ForEach(Gist.placeholders) { gist in
                        GistListsRowView(gist: gist, gistListsMode: listsMode)
                            .redacted(reason: .placeholder)
                    }
                case .content:
                    ForEach(viewModel.gists) { gist in
                        HStack {
                            GistListsRowView(gist: gist, gistListsMode: listsMode)
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
            } header: {
                if listsMode.shouldShowMenuView {
                    Picker("", selection: $selectedDiscoverGists) {
                        ForEach(DiscoverGistsMode.allCases) { discoverGist in
                            Text(discoverGist.title)
                                .tag(discoverGist)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .animation(.linear, value: viewModel.gists)
        .listRowBackground(Colors.listBackground.color)
        .listStyle(.plain)
        .animation(.default, value: viewModel.searchText)
        .onLoad { fetchGists() }
        .refreshable { refreshGists() }
        .scrollDismissesKeyboard(.interactively)
        .modifyIf(listsMode.shouldShowMenuView) { view in
            view
                .onChange(of: selectedDiscoverGists) { newValue in
                    self.listsMode = .discover(mode: newValue)
                    refreshGists()
                }
        }
        .modifyIf(listsMode.shouldShowSearch) { view in
            view
                .searchable(text: $viewModel.searchText, prompt: listsMode.promptSearchText)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.search()
                }
        }
        .overlay(Group {
            if viewModel.gists.isEmpty && viewModel.contentState != .loading {
                EmptyStatefulView(title: "There aren't any gists.")
            }
        })
        .navigationTitle(Text(listsMode.navigationTitle))
        .navigationBarTitleDisplayMode(listsMode.navigationStyle)
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
