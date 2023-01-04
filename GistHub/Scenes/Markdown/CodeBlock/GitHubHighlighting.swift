//
//  GitHubHighlighting.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import Highlightr

enum GitHubHighlighting {
//    private static var shared: Highlightr? = {
//        let view = Highlightr()
//        view?.setTheme(to: "github-dark-dimmed")
//        view?.theme.setCodeFont(MarkdownText.code.preferredFont)
//        return view
//    }()

    static func highlight(_ code: String, as language: String, userInterfaceStyle: UIUserInterfaceStyle) -> NSAttributedString? {
        let fixedLanguage = language.isEmpty ? nil : language
        let highlightr = Highlightr()
        highlightr?.setTheme(to: userInterfaceStyle == .light ? "github" : "github-dark-dimmed")
        highlightr?.theme.setCodeFont(MarkdownText.code.preferredFont)
        return highlightr?.highlight(code, as: fixedLanguage, fastRender: true)
    }

//    static func highlight(_ code: String) -> NSAttributedString? {
//        shared?.highlight(code)
//    }
}
