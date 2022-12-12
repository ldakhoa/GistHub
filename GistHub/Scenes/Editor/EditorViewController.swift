//
//  EditorViewController.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import UIKit
import Runestone
import TreeSitterMarkdownRunestone
import TreeSitterSwift
import TreeSitterJavaScriptRunestone

final class EditorViewController: UIViewController {
    private lazy var textView: TextView = {
        let textView = TextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        textView.showLineNumbers = true
        textView.lineHeightMultiplier = 1.2
        textView.kern = 0.3
        textView.showNonBreakingSpaces = true
        textView.showLineBreaks = true
        textView.showSoftLineBreaks = true
        textView.isLineWrappingEnabled = true
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.smartQuotesType = .no
        textView.smartDashesType = .no
        textView.editorDelegate = self
        return textView
    }()

    let label = UILabel()

    override func loadView() {
        super.loadView()

        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let languageMode = TreeSitterLanguageMode(language: .javaScript)
        textView.setLanguageMode(languageMode)
    }
 
}

extension EditorViewController: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        print(textView.text)
    }
}
