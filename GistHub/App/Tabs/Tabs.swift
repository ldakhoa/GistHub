import SwiftUI

enum Tab: Int, Identifiable, Hashable {
    case home
    case starred
    case profile
    case discover
    case other

    var id: Int {
        rawValue
    }

    static func loggedInTabs() -> [Tab] {
        [.home, .starred, .discover, .profile]
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
        case .starred:
            StarredTab(selectedTab: selectedTab, popToRootTab: popToRootTab)
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
        case .starred:
            return "Starred"
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
        case .starred:
            return "star"
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
