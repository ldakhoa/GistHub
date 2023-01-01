//
//  MarkdownPreviewViewController.swift
//  GistHub
//
//  Created by Khoa Le on 01/01/2023.
//

import UIKit
import WebKit
import cmark_gfm_swift
import SwiftUI

final class MarkdownPreviewViewController: UIViewController, WKNavigationDelegate {

    private(set) lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let markdown: String

    init(markdown: String) {
        self.markdown = markdown
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        load(markdown: markdown)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            load(markdown: markdown)
        }
    }

    private func load(markdown: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let parsed = Node(markdown: markdown)?.html {
                DispatchQueue.main.async {
                    let styledHTML = HTML.shared.getHTML(with: parsed)
                    self.setContent(with: styledHTML)
                }
            }
        }
    }

    private func setContent(with html: String) {
        let headerHtml = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        webView.loadHTMLString(headerHtml + html, baseURL: nil)
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url else { return .cancel }

        await UIApplication.shared.open(url)
        return .allow
    }
}

struct MarkdownPreviewView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MarkdownPreviewViewController

    let markdown: String

    init(markdown: String) {
        self.markdown = markdown
    }

    func makeUIViewController(context: Context) -> MarkdownPreviewViewController {
        let controller = MarkdownPreviewViewController(markdown: markdown)
        return controller
    }

    func updateUIViewController(
        _ uiViewController: MarkdownPreviewViewController,
        context: Context
    ) {
    }
}
