//
//  GitHubHighlighting.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import Foundation
import Highlightr

enum GitHubHighlighting {
    private static var shared: Highlightr? = {
        let view = Highlightr()
        view?.setTheme(to: "github")
        view?.theme.setCodeFont(MarkdownText.code.preferredFont)
        return view
    }()

    static func highlight(_ code: String, as language: String) -> NSAttributedString? {
        let fixedLanguage = language.isEmpty ? nil : language
        return shared?.highlight(code, as: fixedLanguage, fastRender: true)
    }

    static func highlight(_ code: String) -> NSAttributedString? {
        shared?.highlight(code)
    }
}
