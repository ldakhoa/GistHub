//
//  MarkdownTableCollectionCell.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit

final class MarkdownTableCollectionCell: UICollectionViewCell {
    static let identifier = "MarkdownTableCollectionCell"
    static let inset = UIEdgeInsets(
        top: MarkdownSizes.rowSpacing,
        left: MarkdownSizes.columnSpacing,
        bottom: MarkdownSizes.rowSpacing,
        right: MarkdownSizes.columnSpacing
    )

    let textView = MarkdownStyledTextView()

    var bottomBorder: UIView?
    var rightBorder: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(textView)
        contentView.addBorder(.left)
        contentView.addBorder(.top)

        bottomBorder = contentView.addBorder(.bottom)
        rightBorder = contentView.addBorder(.right)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ model: StyledTextRenderer) {
        textView.configure(with: model, width: 0)
    }

    func setRightBorder(visible: Bool) {
        rightBorder?.isHidden = !visible
    }

    func setBottomBorder(visible: Bool) {
        bottomBorder?.isHidden = !visible
    }
}

private extension UIView {
    enum Position {
        case left, top, right, bottom
    }

    @discardableResult
    func addBorder(_ position: Position) -> UIView {
        let view = UIView()
        view.backgroundColor = Colors.border
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let size = 1.0

        switch position {
        case .top, .bottom:
            NSLayoutConstraint.activate([
                view.heightAnchor.constraint(equalToConstant: size),
                view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
            ])
        case .left, .right:
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: size),
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

        switch position {
        case .top:
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        case .bottom:
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        case .left:
            view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        case .right:
            view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }

        return view
    }

}
