//
//  KeyboardToolView.swift
//  GistHub
//
//  Created by Khoa Le on 23/12/2022.
//

import UIKit
import Runestone

final class MarkdownKeyboardToolsView: UIInputView {

    private weak var textView: TextView?

    private lazy var undoButton = makeToolBarButtonItem(named: "undo", action: #selector(onUndo))
    private lazy var redoButton = makeToolBarButtonItem(named: "redo", action: #selector(onRedo))

    init(
        textView: TextView
    ) {
        self.textView = textView
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        super.init(frame: frame, inputViewStyle: .keyboard)

        self.backgroundColor = Colors.listBackground

        addToolBar(toolbar: makeMarkdownToolBar())

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: -1000, y: 0, width: 9999, height: 1)
        topBorder.backgroundColor = Colors.Palette.Gray.gray2.dynamicColor.cgColor
        self.layer.addSublayer(topBorder)
        setupUndoManagerObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addToolBar(toolbar: UIToolbar) {
        let scrollWidth = UIScreen.main.bounds.width - 40 - 8 // keyboard dismiss button and 8 spacing

        let scrollFrame = CGRect(x: 0, y: 0, width: scrollWidth, height: toolbar.frame.height)
        let scrollView = UIScrollView(frame: scrollFrame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = .init(width: toolbar.frame.width, height: toolbar.frame.height)
        scrollView.addSubview(toolbar)

        self.addSubview(scrollView)

        let keyboardDismissButton = UIButton()
        keyboardDismissButton.setImage(UIImage(named: "keyboard_dismiss")?.withTintColor(Colors.button, renderingMode: .alwaysOriginal), for: .normal)
        keyboardDismissButton.frame = .init(x: UIScreen.main.bounds.width - 44, y: 0, width: 40, height: toolbar.frame.height)
        keyboardDismissButton.addTarget(self, action: #selector(onDismissKeyboard), for: .touchUpInside)

        if traitCollection.userInterfaceStyle == .light {
            let keyboardDismissButtonGradientLayer = CAGradientLayer()
            keyboardDismissButtonGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            keyboardDismissButtonGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            keyboardDismissButtonGradientLayer.colors = [UIColor(white: 1, alpha: 0).cgColor, UIColor.white.cgColor]
            keyboardDismissButtonGradientLayer.frame = CGRect(x: -15, y: 0, width: 15, height: self.frame.height)
            keyboardDismissButton.layer.addSublayer(keyboardDismissButtonGradientLayer)
        }

        self.addSubview(keyboardDismissButton)

        textView?.inputAccessoryView = scrollView
    }

    private func makeMarkdownToolBar() -> UIToolbar {
        var items = [UIBarButtonItem]()

        let previewButton = makeToolBarButtonItem(named: "preview", action: #selector(onPreview))
        previewButton.tag = 0x02
        let boldButton = makeToolBarButtonItem(named: "bold", action: #selector(onBold))
        let italicButton = makeToolBarButtonItem(named: "italic", action: #selector(onItalic))
        italicButton.tag = 0x03
        let strikethroughButton = makeToolBarButtonItem(named: "strike", action: #selector(onStrike))
        strikethroughButton.tag = 0x05
        let inlineButton = makeToolBarButtonItem(named: "code", action: #selector(onInlineCode))
        let codeBlockButton = makeToolBarButtonItem(named: "code_block", action: #selector(onCodeBlock))
        let headingButton = makeToolBarButtonItem(named: "header", action: #selector(onHeading))
        let linkButton = makeToolBarButtonItem(named: "link", action: #selector(onLink))
        let unorderedlistButton = makeToolBarButtonItem(named: "list", action: #selector(onUnorderedList))
        let todoButton = makeToolBarButtonItem(named: "todo", action: #selector(onTodo))
        let searchButton = makeToolBarButtonItem(named: "search", action: #selector(onSearch))

        items = [
            previewButton,
            boldButton,
            italicButton,
            strikethroughButton,
            headingButton,
            inlineButton,
            codeBlockButton,
            linkButton,
            todoButton,
            unorderedlistButton,
            searchButton,
            undoButton,
            redoButton
        ]

        var width = CGFloat(0)
        for item in items {
            if item.tag == 0x03 {
                item.width = 50
                width += 50
            } else if item.tag == 0x05 {
                item.width = 40
                width += 40
            } else if item.tag == 0x02 {
                item.width = 60
                width += 60
            } else {
                item.width = 50
                width += 50
            }
        }

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        toolBar.setItems(items, animated: false)
        toolBar.isTranslucent = false
        return toolBar
    }

    private func makeCodeToolBar() -> UIToolbar {
        let items = [UIBarButtonItem]()
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        toolBar.setItems(items, animated: false)
        toolBar.isTranslucent = false
        return toolBar
    }

    private func makeToolBarButtonItem(named: String, action: Selector?) -> UIBarButtonItem {
        let tintColor = Colors.button
        return UIBarButtonItem(
            image: UIImage(named: "keyboard_\(named)")?
                .withTintColor(tintColor, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: action
        )
    }

    @objc
    private func onBold() {
        let textController = TextController(textView: textView!)
        textController.bold()
    }

    @objc
    private func onItalic() {
        let textController = TextController(textView: textView!)
        textController.italic()
    }

    @objc
    private func onStrike() {
        let textController = TextController(textView: textView!)
        textController.strike()
    }

    @objc
    private func onHeading() {
        let textController = TextController(textView: textView!)
        textController.header()
    }

    @objc
    private func onInlineCode() {
        let textController = TextController(textView: textView!)
        textController.inlineCode()
    }

    @objc
    private func onCodeBlock() {
        let textController = TextController(textView: textView!)
        textController.codeBlock()
    }

    @objc
    private func onTodo() {
        let textController = TextController(textView: textView!)
        textController.todo()
    }

    @objc
    private func onUnorderedList() {
        let textController = TextController(textView: textView!)
        textController.unorderedList()
    }

    @objc
    private func onUndo() {
        let textController = TextController(textView: textView!)
        textController.undo()
    }

    @objc
    private func onRedo() {
        let textController = TextController(textView: textView!)
        textController.redo()
    }

    @objc
    private func onLink() {
        let textController = TextController(textView: textView!)
        textController.link()
    }

    private func setupUndoManagerObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUndoRedoButtonStates),
            name: .NSUndoManagerCheckpoint,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUndoRedoButtonStates),
            name: .NSUndoManagerDidUndoChange,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUndoRedoButtonStates),
            name: .NSUndoManagerDidRedoChange,
            object: nil)
    }

    @objc
    private func updateUndoRedoButtonStates() {
        let undoManager = textView?.undoManager

        let tintColor = Colors.button
        let undoIcon = UIImage(named: "keyboard_undo")?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        let undoImage = undoManager?.canUndo ?? false ? undoIcon : undoIcon?.alpha(0.5)
        undoButton.isEnabled = undoManager?.canUndo ?? false
        undoButton.image = undoImage

        let redoIcon = UIImage(named: "keyboard_redo")?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        let redoImage = undoManager?.canRedo ?? false ? redoIcon : redoIcon?.alpha(0.5)
        redoButton.isEnabled = undoManager?.canRedo ?? false
        redoButton.image = redoImage
    }

    @objc
    private func onDismissKeyboard() {
        textView?.resignFirstResponder()
    }

    @objc
    private func onSearch() {
        textView?.findInteraction?.presentFindNavigator(showingReplace: false)
    }

    @objc
    private func onPreview() {
        NotificationCenter.default.post(name: .textViewShouldShowMarkdownPreview, object: nil)
    }
}

fileprivate extension Colors {
    static let button = UIColor(light: .black, dark: .white)
}
