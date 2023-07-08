//
//  MarkdownQuoteCell.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import DesignSystem

final class MarkdownQuoteCell: UICollectionViewCell {
    static let identifier = "MarkdownQuoteCell"

    static let borderWidth: CGFloat = 2
    static func inset(quoteLevel: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: (MarkdownQuoteCell.borderWidth + MarkdownSizes.columnSpacing) * CGFloat(quoteLevel),
            bottom: MarkdownSizes.rowSpacing,
            right: 0)
    }

    let textView = MarkdownStyledTextView()
    private var borders = [UIView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textView.reposition(for: contentView.bounds.width)
        for (i, border) in borders.enumerated() {
            border.frame = CGRect(
                x: (MarkdownQuoteCell.borderWidth + MarkdownSizes.columnSpacing) * CGFloat(i),
                y: 0,
                width: MarkdownQuoteCell.borderWidth,
                height: contentView.bounds.height - MarkdownSizes.rowSpacing
            )
        }
    }

    func configure(with model: MarkdownQuoteModel) {
        for border in borders {
            border.removeFromSuperview()
        }

        borders.removeAll()

        for _ in 0 ..< model.level {
            let border = UIView()
            border.backgroundColor = Colors.MarkdownColorStyle.mutedForeground
            contentView.addSubview(border)
            borders.append(border)
        }
        textView.configure(with: model.string, width: contentView.bounds.width)
        setNeedsLayout()
    }
}
