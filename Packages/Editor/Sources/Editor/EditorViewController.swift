//
//  EditorViewController.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import UIKit
import Runestone
import SwiftUI
import KeyboardToolbar
import Models
import Environment
import Utilities
import Markdown

public protocol EditorViewControllerDelegate: AnyObject {
    func textViewDidChange(text: String)
}

public final class EditorViewController: UIViewController {
    private lazy var textView: TextView = {
        let textView = TextView.makeConfigured(
            usingSettings: .standard,
            userInterfaceStyle: traitCollection.userInterfaceStyle
        )
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.editorDelegate = self
        textView.delegate = self
        return textView
    }()

    private lazy var keyboardToolbarView = KeyboardToolbarView()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let content: Binding<String>
    private let isEditable: Bool
    private let isSelectable: Bool
    private let language: File.Language
    private var markdownPreviewScrollPercentage: Float = 0

    public weak var delegate: EditorViewControllerDelegate?

    public init(
        style: EditorViewController.Style,
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

        if style == .issue {
            textView.showLineNumbers = false
            textView.isLineWrappingEnabled = true
            textView.lineSelectionDisplayType = .disabled
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
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

    public override func viewDidLoad() {
        super.viewDidLoad()

        if language == .markdown {
            textView.inputAccessoryView = MarkdownKeyboardToolsView(textView: textView)
        } else {
            textView.inputAccessoryView = keyboardToolbarView
            setupKeyboardTools()
        }

        textView.isEditable = isEditable
        textView.isSelectable = isSelectable
        textView.isFindInteractionEnabled = true

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showMarkdownPreview),
            name: .textViewShouldShowMarkdownPreview,
            object: nil
        )
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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

    @objc
    private func showMarkdownPreview() {
        let previewController = MarkdownPreviewViewController(markdown: self.textView.text, mode: .editPreview)
        previewController.modalPresentationStyle = .fullScreen
        previewController.scrollPercentage = self.markdownPreviewScrollPercentage
        navigationController?.pushViewController(previewController, animated: true)
    }

    private func setupKeyboardTools() {
        let canUndo = textView.undoManager?.canUndo ?? false
        let canRedo = textView.undoManager?.canRedo ?? false
        keyboardToolbarView.groups = [
            KeyboardToolGroup(items: [
                KeyboardToolGroupItem(style: .secondary, representativeTool: BlockKeyboardTool(symbolName: "arrow.uturn.backward") { [weak self] in
                    self?.textView.undoManager?.undo()
                    self?.setupKeyboardTools()
                }, isEnabled: canUndo),
                KeyboardToolGroupItem(style: .secondary, representativeTool: BlockKeyboardTool(symbolName: "arrow.uturn.forward") { [weak self] in
                    self?.textView.undoManager?.redo()
                    self?.setupKeyboardTools()
                }, isEnabled: canRedo)
            ]),
            KeyboardToolGroup(items: [
                KeyboardToolGroupItem(
                    representativeTool: BlockKeyboardTool(symbolName: "arrow.right.to.line.compact") {
                        self.shiftRight()
                    },
                    tools: [
                        BlockKeyboardTool(symbolName: "arrow.right.to.line.compact") {
                            self.shiftRight()
                        },
                        BlockKeyboardTool(symbolName: "arrow.left.to.line.compact") {
                            self.shiftLeft()
                        },
                        BlockKeyboardTool(symbolName: "arrow.up.to.line.compact") {
                            self.shiftUp()
                        },
                        BlockKeyboardTool(symbolName: "arrow.down.to.line.compact") {
                            self.shiftDown()
                        }
                ]),
                KeyboardToolGroupItem(representativeTool: InsertTextKeyboardTool(text: "(", textView: textView), tools: [
                    InsertTextKeyboardTool(text: "(", textView: textView),
                    InsertTextKeyboardTool(text: "{", textView: textView),
                    InsertTextKeyboardTool(text: "[", textView: textView),
                    InsertTextKeyboardTool(text: "]", textView: textView),
                    InsertTextKeyboardTool(text: "}", textView: textView),
                    InsertTextKeyboardTool(text: ")", textView: textView)
                ]),
                KeyboardToolGroupItem(representativeTool: InsertTextKeyboardTool(text: ".", textView: textView), tools: [
                    InsertTextKeyboardTool(text: ".", textView: textView),
                    InsertTextKeyboardTool(text: ",", textView: textView),
                    InsertTextKeyboardTool(text: ";", textView: textView),
                    InsertTextKeyboardTool(text: "!", textView: textView),
                    InsertTextKeyboardTool(text: "&", textView: textView),
                    InsertTextKeyboardTool(text: "|", textView: textView)
                ]),
                KeyboardToolGroupItem(representativeTool: InsertTextKeyboardTool(text: "=", textView: textView), tools: [
                    InsertTextKeyboardTool(text: "=", textView: textView),
                    InsertTextKeyboardTool(text: "+", textView: textView),
                    InsertTextKeyboardTool(text: "-", textView: textView),
                    InsertTextKeyboardTool(text: "/", textView: textView),
                    InsertTextKeyboardTool(text: "*", textView: textView),
                    InsertTextKeyboardTool(text: "<", textView: textView),
                    InsertTextKeyboardTool(text: ">", textView: textView)
                ]),
                KeyboardToolGroupItem(representativeTool: InsertTextKeyboardTool(text: "#", textView: textView), tools: [
                    InsertTextKeyboardTool(text: "#", textView: textView),
                    InsertTextKeyboardTool(text: "\"", textView: textView),
                    InsertTextKeyboardTool(text: "'", textView: textView),
                    InsertTextKeyboardTool(text: "$", textView: textView),
                    InsertTextKeyboardTool(text: "\\", textView: textView),
                    InsertTextKeyboardTool(text: "@", textView: textView),
                    InsertTextKeyboardTool(text: "%", textView: textView),
                    InsertTextKeyboardTool(text: "~", textView: textView)
                ])
            ]),
            KeyboardToolGroup(items: [
                KeyboardToolGroupItem(style: .secondary, representativeTool: BlockKeyboardTool(symbolName: "magnifyingglass") { [weak self] in
                    self?.textView.findInteraction?.presentFindNavigator(showingReplace: false)
                }),
                KeyboardToolGroupItem(style: .secondary, representativeTool: BlockKeyboardTool(symbolName: "keyboard.chevron.compact.down") { [weak self] in
                    self?.textView.resignFirstResponder()
                })
            ])
        ]
    }

    @objc
    private func shiftLeft() {
        textView.shiftLeft()
    }

    @objc
    private func shiftRight() {
        textView.shiftRight()
    }

    @objc
    private func shiftUp() {
        textView.moveSelectedLinesUp()
    }

    @objc
    private func shiftDown() {
        textView.moveSelectedLinesDown()
    }
}

extension EditorViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos = scrollView.contentOffset.y
        let height = textView.contentSize.height

        let percentage = Float(yPos / height)
        self.markdownPreviewScrollPercentage = percentage
    }
}

extension EditorViewController: TextViewDelegate {
    public func textViewDidChange(_ textView: TextView) {
        delegate?.textViewDidChange(text: textView.text)
        setupKeyboardTools()
    }

    public func textView(
        _ textView: TextView,
        canReplaceTextIn highlightedRange: HighlightedRange
    ) -> Bool {
        true
    }
}

extension EditorViewController {
    public enum Style {
        case normal
        case issue
    }
}
