//
//  MarkdownTextCell.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit

final class MarkdownTextCell: UICollectionViewCell {
    static let identifier = "MarkdownTextCell"

    static func inset(isLast: Bool) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 2,
            left: 0,
            bottom: isLast ? 0 : MarkdownSizes.rowSpacing,
            right: 0
        )
    }

    let textView = MarkdownStyledTextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.gesturableAttributes = MarkdownAttribute.all
        contentView.addSubview(textView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textView.reposition(for: contentView.bounds.width)
    }

    func configure(with model: StyledTextRenderer) {
        textView.configure(with: model, width: contentView.bounds.width)
    }
}
