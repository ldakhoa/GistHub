//
//  MarkdownHtmlCell.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import UIKit
import WebKit
import DesignSystem

protocol MarkdownHtmlCellDelegate: AnyObject {
    func webViewDidResize(cell: MarkdownHtmlCell, html: String, cellWidth: CGFloat, size: CGSize)
}

protocol MarkdownHtmlCellNavigationDelegate: AnyObject {
    func webViewWantsNavigate(url: URL)

}

protocol MarkdownHtmlCellImageDelegate: AnyObject {
    func webViewDidTapImage(url: URL)
}

private final class MarkdownHtmlCellWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets {
        .zero
    }
}

final class MarkdownHtmlCell: UICollectionViewCell, WKNavigationDelegate {
    static let identifier = "MarkdownHtmlCell"

    private static let imgScheme = "freetime-img"
    private static let heightScheme = "freetime-hgt"
    private static let javaScriptHeight = "offsetHeight"
    private let webView = MarkdownHtmlCellWebView()
    private var body = ""

    private let htmlHead = """
    <!DOCTYPE html><html><head><style>
    * {margin: 0;padding: 0;}
    body{
    // html whitelist: https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/sanitization_filter.rb#L45-L49
    // lint compiled style with http://csslint.net/
    font-family: -apple-system; font-size: \(MarkdownText.body.preferredFont.pointSize)px;
    color: \(Colors.MarkdownColorStyle.foreground.hexString);
    padding: \(MarkdownSizes.columnSpacing)px 0 0;
    margin: 0;
    background-color: \(Colors.MarkdownColorStyle.background.hexString);
    }
    * { font-family: -apple-system; font-size: \(MarkdownText.body.preferredFont.pointSize)px; }
    b, strong{font-weight: 600;}
    i, em{font-style: italic;}
    a{color: \(Colors.MarkdownColorStyle.accentForeground.hexString); text-decoration: none;}
    h1{font-size: \(MarkdownText.h1.preferredFont.pointSize)px;}
    h2{font-size: \(MarkdownText.h2.preferredFont.pointSize)px;}
    h3{font-size: \(MarkdownText.h3.preferredFont.pointSize)px;}
    h4{font-size: \(MarkdownText.h4.preferredFont.pointSize)px;}
    h5{font-size: \(MarkdownText.h5.preferredFont.pointSize)px;}
    h6, h7, h8{font-size: \(MarkdownText.h6.preferredFont.pointSize)px; color: \(Colors.MarkdownColorStyle.foreground.hexString);}
    dl dt{margin-top: 16px; font-style: italic; font-weight: 600;}
    dl dd{padding: 0 16px;}
    blockquote{font-style: italic; color: \(Colors.MarkdownColorStyle.mutedForeground.hexString);}
    pre, code{background-color: \(Colors.MarkdownColorStyle.canvasSubtle.hexString); font-family: Courier;}
    pre{padding: \(MarkdownSizes.columnSpacing)px 0;}
    sub{font-size: \(MarkdownText.secondary.preferredFont.pointSize)px;}
    sub a{font-size: \(MarkdownText.secondary.preferredFont.pointSize)px;}
    table{border-spacing: 0; border-collapse: collapse;}
    th, td{border: 1px solid #\(Colors.border.hexString); padding: 6px 13px;}
    th{font-weight: 600; text-align: center;}
    img{max-width:100%; box-sizing: border-box; max-height: 300px; object-fit: contain;}
    hr{border: 1.5px solid \(Colors.border.hexString);}
    </style>
    </head><body>
    """
    private let htmlTail = """
    <script>
        document.documentElement.style.webkitUserSelect='none';
        document.documentElement.style.webkitTouchCallout='none';
        var tapAction = function(e) {
            document.location = "\(imgScheme)://" + encodeURIComponent(e.target.src);
        };
        function removeRootPath(img) {
            var src = img.getAttribute('src');
            if(src.length > 1 && src.indexOf('/') === 0) {
                img.src = src.substring(1, src.length);
            }
        }
        var imgs = document.getElementsByTagName('img');
        for (var i = 0; i < imgs.length; i++) {
            imgs[i].addEventListener('click', tapAction);
            removeRootPath(imgs[i]);
        }
        function onElementHeightChange(elm, callback) {
            var lastHeight = elm.\(MarkdownHtmlCell.javaScriptHeight), newHeight;
            (function run() {
                newHeight = elm.\(MarkdownHtmlCell.javaScriptHeight);
                if(lastHeight != newHeight) {
                    callback(newHeight);
                }
                lastHeight = newHeight;
                if(elm.onElementHeightChangeTimer) {
                    clearTimeout(elm.onElementHeightChangeTimer);
                }
                elm.onElementHeightChangeTimer = setTimeout(run, 300);
            })();
        }
        onElementHeightChange(document.body, function(height) {
            document.location = "\(heightScheme)://" + height;
        });
    </script>
    </body>
    </html>
    """

    weak var delegate: MarkdownHtmlCellDelegate?
    weak var navigationDelegate: MarkdownHtmlCellNavigationDelegate?
    weak var imageDelegate: MarkdownHtmlCellImageDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        // https://stackoverflow.com/a/23427923
        webView.isOpaque = false
        webView.backgroundColor = .clear

        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false

        let scrollView = webView.scrollView
        scrollView.scrollsToTop = false
        scrollView.bounces = true

        contentView.addSubview(webView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        webView.alpha = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if webView.frame != contentView.bounds {
            webView.frame = contentView.bounds
        }
    }

    func configure(with model: MarkdownHtmlModel) {
        body = model.html

        let header = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        let html = htmlHead + header + body + htmlTail
        webView.loadHTMLString(html, baseURL: nil)
    }

    func update(height: CGFloat) {
        guard isHidden == false, height != bounds.height else { return }
        let size = CGSize(width: contentView.bounds.width, height: height)
        delegate?.webViewDidResize(cell: self, html: body, cellWidth: size.width, size: size)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        guard isHidden == false, let url = navigationAction.request.url else { return .allow }

        if url.scheme == MarkdownHtmlCell.imgScheme,
           let host = url.host,
           let imageURL = URL(string: host) {
            imageDelegate?.webViewDidTapImage(url: imageURL)
            return .cancel
        } else if url.scheme == MarkdownHtmlCell.heightScheme,
                  let heightString = url.host as NSString? {
            update(height: CGFloat(heightString.floatValue))
            return .cancel
        }

        let htmlLoad = url.absoluteString == "about:blank"

        if !htmlLoad {
            navigationDelegate?.webViewWantsNavigate(url: url)
        }

        return htmlLoad ? .allow : .cancel
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.alpha = 1

        webView.evaluateJavaScript("document.body.\(MarkdownHtmlCell.javaScriptHeight)") { (height, error) in
            if let error = error {
                print("Failed to evaluate js \(error.localizedDescription)")
                return
            }

            if let height = height as? CGFloat {
                self.update(height: height)
            }
        }
    }
}
