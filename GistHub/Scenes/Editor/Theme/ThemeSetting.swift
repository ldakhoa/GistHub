//
//  ThemeSetting.swift
//  GistHub
//
//  Created by Khoa Le on 20/12/2022.
//

import Foundation

enum ThemeSetting: String, CaseIterable, Hashable {
    case tomorrow
    case tomorrowNight

    func makeTheme() -> EditorTheme {
        switch self {
        case .tomorrow:
            return TomorrowTheme()
        case .tomorrowNight:
            return TomorrowNightTheme()
        }
    }
}
