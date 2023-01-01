//
//  HTML.swift
//  GistHub
//
//  Created by Khoa Le on 01/01/2023.
//

import Foundation

final class HTML {
    static let shared = HTML()

    var js: String = ""
    var baseCSS: String = ""
    var css: String = ""

    private init() {
        loadCSS()
        loadJS()
    }

    public func getHTML(with contents: String) -> String {
        return """
              <!DOCTYPE html>
              <html>
              <head>
                <style>
                \(baseCSS)
                \(css)
                  html, body { background: #ffffff; }
                  code { background: #f6f8fa !important }
                  p, h1, h2, h3, h4, h5, h6, ul, ol, dl, li, table, tr { color: #24292f; }
                  table tr { background: #f6f8fa; }
                  table tr:nth-child(2n) { background: #ffffff; }
                  table tr th, table tr td { border-color: #d0d7de }
                </style>
                <script>\(js)</script>
                <script>hljs.initHighlightingOnLoad();</script>

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.10.0-rc/katex.min.css">
                <script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.10.0-rc/katex.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.10.0-rc/contrib/auto-render.min.js"></script>
              </head>
              <body>
                \(contents)

                <div>
                  <script>
                    window.scrollTo(0, 0);
                  </script>
                  <script>
                    renderMathInElement(document.body, {delimiters: [
                      {left: "$$", right: "$$", display: true},
                      {left: "$", right: "$", display: false},
                    ]});
                  </script>
                </div>
              </body>
              </html>
        """
    }

    private func loadJS() {
        guard
            let jsFile = Bundle.main.path(forResource: "highlight", ofType: "js"),
            let jsResult = try? String(contentsOf: URL(fileURLWithPath: jsFile), encoding: .utf8)
        else { return }

        js = jsResult
    }

    private func loadCSS() {
        guard
            let cssFile = Bundle.main.path(forResource: "markdown", ofType: "css"),
            let cssContents = try? String(contentsOf: URL(fileURLWithPath: cssFile), encoding: .utf8),
            let cssThemeFile = Bundle.main.path(forResource: "github", ofType: "css"),
            let cssThemeContents = try? String(contentsOf: URL(fileURLWithPath: cssThemeFile), encoding: .utf8)
        else { return }

        baseCSS = cssContents
        css = cssThemeContents
    }

}
