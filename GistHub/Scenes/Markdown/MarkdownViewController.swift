//
//  MarkdownViewController.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit

public final class MarkdownViewController: UIViewController {
    // MARK: - UIs

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MarkdownTextCell.self, forCellWithReuseIdentifier: MarkdownTextCell.identifier)
        view.register(MarkdownQuoteCell.self, forCellWithReuseIdentifier: MarkdownQuoteCell.identifier)
        view.register(MarkdownCodeBlockCell.self, forCellWithReuseIdentifier: MarkdownCodeBlockCell.identifier)
        view.register(MarkdownHtmlCell.self, forCellWithReuseIdentifier: MarkdownHtmlCell.identifier)
        view.register(MarkdownTableCell.self, forCellWithReuseIdentifier: MarkdownTableCell.identifier)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        view.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private let inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    private static let webViewWidthCache = WidthCache<String, CGSize>()

    // MARK: - Dependencies

    private let model: BlockModel
    private let markdown: String

    public init(markdown: String) {
        self.markdown = markdown
        let models = MarkdownModels().build(
            markdown,
            width: 0,
            viewerCanUpdate: true,
            contentSizeCategory: UIApplication.shared.preferredContentSizeCategory
        )
        self.model = BlockModel(nodes: models)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Initializer

    public override func loadView() {
        super.loadView()

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        self.collectionView.reloadData()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}

// MARK: - UITableViewDataSource, UICollectionViewDelegateFlowLayout

extension MarkdownViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        model.nodes.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let model = model.nodes[indexPath.row]

        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarkdownTextCell.identifier,
            for: indexPath
        ) as? MarkdownTextCell,
           let context = model as? StyledTextRenderer {
            cell.configure(with: context)
            cell.textView.tapDelegate = self
            return cell
        } else if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarkdownQuoteCell.identifier,
            for: indexPath
        ) as? MarkdownQuoteCell, let context = model as? MarkdownQuoteModel {
            cell.configure(with: context)
            cell.textView.tapDelegate = self
            return cell
        } else if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarkdownCodeBlockCell.identifier,
            for: indexPath
        ) as? MarkdownCodeBlockCell, let context = model as? MarkdownCodeBlockModel {
            cell.configure(with: context)
            return cell
        } else if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarkdownHtmlCell.identifier,
            for: indexPath
        ) as? MarkdownHtmlCell, let context = model as? MarkdownHtmlModel {
            cell.delegate = self
            cell.navigationDelegate = self
            cell.imageDelegate = self
            cell.configure(with: context)
            return cell
        } else if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarkdownTableCell.identifier,
            for: indexPath
        ) as? MarkdownTableCell, let context = model as? MarkdownTableModel {
            cell.configure(with: context)
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let model = model.nodes[indexPath.row]

        if let context = model as? StyledTextRenderer {
            let width = collectionView.bounds.width - inset.left - inset.right
            return CGSize(
                width: width,
                height: context.viewSize(in: width).height)
        } else if let context = model as? MarkdownQuoteModel {
            let width = collectionView.bounds.width - inset.left - inset.right
            return CGSize(
                width: width,
                height: context.string.viewSize(in: width).height
            )
        } else if let context = model as? MarkdownCodeBlockModel {
            let width = collectionView.bounds.width - inset.left - inset.right
            let inset = MarkdownCodeBlockCell.scrollViewInset
            return CGSize(
                width: width,
                height: context.contentSize.height + inset.top + inset.bottom
            )
        } else if let context = model as? MarkdownHtmlModel {
            let width = collectionView.bounds.width - inset.left - inset.right
            let height = MarkdownViewController.webViewWidthCache.data(key: context.html, width: width)?.height ?? 44

            return CGSize(
                width: width,
                height: height
            )
        } else if let context = model as? MarkdownTableModel {
            let width = collectionView.bounds.width - inset.left - inset.right
            return CGSize(
                width: width,
                height: context.size.height
            )
        }

        return CGSize(width: collectionView.bounds.width, height: 200)
    }
}

// MARK: - MarkdownHtmlCellDelegate, MarkdownHtmlCellImageDelegate, MarkdownHtmlCellNavigationDelegate

extension MarkdownViewController: MarkdownHtmlCellDelegate,
                                  MarkdownHtmlCellImageDelegate,
                                  MarkdownHtmlCellNavigationDelegate {

    func webViewDidResize(cell: MarkdownHtmlCell, html: String, cellWidth: CGFloat, size: CGSize) {
        guard size != MarkdownViewController.webViewWidthCache.data(key: html, width: cellWidth) else { return }
        MarkdownViewController.webViewWidthCache.set(data: size, key: html, width: cellWidth)

        UIView.performWithoutAnimation {
            self.collectionView.invalidateIntrinsicContentSize()
        }
    }

    func webViewDidTapImage(url: URL) {

    }

    func webViewWantsNavigate(url: URL) {

    }
}

// MARK: - MarkdownStyledTextViewDelegate

extension MarkdownViewController: MarkdownStyledTextViewDelegate {
    func didTap(cell: MarkdownStyledTextView, attribute: MarkdownAttributeHandling) {
        switch attribute {
        case .url(let url):
            guard UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        case .email(let email):
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        case .checkbox:
            break
        }
    }
}
