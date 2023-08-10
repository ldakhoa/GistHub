import SwiftUI
import DesignSystem
import Environment
import Models
import Networking

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
                ErrorView(title: "Cannot Connect") {
                    Task {
                        await searchUsers()
                    }
                }
            case let .content(users):
                if users.isEmpty {
                    Text("There aren't any users.")
                        .font(.title2)
                        .bold()
                } else {
                    List {
                        Section {
                            ForEach(users, id: \.login) { user in
                                SearchUserListRow(user: user) {
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

struct SearchUserListRow: View {
    let user: User
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                if let avatarUrlString = user.avatarURL, let url = URL(string: avatarUrlString) {
                    GistHubImage(url: url, width: 48, height: 48, cornerRadius: 24)
                }
                VStack(alignment: .leading) {
                    Text(user.name ?? "")
                    Text(user.login ?? "ghost")
                        .font(.callout)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }
                Spacer()
                RightChevronRowImage()
            }
        }
    }
}

struct SearchUsersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                SearchUsersView(query: "ldakhoa")
            }

            SearchUserListRow(user: .stubbed) {}
        }
    }
}
