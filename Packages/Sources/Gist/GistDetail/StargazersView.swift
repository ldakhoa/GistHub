import SwiftUI
import SharedViews
import Models
import Networking

public struct StargazersView: View {
    @StateObject private var viewModel: StargazerViewModel

    public init(gistID: String) {
        _viewModel = StateObject(wrappedValue: StargazerViewModel(gistID: gistID))
    }

    public var body: some View {
        UserListView(viewModel: viewModel)
    }
}

final class StargazerViewModel: UserListViewModeling {
    @Published private(set) var contentState: SharedViews.UserListContentState = .loading
    @Published private(set) var isLoadingMoreUsers: Bool = false
    @Published private(set) var users: [Models.User] = []

    private let client: GistHubAPIClient
    private let gistID: String
    private var pagingCursor: String?
    private var hasMoreUsers: Bool = false

    init(
        gistID: String,
        client: GistHubAPIClient = DefaultGistHubAPIClient()
    ) {
        self.gistID = gistID
        self.client = client
    }

    @MainActor
    func fetchUsers(refresh: Bool = false) async {
        do {
            isLoadingMoreUsers = true

            let stargazersResponse = try await client.stargazersFromGistDetail(
                gistID: gistID,
                pageSize: 20,
                cursor: pagingCursor
            )

            pagingCursor = stargazersResponse.cursor
            hasMoreUsers = stargazersResponse.hasNextPage

            if refresh {
                users = stargazersResponse.users
            } else {
                users.append(contentsOf: stargazersResponse.users)
            }

            isLoadingMoreUsers = false
            contentState = .content
        } catch {
            contentState = .error
        }
    }

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

    func refresh() async {
        contentState = .loading
        hasMoreUsers = false
        pagingCursor = nil
        await fetchUsers(refresh: true)
    }
}
