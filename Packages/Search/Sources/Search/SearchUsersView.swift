import SwiftUI
import DesignSystem
import Environment
import Models
import Networking
import UserProfile

public struct SearchUsersView: View {
    @EnvironmentObject private var routerPath: RouterPath
    private let client: GistHubAPIClient
    private let query: String
    @State private var contentState: ContentState = .loading

    public init(
        query: String,
        client: GistHubAPIClient = DefaultGistHubAPIClient()
    ) {
        self.query = query
        self.client = client
    }

    public var body: some View {
        ZStack {
            Colors.scrollViewBackground.color
            switch contentState {
            case .loading:
                ProgressView()
            case .error:
                ErrorView(
                    title: "Cannot Connect",
                    message: "Something went wrong. Please try again."
                ) {
                    Task {
                        await searchUsers()
                    }
                }
            case let .content(users):
                if users.isEmpty {
                    EmptyStatefulView(title: "There aren't any users.")
                } else {
                    List {
                        Section {
                            ForEach(users, id: \.login) { user in
                                UserListRowView(user: user) {
                                    routerPath.navigateToUserProfileView(with: user.login ?? "ghost")
                                }
                            }
                        } header: {
                            Spacer(minLength: 0)
                        }
                    }
                    .padding(.top, -28)
                }
            }
        }
        .onAppear {
            Task {
                await searchUsers()
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Users")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }

    private func searchUsers() async {
        contentState = .loading
        do {
            let userSearchResponse = try await client.searchUsers(from: query, cursor: nil)
            contentState = .content(users: userSearchResponse.users)
        } catch {
            contentState = .error
        }
    }
}

extension SearchUsersView {
    enum ContentState {
        case loading
        case content(users: [User])
        case error
    }
}
