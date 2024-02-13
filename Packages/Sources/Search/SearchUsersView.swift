import SwiftUI
import DesignSystem
import Environment
import Models
import Networking
import Profile
import SharedViews

public struct SearchUsersView: View {
    @EnvironmentObject private var routerPath: RouterPath
    @StateObject private var viewModel: SearchUsersViewModel

    public init(query: String) {
        _viewModel = StateObject(wrappedValue: SearchUsersViewModel(query: query))
    }

    public var body: some View {
        UserListView(viewModel: viewModel)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Users")
    }
}

final class SearchUsersViewModel: UserListViewModeling {
    @Published var contentState: SharedViews.UserListContentState = .loading
    @Published var isLoadingMoreUsers: Bool = false
    @Published var users: [Models.User] = []

    private let client: GistHubAPIClient
    private let query: String
    private var pagingCursor: String?
    private var hasMoreUsers: Bool = false

    public init(
        query: String,
        client: GistHubAPIClient = DefaultGistHubAPIClient()
    ) {
        self.query = query
        self.client = client
    }

    @MainActor
    func fetchUsers(refresh: Bool = false) async {
        do {
            isLoadingMoreUsers = true
            let usersResponse = try await client.searchUsers(
                from: query,
                pageSize: 20,
                cursor: pagingCursor
            )
            pagingCursor = usersResponse.cursor
            hasMoreUsers = usersResponse.hasNextPage

            if refresh {
                users = usersResponse.users
            } else {
                users.append(contentsOf: usersResponse.users)
            }

            isLoadingMoreUsers = false
            contentState = .content
        } catch {
            contentState = .error
        }
    }

    @MainActor
    func refresh() async {
        contentState = .loading
        hasMoreUsers = false
        pagingCursor = nil
        await fetchUsers(refresh: true)
    }

    @MainActor
    func fetchMoreUsersIfNeeded(currentUserLogin: String?) async {
        guard
            hasMoreUsers,
            !isLoadingMoreUsers,
            let login = users.last?.login,
            login == currentUserLogin
        else {
            return
        }
        await fetchUsers()
    }
}
