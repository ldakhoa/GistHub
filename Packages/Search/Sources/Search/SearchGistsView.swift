import SwiftUI
import Models
import Environment
import DesignSystem
import Utilities
import Gist

public struct SearchGistListsView: View {
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var routerPath: RouterPath
    @StateObject private var viewModel: SearchGistListsViewModel = SearchGistListsViewModel()
    @State private var progressViewId = 0
    @State private var selectedSortOption: GistSearchResultSortOption = .bestMatch

    private let gistsSortOptions: [GistSearchResultSortOption] = GistSearchResultSortOption.allCases
    private let query: String

    // MARK: - Initializer

    public init(query: String) {
        self.query = query
    }

    // MARK: - View

    public var body: some View {
        List {
            switch viewModel.contentState {
            case .loading:
                ForEach(Gist.placeholders) { gist in
                    GistListsRowView(gist: gist, shouldGetFilesCountFromGist: true)
                        .redacted(reason: .placeholder)
                }
            case .content:
                ForEach(viewModel.gists) { gist in
                    HStack {
                        GistListsRowView(gist: gist, shouldGetFilesCountFromGist: true)
                            .onAppear {
                                Task {
                                    await viewModel.fetchMoreGistsIfNeeded(
                                        query: query,
                                        currentGistID: gist.id
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
        .overlay(Group {
            if viewModel.gists.isEmpty && viewModel.contentState != .loading {
                EmptyStatefulView(title: "There aren't any gists.")
            }
        })
        .animation(.linear, value: viewModel.gists)
        .listRowBackground(Colors.listBackground.color)
        .listStyle(.plain)
        .onLoad { fetchGists() }
        .refreshable { refreshGists() }
        .onChange(of: selectedSortOption) { newValue in
            self.viewModel.sortOption = newValue
            refreshGists()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                trailingToolbarItem
            }
        }
        .navigationTitle("Gists")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var trailingToolbarItem: some View {
        Menu {
            sortOrderMenu
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(Colors.accent.color)
        }
    }

    @ViewBuilder
    private var sortOrderMenu: some View {
        Menu {
            ForEach(gistsSortOptions, id: \.self) { sortOption in
                Button {
                    selectedSortOption = sortOption
                } label: {
                    HStack {
                        if sortOption == selectedSortOption {
                            Image(systemName: "checkmark")
                        }
                        Text(sortOption.title)
                    }
                }
            }
        } label: {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                Text("Sort by")
            }
            Text(selectedSortOption.title)
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
            await viewModel.fetchGists(from: query)
        }
    }

    private func refreshGists() {
        Task {
            await viewModel.refreshGists(from: query)
        }
    }
}
