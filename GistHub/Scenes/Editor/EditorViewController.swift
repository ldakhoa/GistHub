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
        let textView = TextView.makeConfigured(usingSettings: .standard, userInterfaceStyle: traitCollection.userInterfaceStyle)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.editorDelegate = self
        return textView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.isEditable = isEditable
        textView.isSelectable = isSelectable
        setTextViewState(on: textView)

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTextViewTheme),
            name: .textViewShouldUpdateTheme,
            object: nil
        )
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            textView.applyTheme(TomorrowNightTheme())
        } else {
            let theme = UserDefaults.standard.theme.makeTheme()
            textView.applyTheme(theme)
        }
    }

    private func setTextViewState(on textView: TextView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let text = self.content.wrappedValue
            let theme = UserDefaults.standard.theme.makeTheme()
            let state = TextViewState(text: text, theme: theme, language: self.language.treeSitterLanguage)

            DispatchQueue.main.async {
                textView.setState(state)
            }
        }
    }

    @objc
    private func updateTextViewTheme() {
        // Force dark mode if user interface style is dark
        guard traitCollection.userInterfaceStyle == .light else { return }
        let theme = UserDefaults.standard.theme.makeTheme()
        textView.applyTheme(theme)
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
