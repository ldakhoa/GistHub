import SwiftUI
import DesignSystem
import Environment
import AppAccount

public struct HomeView: View {
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var routerPath: RouterPath
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()

    public init() {}

    public var body: some View {
        List {
            Section {
                buttonRowView(
                    title: "Gists",
                    image: "doc.text.magnifyingglass",
                    imageBackground: Colors.buttonForeground.color
                ) {
                    routerPath.navigate(to: .gistLists(mode: .currentUserGists(filter: .all)))
                }

                buttonRowView(
                    title: "Starred",
                    image: "star",
                    imageBackground: Colors.Palette.Yellow.yellow2.dynamicColor.color
                ) {
                    routerPath.navigate(to: .gistLists(mode: .userStarredGists(userName: currentAccount.user?.login ?? "ghost")))
                }

                forkButtonRowView

                // Temporary turn it off
//                buttonRowView(
//                    title: "Draft",
//                    image: "doc.text",
//                    imageBackground: Colors.Palette.Orange.orange3.dynamicColor.color
//                ) {
//                    routerPath.navigate(to: .draftGistLists)
//                }
            } header: {
                Text("My Gist")
                    .headerProminence(.increased)
            }

            // Temporary turn it off
//            Section {
//                QuickAccessSectionView()
//            } header: {
//                Text("Quick Access")
//                    .headerProminence(.increased)
//            }

            switch viewModel.contentState {
            case .loading:
                HStack {
                    Spacer()
                    ProgressView()
                        .tint(Colors.accent.color)
                    Spacer()
                }
                .listRowBackground(Color.clear)
            case .error:
                ErrorView(title: "Cannot Connect", message: "Something went wrong. Please try again.") {
                    Task {
                        await viewModel.refresh(from: currentAccount.user?.login)
                    }
                }
            case .content:
                if !viewModel.recentComments.isEmpty {
                    Section {
                        RecentActivitiesSectionView(recentComments: viewModel.recentComments)
                    } header: {
                        Text("Recent Activities")
                            .headerProminence(.increased)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRecentComments(from: appAccountsManager.focusedAccount?.username)
            }
        }
        .refreshable {
            Task {
                await viewModel.fetchRecentComments(from: currentAccount.user?.login)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private var forkButtonRowView: some View {
        Button(action: {
            routerPath.navigate(to: .gistLists(mode: .userForkedGists(userName: currentAccount.user?.login ?? "ghost")))
        }, label: {
            HStack {
                Label {
                    Text("Forked")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                } icon: {
                    Image(uiImage: UIImage(named: "fork")!)
                        .renderingMode(.template)
                        .frame(width: 9, height: 9)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Colors.Palette.Purple.purple3.dynamicColor.color)
                        .cornerRadius(6.0)
                }
                Spacer()
                RightChevronRowImage()
            }
        })
        .frame(height: 37)
    }

    @ViewBuilder
    private func buttonRowView(
        title: String,
        image: String,
        imageBackground: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action, label: {
            HStack {
                Label {
                    Text(title)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                } icon: {
                    Image(systemName: image)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                        .background(imageBackground)
                        .cornerRadius(6.0)
                }
                Spacer()
                RightChevronRowImage()
            }
        })
        .frame(height: 37)
    }
}
