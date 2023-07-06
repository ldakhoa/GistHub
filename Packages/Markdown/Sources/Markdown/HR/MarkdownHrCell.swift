//
//  MarkdownHrCell.swift
//  GistHub
//
//  Created by Khoa Le on 05/01/2023.
//

import UIKit

final class MarkdownHrCell: UICollectionViewCell {
    static let identifier = "MarkdownHrCell"

//    static let inset = UIEdgeInsets(
//        top: 0,
//        left: 0,
//        bottom: MarkdownSizes.rowSpacing,
//        right: MarkdownSizes.columnSpacing
//    )

    private let hr = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        hr.translatesAutoresizingMaskIntoConstraints = false
        hr.backgroundColor = Colors.border
        contentView.addSubview(hr)
        NSLayoutConstraint.activate([
            hr.topAnchor.constraint(equalTo: contentView.topAnchor),
            hr.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hr.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hr.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
