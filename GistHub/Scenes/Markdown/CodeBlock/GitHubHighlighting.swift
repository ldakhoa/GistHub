//
//  GitHubHighlighting.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import Highlightr

enum GitHubHighlighting {
    static func highlight(_ code: String, as language: String, userInterfaceStyle: UIUserInterfaceStyle) -> NSAttributedString? {
        let fixedLanguage = language.isEmpty ? nil : language.replacingOccurrences(of: "objective-c", with: "objectivec")
        let highlightr = Highlightr()
        highlightr?.setTheme(to: userInterfaceStyle == .light ? "github" : "github-dark-dimmed")
        highlightr?.theme.setCodeFont(MarkdownText.code.preferredFont)
        return highlightr?.highlight(code, as: fixedLanguage, fastRender: true)
    }
}
