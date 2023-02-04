//
//  MarkdownStyledTextView.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import StyledTextKit
import UIKit

protocol MarkdownStyledTextViewDelegate: AnyObject {
    func didTap(cell: MarkdownStyledTextView, attribute: MarkdownAttributeHandling)
}

class MarkdownStyledTextView: StyledTextView, StyledTextViewDelegate {
    weak var tapDelegate: MarkdownStyledTextViewDelegate?

    override var delegate: StyledTextViewDelegate? {
        get { return self }
        set {}
    }

    func didTap(
        view: StyledTextKit.StyledTextView,
        attributes: StyledTextKit.NSAttributedStringAttributesType,
        point: CGPoint
    ) {
        guard let handler = MarkdownAttributeHandling.make(attributes: attributes) else { return }
        tapDelegate?.didTap(cell: self, attribute: handler)
    }

    func didLongPress(view: StyledTextKit.StyledTextView, attributes: StyledTextKit.NSAttributedStringAttributesType, point: CGPoint) {

    }
}
