import SwiftUI

enum Tab: Int, Identifiable, Hashable {
    case home
    case starred
    case profile

    var id: Int {
        rawValue
    }

    static func loggedInTabs() -> [Tab] {
        [.home, .starred, .profile]
    }

    @ViewBuilder
    func makeContentView() -> some View {
        switch self {
        case .home:
            HomeTab()
        case .starred:
            StarredTab()
        case .profile:
            ProfileTab()
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
        }
    }

    var iconSelectedName: String {
        "\(iconName)-fill"
    }
}
