//
//  EditorViewController.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import UIKit
import Runestone
import SwiftUI

protocol EditorViewControllerDelegate: AnyObject {
    func textViewDidChange(text: String)
}

final class EditorViewController: UIViewController {
    private lazy var textView: TextView = {
        let textView = TextView.makeConfigured(usingSettings: .standard)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.editorDelegate = self
        return textView
    }()

    let label = UILabel()

    private let content: Binding<String>
    private let isEditable: Bool
    private let isSelectable: Bool
    private let language: File.Language

    weak var delegate: EditorViewControllerDelegate?

    init(
        content: Binding<String>,
        isEditable: Bool,
        isSelectable: Bool = true,
        language: File.Language
    ) {
        self.content = content
        self.isEditable = isEditable
        self.language = language
        self.isSelectable = isSelectable
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        let languageMode = TreeSitterLanguageMode(language: language.treeSitterLanguage)
        textView.setLanguageMode(languageMode)

        textView.text = content.wrappedValue
        textView.isEditable = isEditable
        textView.isSelectable = isSelectable

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTextView),
            name: .editorTextViewTextDidChange,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTextViewSettings),
            name: .textViewShouldUpdateSettings,
            object: nil
        )
    }

    @objc
    private func updateTextView(notification: Notification) {
        guard let content = notification.object as? String else { return }
        textView.text = content
    }

    @objc
    private func updateTextViewSettings() {
        let settings = UserDefaults.standard
        textView.applySettings(from: settings)
    }
}

extension EditorViewController: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        delegate?.textViewDidChange(text: textView.text)
    }
}
