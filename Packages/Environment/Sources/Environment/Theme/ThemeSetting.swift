//
//  ThemeSetting.swift
//  GistHub
//
//  Created by Khoa Le on 20/12/2022.
//

import Foundation

public enum ThemeSetting: String, CaseIterable, Hashable {
    case gitHubLight
    case gitHubDark

    public func makeTheme() -> EditorTheme {
        switch self {
        case .gitHubLight:
            return GitHubTheme()
        case .gitHubDark:
            return GitHubDarkTheme()
        }
    }
}
