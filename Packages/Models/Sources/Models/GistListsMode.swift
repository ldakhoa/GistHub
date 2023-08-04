//
//  GistListsMode.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

public enum GistListsMode: Hashable {
    case currentUserGists
    case userStarredGists(userName: String?)
    case userGists(userName: String)
    case discover(mode: DiscoverGistsMode)

    public var navigationTitle: String {
        switch self {
        case .currentUserGists:
            return "Gists"
        case .userStarredGists:
            return "Starred Gists"
        case .userGists:
            return "Gists"
        case let .discover(mode):
            return mode.title
        }
    }

    public var promptSearchText: String {
        switch self {
        case .userStarredGists:
            return "Search Starred Gists"
        case .currentUserGists, .userGists:
            return "Search Gists"
        case .discover:
            return ""
        }
    }

    public var shouldShowSearch: Bool {
        switch self {
        case .currentUserGists, .userStarredGists, .userGists:
            return true
        case .discover:
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
}

public enum DiscoverGistsMode: Hashable {
    case all
    case forked
    case starred

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
