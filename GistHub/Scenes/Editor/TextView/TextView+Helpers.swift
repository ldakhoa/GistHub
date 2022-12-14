//
//  TextView+Helpers.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import UIKit
import Runestone

extension TextView {
    static func makeConfigured(usingSettings settings: UserDefaults) -> TextView {
        let textView = TextView()
        textView.alwaysBounceVertical = true
        textView.contentInsetAdjustmentBehavior = .always
        textView.backgroundColor = .systemBackground
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.smartDashesType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.lineSelectionDisplayType = .line
        textView.lineHeightMultiplier = 1.3
        textView.kern = 0.3
        textView.pageGuideColumn = 80
//        textView.inputAccessoryView = KeyboardToolsView(textView: textView)
        textView.applySettings(from: settings)
        return textView
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
