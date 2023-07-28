//
//  GistListsMode.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

public enum GistListsMode: Hashable {
    case currentUserGists
    case currentUserStarredGists
    case userGists(userName: String)

    public var navigationTitle: String {
        switch self {
        case .currentUserGists:
            return "All Gists"
        case .currentUserStarredGists:
            return "Starred Gists"
        case .userGists:
            return "Gists"
        }
    }

    public var promptSearchText: String {
        switch self {
        case .currentUserStarredGists:
            return "Search Starred Gists"
        case .currentUserGists, .userGists:
            return "Search Gists"
        }
    }
}
