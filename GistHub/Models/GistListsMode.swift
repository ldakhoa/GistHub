//
//  GistListsMode.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

enum GistListsMode {
    case allGists
    case starred

    var navigationTitle: String {
        switch self {
        case .allGists:
            return "All Gists"
        case .starred:
            return "Starred Gists"
        }
    }
}
