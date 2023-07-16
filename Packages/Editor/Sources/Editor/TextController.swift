//
//  TextController.swift
//  GistHub
//
//  Created by Khoa Le on 23/12/2022.
//

import UIKit
import Runestone

/// TextController used to make functionality of shortcut keyboard toolbar.
///
/// Must be inject in every action to keep up-to-date text view selected range.
final class TextController {
    private let textView: TextView
    var range: NSRange
    let textInRange: String

    init(textView: TextView) {
        self.textView = textView
        self.range = textView.selectedRange
        textInRange = textView.text(in: range) ?? ""
    }

    // MARK: - Public

    // MARK: - Bold

    func bold() {
        // Toggle bold if needed
        if textInRange.contains("**") || textInRange.contains("__") {
            unbold(range: range)
            return
        }

        var selectRange = NSRange(location: range.location + 2, length: 0)

        let length = textInRange.count

        if length != 0 {
            selectRange = NSRange(location: range.location, length: length + 4)
        }

        insertText("**" + textInRange + "**", selectRange: selectRange)
    }

    private func unbold(range: NSRange) {
        let unBold = textInRange
            .replacingOccurrences(of: "**", with: "")
            .replacingOccurrences(of: "__", with: "")
        let selectRange = NSRange(location: range.location, length: unBold.count)
        insertText(unBold, replacementRange: range, selectRange: selectRange)
    }

    // MARK: - Italic

    func italic() {
        if textInRange.contains("*") || textInRange.contains("_") {
            unItalic(range: range)
            return
        }

        var selectRange = NSRange(location: range.location + 1, length: 0)
        let length = textInRange.count

        if length != 0 {
            selectRange = NSRange(location: range.location, length: length + 2)
        }

        insertText("_" + textInRange + "_", selectRange: selectRange)
    }

    func unItalic(range: NSRange) {
        let unItalic = textInRange
            .replacingOccurrences(of: "*", with: "")
            .replacingOccurrences(of: "_", with: "")
        let selectRange = NSRange(location: range.location, length: unItalic.count)
        insertText(unItalic, replacementRange: range, selectRange: selectRange)
    }

    // MARK: - Strike

    func strike() {
        if textInRange.contains("~~") {
            unStrike(range: range)
            return
        }
        var selectRange = NSRange(location: range.location + 2, length: 0)
        let length = textInRange.count

        if length != 0 {
            selectRange = NSRange(location: range.location, length: length + 4)
        }

        insertText("~~" + textInRange + "~~", selectRange: selectRange)
    }

    private func unStrike(range: NSRange) {
        let unStrike = textInRange
            .replacingOccurrences(of: "~~", with: "")
        let selectRange = NSRange(location: range.location, length: unStrike.count)
        insertText(unStrike, replacementRange: range, selectRange: selectRange)
    }

    // MARK: - Link

    func link() {
        let text = "[" + textInRange + "]()"
        replaceWith(string: text)

        if textInRange.count == 4 {
            setSelectedRange(NSRange(location: range.location + 1, length: 0))
        } else {
            setSelectedRange(NSRange(location: range.upperBound + 3, length: 0))
        }
    }

    // MARK: - Header

    func header() {
        let headingCharacter = "#"
        // Runestone currently not support get textStorage of whole paragraph,
        // so we have to use UITextPosition to insert at start line.
        textView.replace(left: headingCharacter, right: nil, atLineStart: true)
    }

    // MARK: - List

    func unorderedList() {
        textView.replace(left: "- ", right: nil, atLineStart: true)
    }

    // MARK: - Todo

    func todo() {
        textView.replace(left: "- [ ] ", right: nil, atLineStart: true)
    }

    // MARK: - Code

    func inlineCode() {
        var selectRange = NSRange(location: range.location + 1, length: 0)
        let length = textInRange.count

        if length != 0 {
            selectRange = NSRange(location: range.location, length: length + 2)
        }

        insertText("`" + textInRange + "`", selectRange: selectRange)
    }

    func codeBlock() {
        let currentRange = textView.selectedRange

        if currentRange.length > 0 {
            let subText = textView.text(in: currentRange) ?? ""

            var text = "```\n" + subText

            if subText.last != "\n" {
                text += "\n"
            }

            text += "```\n"

            insertText(text, replacementRange: currentRange)
            setSelectedRange(NSRange(location: currentRange.location + 3, length: 0))
            return
        }

        insertText("```\n\n```\n")
        setSelectedRange(NSRange(location: currentRange.location + 4, length: 0))
    }

    // MARK: - Image
    func insertImageUploadPlaceholder() {
        let currentRange = textView.selectedRange
        let text = "[Uploading image...]"
        insertText(text)
        setSelectedRange(NSRange(location: currentRange.location, length: text.count))
    }

    func insertImage(url: String) {
        replaceWith(string: "")
        insertText("![Image](\(url))")
    }

    // MARK: - Undo/Redo

    func undo() {
        textView.undoManager?.undo()
    }

    func redo() {
        textView.undoManager?.redo()
    }

    // MARK: - Private

    private func insertText(
        _ string: Any,
        replacementRange: NSRange? = nil,
        selectRange: NSRange? = nil
    ) {
        let range = replacementRange ?? textView.selectedRange

        guard let start = textView.position(
            from: textView.beginningOfDocument,
            offset: range.location
        ),
            let end = textView.position(from: start, offset: range.length),
            let selectedRange = textView.textRange(from: start, to: end) else {
            return
        }

        textView.undoManager?.beginUndoGrouping()
        let string = string as? String ?? ""
        textView.replace(selectedRange, withText: string)

        textView.undoManager?.endUndoGrouping()

        if let selectRange = selectRange {
            setSelectedRange(selectRange)
        }
    }

    private func replaceWith(string: String, range: NSRange? = nil) {
        var selectedRange: UITextRange

        if let range = range,
           let start = textView.position(from: textView.beginningOfDocument, offset: range.location),
           let end = textView.position(from: start, offset: range.length),
           let sRange = textView.textRange(from: start, to: end) {
            selectedRange = sRange
        } else {
            selectedRange = textView.selectedTextRange!
        }

        textView.undoManager?.beginUndoGrouping()
        textView.replace(selectedRange, withText: string)
        textView.undoManager?.endUndoGrouping()
    }

    private func setSelectedRange(_ range: NSRange) {
        textView.selectedRange = range
    }
}

private extension TextView {
    private func oneCharRange(pos: UITextPosition?) -> UITextRange? {
        guard let pos = pos,
            let position = self.position(from: pos, offset: 1) else { return nil }
        return self.textRange(from: pos, to: position)
    }

    private func text(atPosition position: UITextPosition?) -> String? {
        guard let position = position,
            let range = oneCharRange(pos: position) else { return nil }
        return text(in: range)
    }

    func startOfLine(forRange range: UITextRange) -> UITextPosition {
        func previousPosition(pos: UITextPosition?) -> UITextPosition? {
            guard let pos = pos else { return nil }
            return self.position(from: pos, offset: -1)
        }

        var position: UITextPosition? =  previousPosition(pos: range.start)
        while let text = text(atPosition: position), text != "\n" { // check if it's the EoL
            position = previousPosition(pos: position) // move back 1 char
        }

        if let position = position, // we have a position
            let pos = self.position(from: position, offset: 1) { // need to advance by one...
            return pos
        }
        return beginningOfDocument // not found? Go to the beginning
    }

    static let cursorToken = ">|<"

    func replace(left: String, right: String?, atLineStart: Bool) {
        guard let range = selectedTextRange else { return }
        let text = text(in: range) ?? "" // no selection = ""

        let replacementText: String
        if atLineStart {
            replacementText = left
        } else {
            replacementText = "\(left)\(text)\(right ?? "")"
        }

        var insertionRange = range
        if atLineStart {
            let startLinePosition = startOfLine(forRange: range)
            insertionRange = textRange(from: startLinePosition, to: startLinePosition) ?? range
        }

        let cursorPosition = (replacementText as NSString).range(of: TextView.cursorToken)
        replace(insertionRange, withText: replacementText.replacingOccurrences(of: TextView.cursorToken, with: ""))

        if range.start == range.end, // single cursor (no selection)
            let position = position(from: range.start, // advance by the inserted before
                offset: left.lengthOfBytes(using: .utf8)) {
            selectedTextRange = textRange(from: position, to: position) // single cursor
        } else if cursorPosition.location != NSNotFound,
            let position = position(from: range.start, // advance by the inserted before
            offset: cursorPosition.location) {
            selectedTextRange = textRange(from: position, to: position) // single cursor {
        }
    }
}
