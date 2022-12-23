//
//  KeyboardToolView.swift
//  GistHub
//
//  Created by Khoa Le on 23/12/2022.
//

import UIKit
import Runestone

final class KeyboardToolsView: UIInputView {

    private weak var textView: TextView?

    init(textView: TextView) {
        self.textView = textView
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        super.init(frame: frame, inputViewStyle: .keyboard)

        addToolBar(toolbar: makeToolBar())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addToolBar(toolbar: UIToolbar) {
        let scrollFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: toolbar.frame.height)
        let scrollView = UIScrollView(frame: scrollFrame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = .init(width: toolbar.frame.width, height: toolbar.frame.height)
        scrollView.addSubview(toolbar)

        self.addSubview(scrollView)
        scrollView.backgroundColor = Colors.listBackground

        let topBorder = CALayer()
        topBorder.frame = CGRect(x: -1000, y: 0, width: 9999, height: 1)
        topBorder.backgroundColor = Colors.Palette.Gray.gray2.dynamicColor.cgColor
        scrollView.layer.addSublayer(topBorder)

        textView?.inputAccessoryView = scrollView
    }

    private func makeToolBar() -> UIToolbar {
        var items = [UIBarButtonItem]()

        let boldButton = makeToolBarButtonItem(named: "bold", action: #selector(onBold))
        let italicButton = makeToolBarButtonItem(named: "italic", action: #selector(onItalic))
        italicButton.tag = 0x03
        let strikethroughButton = makeToolBarButtonItem(named: "strike", action: #selector(onStrike))
        strikethroughButton.tag = 0x05
        let inlineButton = makeToolBarButtonItem(named: "code", action: #selector(onInlineCode))
        let codeBlockButton = makeToolBarButtonItem(named: "code_block", action: #selector(onCodeBlock))
        let headingButton = makeToolBarButtonItem(named: "header", action: #selector(onHeading))
        let linkButton = makeToolBarButtonItem(named: "link", action: #selector(onLink))
        let unorderedlistButton = makeToolBarButtonItem(named: "dash", action: #selector(onUnorderedList))
        let todoButton = makeToolBarButtonItem(named: "todo", action: #selector(onTodo))
        let undoButton = makeToolBarButtonItem(named: "undo", action: #selector(onUndo))
        let redoButton = makeToolBarButtonItem(named: "redo", action: #selector(onRedo))

        items = [
            boldButton,
            italicButton,
            strikethroughButton,
            inlineButton,
            codeBlockButton,
            headingButton,
            linkButton,
            todoButton,
            unorderedlistButton,
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

    private func makeToolBarButtonItem(named: String, action: Selector?) -> UIBarButtonItem {
        let tintColor = Colors.button
        return UIBarButtonItem(
            image: UIImage(named: "Keyboard_\(named)")?
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
        textController.bold()
    }

    @objc
    private func onUnorderedList() {
        let textController = TextController(textView: textView!)
        textController.bold()
    }

    @objc
    private func onUndo() {
        let textController = TextController(textView: textView!)
        textController.bold()
    }

    @objc
    private func onRedo() {
        let textController = TextController(textView: textView!)
        textController.bold()
    }

    @objc
    private func onLink() {
        let textController = TextController(textView: textView!)
        textController.link()
    }
}

fileprivate extension Colors {
    static let button = UIColor(light: .black, dark: .white)
}
