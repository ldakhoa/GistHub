//
//  TextView+Helpers.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import UIKit
import Runestone
import Environment

extension TextView {
    static func makeConfigured(usingSettings settings: UserDefaults) -> TextView {
        let textView = TextView()
        textView.alwaysBounceVertical = true
        textView.contentInsetAdjustmentBehavior = .always
        textView.backgroundColor = .systemBackground
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .none
        textView.smartDashesType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.lineSelectionDisplayType = .line
        textView.lineHeightMultiplier = 1.3
        textView.kern = 0.3
        textView.pageGuideColumn = 80

        textView.applySettings(from: settings)

        let theme = settings.theme.makeTheme()
        textView.applyTheme(theme)
        textView.applySettings(from: settings)
        return textView
    }

    func applyTheme(_ theme: EditorTheme) {
        self.theme = theme
        backgroundColor = theme.backgroundColor
        insertionPointColor = theme.textColor
        selectionBarColor = theme.textColor
        selectionHighlightColor = theme.textColor.withAlphaComponent(0.2)
    }

    func applySettings(from settings: UserDefaults) {
        showLineNumbers = settings.showLineNumbers
        showTabs = settings.showTabs
        showSpaces = settings.showSpaces
        showLineBreaks = settings.showInvisibleCharacters
        isLineWrappingEnabled = settings.wrapLines
        lineSelectionDisplayType = settings.highlightSelectedLine ? .line : .disabled
        showPageGuide = settings.showPageGuide
    }
}
