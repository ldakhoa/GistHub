//
//  MarkdownViewController.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import StyledTextKit

protocol MarkdownViewControllerDelegate: AnyObject {
    func collectionViewDidUpdateHeight(height: CGFloat)
}

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
        view.register(MarkdownImageCell.self, forCellWithReuseIdentifier: MarkdownImageCell.identifier)
        view.register(MarkdownHrCell.self, forCellWithReuseIdentifier: MarkdownHrCell.identifier)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
        view.contentInset = inset
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private let inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    private static let webViewWidthCache = WidthCache<String, CGSize>()
    private static let imageWidthCache = WidthCache<URL, CGSize>()
    private var currentCollectionHeight: CGFloat = 0

    // MARK: - Dependencies

    private var model: BlockModel!
    private let markdown: String
    private let mode: Mode
    weak var delegate: MarkdownViewControllerDelegate?

    init(markdown: String, mode: Mode) {
        self.markdown = markdown
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        let models = MarkdownModels().build(
            markdown,
            width: 0,
            viewerCanUpdate: true,
            contentSizeCategory: UIApplication.shared.preferredContentSizeCategory,
            userInterfaceStyle: traitCollection.userInterfaceStyle
        )
        self.model = BlockModel(nodes: models)
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

        view.backgroundColor = Colors.MarkdownColorStyle.background
        collectionView.backgroundColor = Colors.MarkdownColorStyle.background

        collectionView.isScrollEnabled = mode == .comment ? false : true
        if mode == .file {
            collectionView.contentInset.top = 16
            collectionView.contentInset.bottom = 16
        }
        self.collectionView.reloadData()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        delegate?.collectionViewDidUpdateHeight(height: height)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection != previousTraitCollection {
            let models = MarkdownModels().build(
                markdown,
                width: 0,
                viewerCanUpdate: true,
                contentSizeCategory: UIApplication.shared.preferredContentSizeCategory,
                userInterfaceStyle: traitCollection.userInterfaceStyle
            )
            self.model = BlockModel(nodes: models)
            self.collectionView.reloadData()
        }
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
        } else if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarkdownImageCell.identifier,
            for: indexPath
        ) as? MarkdownImageCell, let context = model as? MarkdownImageModel {
            cell.configure(with: context)
            cell.heightDelegate = self
            return cell
        } else if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarkdownHrCell.identifier,
            for: indexPath
        ) as? MarkdownHrCell {
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
        } else if let context = model as? MarkdownImageModel {
            let width = collectionView.bounds.width - inset.left - inset.right
            guard let size = MarkdownViewController.imageWidthCache.data(key: context.url, width: 0) else {
                return CGSize(width: width, height: 200)
            }
            let height = BoundedImageSize(originalSize: size, containerWidth: width).height

            return CGSize(
                width: width,
                height: height
            )
        } else if model is MarkdownHrModel {
            let width = collectionView.bounds.width - inset.left - inset.right
            return CGSize(width: width, height: 30.0 + MarkdownHrCell.inset.top + MarkdownHrCell.inset.bottom)
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
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    func webViewDidTapImage(url: URL) {

    }

    func webViewWantsNavigate(url: URL) {

    }
}

// MARK: - MarkdownImageHeightCellDelegate

extension MarkdownViewController: MarkdownImageHeightCellDelegate {
    func imageDidFinishLoad(url: URL, size: CGSize) {
        guard size != MarkdownViewController.imageWidthCache.data(key: url, width: 0) else { return }
        MarkdownViewController.imageWidthCache.set(data: size, key: url, width: 0)

        UIView.performWithoutAnimation {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
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

extension MarkdownViewController {
    public enum Mode {
        case comment
        case file
    }
}

import SwiftUI

public struct MarkdownUI: UIViewControllerRepresentable {

    let markdown: String
    let markdownHeight: Binding<CGFloat>?
    let mode: MarkdownViewController.Mode

    init(
        markdown: String,
        markdownHeight: Binding<CGFloat>? = nil,
        mode: MarkdownViewController.Mode = .file
    ) {
        self.markdown = markdown
        self.markdownHeight = markdownHeight
        self.mode = mode
    }

    public typealias UIViewControllerType = MarkdownViewController

    public func makeUIViewController(context: Context) -> MarkdownViewController {
        let viewController = MarkdownViewController(markdown: markdown, mode: mode)
        viewController.delegate = context.coordinator

        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: MarkdownViewController,
        context: Context
    ) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(markdownHeight: markdownHeight)
    }

    public class Coordinator: MarkdownViewControllerDelegate {
        let markdownHeight: Binding<CGFloat>?

        init(markdownHeight: Binding<CGFloat>?) {
            self.markdownHeight = markdownHeight
        }

        func collectionViewDidUpdateHeight(height: CGFloat) {
            markdownHeight?.wrappedValue = height
        }
    }
}
