import SwiftUI

enum Tab: Int, Identifiable, Hashable {
    case home
    case starred
    case profile
    case other

    var id: Int {
        rawValue
    }

    static func loggedInTabs() -> [Tab] {
        [.home, .starred, .profile]
    }

    static func loggedOutTabs() -> [Tab] {
        []
    }

    @ViewBuilder
    func makeContentView(popToRootTab: Binding<Tab>) -> some View {
        switch self {
        case .home:
            HomeTab(popToRootTab: popToRootTab)
        case .starred:
            StarredTab(popToRootTab: popToRootTab)
        case .profile:
            ProfileTab(popToRootTab: popToRootTab)
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
