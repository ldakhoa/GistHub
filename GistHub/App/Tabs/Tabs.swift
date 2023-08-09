import SwiftUI

enum Tab: Int, Identifiable, Hashable {
    case home
    case search
    case profile
    case discover
    case newGist
    case other

    var id: Int {
        rawValue
    }

    static func loggedInTabs() -> [Tab] {
        [.home, .search, .newGist, .discover, .profile]
    }

    static func loggedOutTabs() -> [Tab] {
        []
    }

    @ViewBuilder
    func makeContentView(
        popToRootTab: Binding<Tab>,
        selectedTab: Binding<Tab>
    ) -> some View {
        switch self {
        case .home:
            HomeTab(selectedTab: selectedTab, popToRootTab: popToRootTab)
        case .search:
            SearchTab(selectedTab: selectedTab, popToRootTab: popToRootTab)
        case .newGist:
            Text("")
        case .profile:
            ProfileTab(selectedTab: selectedTab, popToRootTab: popToRootTab)
        case .discover:
            DiscoverTab(selectedTab: selectedTab, popToRootTab: popToRootTab)
        case .other:
            EmptyView()
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .newGist:
            return "New Gist"
        case .discover:
            return "Discover"
        case .profile:
            return "Profile"
        case .other:
            return "Other"
        }
    }

    var iconName: String {
        switch self {
        case .home:
            return "home"
        case .search:
            return "tb_search"
        case .newGist:
            return "new_gist"
        case .discover:
            return "discover"
        case .profile:
            return "person"
        case .other:
            return "other"
        }
    }

    var iconSelectedName: String {
        "\(iconName)-fill"
    }
}
