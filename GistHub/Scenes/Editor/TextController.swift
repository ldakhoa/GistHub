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

        if textInRange.count == 5 {
            setSelectedRange(NSRange(location: range.location + 2, length: 0))
        } else {
            setSelectedRange(NSRange(location: range.upperBound + 3, length: 0))
        }
    }

    // MARK: - Header

    // MARK: - List

    // MARK: - Todo

    // MARK: - Code

    // MARK: - Undo/Redo

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
