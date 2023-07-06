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

public final class MarkdownPreviewViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    private(set) lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollView.delegate = self
        return view
    }()

    private let markdown: String
    private let html = HTML()
    private let mode: Mode

    var scrollPercentage: Float?

    public init(markdown: String, mode: Mode) {
        self.markdown = markdown
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        super.loadView()

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadMarkdown),
            name: .markdownPreviewShouldReload,
            object: nil
        )

        load(markdown: markdown)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
            load(markdown: markdown)
        }
    }

    @objc
    private func load(markdown: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let parsed = Node(markdown: markdown)?.html {
                DispatchQueue.main.async {
                    let interfaceStyle = self.traitCollection.userInterfaceStyle
                    let styledHTML = self.html.getHTML(with: parsed, interfaceStyle: interfaceStyle)
                    self.setContent(with: styledHTML)
                }
            }
        }
    }

    @objc
    private func reloadMarkdown(notification: Notification) {
        guard let content = notification.object as? String else { return }
        load(markdown: content)
    }

    private func setContent(with html: String) {
        let headerHtml = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        webView.loadHTMLString(headerHtml + html, baseURL: nil)
    }

    // MARK: - WKNavigationDelegate

    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction
    ) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url else { return .cancel }

        await UIApplication.shared.open(url)
        return .allow
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight") { (height, _) in
            guard
                let height = height as? Float,
                let scrollPercentage = self.scrollPercentage
            else { return }

            let jsString = """
                window.scrollTo(0, \(height) * \(scrollPercentage));
            """

            webView.evaluateJavaScript(jsString)
        }
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mode == .preview {
            self.scrollPercentage = Float(scrollView.contentOffset.y / scrollView.contentSize.height)
        }
    }
}

extension MarkdownPreviewViewController {
    public enum Mode {
        case preview
        case editPreview
    }
}

public struct MarkdownPreviewView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MarkdownPreviewViewController

    let markdown: String

    public init(markdown: String) {
        self.markdown = markdown
    }

    public func makeUIViewController(context: Context) -> MarkdownPreviewViewController {
        let controller = MarkdownPreviewViewController(markdown: markdown, mode: .preview)
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: MarkdownPreviewViewController,
        context: Context
    ) {
    }
}
