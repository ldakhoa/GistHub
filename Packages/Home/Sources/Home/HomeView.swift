import SwiftUI
import DesignSystem
import Environment
import AppAccount
import Gist

public struct HomeView: View {
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var routerPath: RouterPath
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    @State private var selectedItem: Item? =
        UIDevice.current.userInterfaceIdiom == .pad ? .gists : nil

    private enum Item: String, CaseIterable, Identifiable {
        case gists = "Gists"
        case starred = "Starred"
        case forked = "Forked"

        var id: Self { self }

        @ViewBuilder func image() -> some View {
            switch self {
            case .gists:
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .background(Colors.buttonForeground.color)
                    .cornerRadius(6.0)

            case .starred:
                Image(systemName: "star")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .background(Colors.Palette.Yellow.yellow2.dynamicColor.color)
                    .cornerRadius(6.0)

            case .forked:
                Image(uiImage: UIImage(named: "fork")!)
                    .renderingMode(.template)
                    .frame(width: 9, height: 9)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Colors.Palette.Purple.purple3.dynamicColor.color)
                    .cornerRadius(6.0)
            }
        }
    }

    public init() {}

    public var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                Section {
                    ForEach(Item.allCases) { item in
                        rowView(item)
                    }

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
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        } detail: {
            if let selectedItem {
                switch selectedItem {
                case .gists:
                    GistListsView(listsMode: .currentUserGists(filter: .all))
                case .starred:
                    GistListsView(listsMode: .userStarredGists(userName: currentAccount.user?.login ?? "ghost"))
                case .forked:
                    GistListsView(listsMode: .userForkedGists(userName: currentAccount.user?.login ?? "ghost"))
                }
            }
        }
        .task {
            await viewModel.fetchRecentComments(from: appAccountsManager.focusedAccount?.username)
        }
        .refreshable {
            Task {
                await viewModel.fetchRecentComments(from: currentAccount.user?.login)
            }
        }
    }

    @ViewBuilder
    private func rowView(_ item: Item) -> some View {
        let textColor = UIDevice.current.userInterfaceIdiom == .pad && item == selectedItem ?
            Color.white : Colors.neutralEmphasisPlus.color
        HStack {
            Label(title: {
                Text(item.rawValue)
                    .foregroundColor(textColor)
            }, icon: item.image)
            Spacer()
            RightChevronRowImage()
        }
        .frame(height: UIDevice.current.userInterfaceIdiom == .pad ? 32 : 37)
    }
}
