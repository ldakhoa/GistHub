import SwiftUI
import Networking
import Models

public struct UserFollowsView: View {
    private let login: String
    private let type: UserFollowType

    public init(login: String, type: UserFollowType) {
        self.login = login
        self.type = type
    }

    public var body: some View {
        let viewModel = UserFollowViewModel(login: login, type: type)
        UserListView(viewModel: viewModel)
            .navigationTitle(type.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

public final class UserFollowViewModel: UserListViewModeling {
    @Published public private(set) var contentState: UserListContentState = .loading
    @Published public private(set) var isLoadingMoreUsers: Bool = false
    @Published public private(set) var users: [User] = []

    private let client: UserAPIClient
    private let login: String
    private let type: UserFollowType
    private var pagingCursor: String?
    private var hasMoreUsers: Bool = false

    public init(
        login: String,
        type: UserFollowType,
        client: UserAPIClient = DefaultUserAPIClient()
    ) {
        self.login = login
        self.type = type
        self.client = client
    }

    @MainActor
    public func fetchUsers(refresh: Bool = false) async {
        do {
            isLoadingMoreUsers = true
            let usersResponse: UsersResponse
            switch type {
            case .follower:
                usersResponse = try await client.followers(
                   fromUserName: login,
                   pageSize: 20,
                   cursor: pagingCursor
               )
               pagingCursor = usersResponse.cursor
            case .following:
                usersResponse = try await client.followings(
                   fromUserName: login,
                   pageSize: 20,
                   cursor: pagingCursor
               )
               pagingCursor = usersResponse.cursor
            }
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
    public func fetchMoreUsersIfNeeded(currentUserLogin: String) async {
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

    @MainActor
    public func refresh() async {
        contentState = .loading
        hasMoreUsers = false
        pagingCursor = nil
        await fetchUsers(refresh: true)
    }
}
