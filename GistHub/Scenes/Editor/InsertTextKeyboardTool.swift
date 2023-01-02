import KeyboardToolbar
import UIKit
import Runestone

struct InsertTextKeyboardTool: KeyboardTool {
    let displayRepresentation: KeyboardToolDisplayRepresentation

    private let text: String
    private weak var textView: TextView?

    init(text: String, textView: TextView) {
        self.displayRepresentation = .text(text)
        self.text = text
        self.textView = textView
    }

    func performAction() {
        textView?.insertText(text)
    }
}
