//
//  MarkdownCodeBlockCell.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit

final class MarkdownCodeBlockCell: UICollectionViewCell {
    static let identifier = "MarkdownCodeBlockCell"
    static let scrollViewInset = UIEdgeInsets(
        top: MarkdownSizes.rowSpacing,
        left: 0,
        bottom: MarkdownSizes.rowSpacing,
        right: 0
    )

    static let textViewInset = UIEdgeInsets(
        top: MarkdownSizes.rowSpacing,
        left: MarkdownSizes.columnSpacing,
        bottom: MarkdownSizes.rowSpacing,
        right: MarkdownSizes.columnSpacing
    )

    let textView = StyledTextView()
    let scrollView = UIScrollView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // make didSelectItem work for the cell
        // https://stackoverflow.com/a/24853578/940936

        scrollView.isUserInteractionEnabled = false
        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        scrollView.backgroundColor = Colors.MarkdownColorStyle.canvasSubtle

        contentView.addSubview(scrollView)
        scrollView.addSubview(textView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // size the scrollview to the width of the cell but match its height to its content size
        // that way when the cell is collapsed, the scroll view isn't vertically scrollable
        let inset = MarkdownCodeBlockCell.scrollViewInset
        scrollView.frame = CGRect(
            x: inset.left,
            y: inset.top,
            width: contentView.bounds.width - inset.left - inset.right,
            height: scrollView.contentSize.height
        )
    }

    func configure(with model: MarkdownCodeBlockModel) {
        let contentSize = model.contentSize
        scrollView.contentSize = contentSize
        textView.configure(with: model.code, width: 0)
    }
}

