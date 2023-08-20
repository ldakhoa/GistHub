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
    case userForkedGists(userName: String?)
    case userGists(userName: String)
    case discover(mode: DiscoverGistsMode)

    public var navigationTitle: String {
        switch self {
        case .currentUserGists:
            return "Gists"
        case .userStarredGists:
            return "Starred Gists"
        case .userForkedGists:
            return "Forked Gists"
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
        case .userForkedGists:
            return "Search Forked Gists"
        case .discover:
            return ""
        }
    }

    public var navigationStyle: NavigationBarItem.TitleDisplayMode {
        switch self {
        case .userGists, .userStarredGists:
            return .inline
        default:
            return .large
        }
    }

    public var shouldShowSearch: Bool {
        switch self {
        case .currentUserGists, .userStarredGists, .userGists, .userForkedGists:
            return true
        case .discover:
            return false
        }
    }

    public var shouldGetFilesCountFromGist: Bool {
        switch self {
        case .currentUserGists, .userGists:
            return false
        default:
            return true
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
        case .currentUserGists, .userGists, .userStarredGists, .userForkedGists:
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

    public var sortOption: SortOption {
        switch self {
        case .created:
            return SortOption(field: .created, direction: .desc)
        case .leastRecentlyCreated:
            return SortOption(field: .created, direction: .asc)
        case .updated:
            return SortOption(field: .updated, direction: .desc)
        case .leastRecentlyUpdated:
            return SortOption(field: .updated, direction: .asc)
        }
    }

    public struct SortOption {
        public let field: Field
        public let direction: Direction
    }

    public enum Field: String {
        case created
        case updated
    }

    public enum Direction: String {
        case asc
        case desc
    }
}
