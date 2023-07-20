//
//  GistListsMode.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

// TODO: Move to Gist
public enum GistListsMode {
    case allGists
    case starred

    public var navigationTitle: String {
        switch self {
        case .allGists:
            return "All Gists"
        case .starred:
            return "Starred Gists"
        }
    }

    public var promptSearchText: String {
        switch self {
        case .allGists:
            return "Search Gists"
        case .starred:
            return "Search Starred Gists"
        }
    }
}
