//
//  MarkdownTableCell.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import DesignSystem

final class MarkdownTableCell: UICollectionViewCell,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {

    static let identifier = "MarkdownTableCell"
    static let inset = UIEdgeInsets(
        top: 0,
        left: MarkdownSizes.rowSpacing / 2,
        bottom: MarkdownSizes.rowSpacing,
        right: MarkdownSizes.rowSpacing / 2
    )

    weak var delegate: MarkdownStyledTextViewDelegate?
    private var model: MarkdownTableModel?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView.register(MarkdownTableCollectionCell.self, forCellWithReuseIdentifier: MarkdownTableCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Colors.MarkdownColorStyle.background
        collectionView.isPrefetchingEnabled = false
        collectionView.contentInset = MarkdownTableCell.inset
        contentView.addSubview(collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let model = model {
            collectionView.frame = CGRect(
                x: 0,
                y: 0,
                width: bounds.width,
                height: model.size.height
            )
        }
    }

    func configure(with model: MarkdownTableModel) {
        self.model = model
        self.collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        model?.columns.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.columns[section].rows.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarkdownTableCollectionCell.identifier,
                for: indexPath
            ) as? MarkdownTableCollectionCell,
            let columns = model?.columns
        else {
            fatalError("Cell is wrong type or missing model")
        }

        let column = columns[indexPath.section]
        let rows = column.rows
        let row = rows[indexPath.item]
        cell.configure(row.string)
        cell.textView.tapDelegate = delegate
        cell.setRightBorder(visible: columns.last === column)
        cell.setBottomBorder(visible: rows.last === row)

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let model = model else { fatalError("Missing model") }
        return CGSize(
            width: model.columns[indexPath.section].width,
            height: model.rowHeights[indexPath.item]
        )
    }
}
