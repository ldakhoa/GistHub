//
//  GistListsMode.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import SwiftUI

public enum GistListsMode: Hashable {
    case currentUserGists(filter: GistsPrivacyFilter)
    case userStarredGists(userName: String?)
    case userGists(userName: String)
    case search(query: String)
    case discover(mode: DiscoverGistsMode)

    public var navigationTitle: String {
        switch self {
        case .currentUserGists, .search:
            return "Gists"
        case .userStarredGists:
            return "Starred Gists"
        case .userGists:
            return "Gists"
        case .discover:
            return "Discover Gists"
        }
    }

    public var promptSearchText: String {
        switch self {
        case .userStarredGists:
            return "Search Starred Gists"
        case .currentUserGists, .userGists:
            return "Search Gists"
        case .discover, .search:
            return ""
        }
    }

    public var navigationStyle: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .search, .userGists, .userStarredGists:
            return .inline
        default:
            return .large
        }
    }

    public var shouldShowSearch: Bool {
        switch self {
        case .currentUserGists, .userStarredGists, .userGists:
            return true
        case .discover, .search:
            return false
        }
    }

    public var shouldShowMenuView: Bool {
        switch self {
        case .discover:
            return true
        default:
            return false
        }
    }

    public var shouldShowFilter: Bool {
        switch self {
        case .currentUserGists:
            return true
        default:
            return false
        }
    }

    public var shouldShowSortOption: Bool {
        switch self {
        case .currentUserGists, .userGists:
            return true
        default:
            return false
        }
    }
}

public enum DiscoverGistsMode: Int, Identifiable, Hashable, CaseIterable {
    case all
    case forked
    case starred

    public var id: Int {
        rawValue
    }

    public var title: String {
        switch self {
        case .all:
            return "All Gists"
        case .forked:
            return "Forked"
        case .starred:
            return "Starred"
        }
    }
}

public enum GistsPrivacyFilter: Int, Identifiable, Hashable, CaseIterable {
    case all
    case `public`
    case secret

    public var id: Int {
        rawValue
    }

    public var title: String {
        switch self {
        case .all:
            return "All Gists"
        case .public:
            return "Public"
        case .secret:
            return "Secret"
        }
    }
}

public enum GistsSortOption: Int, Hashable, CaseIterable {
    case created
    case leastRecentlyCreated
    case updated
    case leastRecentlyUpdated

    public var title: String {
        switch self {
        case .created:
            return "Recently created"
        case .leastRecentlyCreated:
            return "Least recently created"
        case .updated:
            return "Recently updated"
        case .leastRecentlyUpdated:
            return "Least recently updated"
        }
    }
}
