import SwiftUI
import Environment
import DesignSystem
import Models

public struct UserListView<ViewModel: UserListViewModeling>: View {
    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var routerPath: RouterPath

    @State private var progressViewId: Int = 0

    public init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        List {
            switch viewModel.contentState {
            case .loading:
                ForEach(User.placeholders) { user in
                    UserListRowView(user: user, action: {})
                        .redacted(reason: .placeholder)
                }
            case .content:
                if viewModel.users.isEmpty {
                    EmptyStatefulView(title: "There aren't any users.")
                } else {
                    Section {
                        ForEach(viewModel.users, id: \.login) { user in
                            UserListRowView(user: user) {
                                routerPath.navigateToUserProfileView(with: user.login ?? "ghost")
                            }
                            .onAppear {
                                Task {
                                    await viewModel.fetchMoreUsersIfNeeded(currentUserLogin: user.login)
                                }
                            }
                        }
                        if viewModel.isLoadingMoreUsers {
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
                    } header: {
                        Spacer(minLength: 0)
                    }
                }
            case .error:
                ErrorView(
                    title: "Cannot Connect",
                    message: "Something went wrong. Please try again."
                ) {
                    Task {
                        await viewModel.refresh()
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .padding(.top, -28)
        .listStyle(.grouped)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            await viewModel.fetchUsers(refresh: false)
        }
    }
}
