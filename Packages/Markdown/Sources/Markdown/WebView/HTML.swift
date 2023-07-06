//
//  HTML.swift
//  GistHub
//
//  Created by Khoa Le on 01/01/2023.
//

import UIKit
import DesignSystem

final class HTML {
    private var js: String = ""
    private var baseCSS: String = ""
    private var css: String = ""

    init() {}

    public func getHTML(with contents: String, interfaceStyle: UIUserInterfaceStyle) -> String {
        loadCSS(interfaceStyle: interfaceStyle)
        loadJS()

        return """
              <!DOCTYPE html>
              <html>
              <head>
                <style>
                \(baseCSS)
                \(css)
                  html, body { background: \(Colors.background.hexString); }
                  code { background: \(Colors.codeBackground.hexString) !important }
                  p, h1, h2, h3, h4, h5, h6, ul, ol, dl, li, table, tr { color: \(Colors.text.hexString); }
                  table tr { background: \(Colors.background.hexString); }
                  table tr:nth-child(2n) { background: #ffffff; }
                  table tr th, table tr td { border-color: \(Colors.border.hexString) }
                </style>
                <script>\(js)</script>
                <script>hljs.initHighlightingOnLoad();</script>

                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.10.0-rc/katex.min.css">
                <script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.10.0-rc/katex.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.10.0-rc/contrib/auto-render.min.js"></script>
              </head>
              <body>
                \(contents.replacingOccurrences(of: "class=\"language-objective-c", with: "class=\"language-objectivec"))

                <div>
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

    private func loadCSS(interfaceStyle: UIUserInterfaceStyle) {
        guard
            let cssFile = Bundle.main.path(forResource: "markdown", ofType: "css"),
            let cssContents = try? String(contentsOf: URL(fileURLWithPath: cssFile), encoding: .utf8),
            let cssThemeFile = Bundle.main.path(
                forResource: interfaceStyle == .light ? "github" : "github-dark-dimmed",
                ofType: "css"),
            let cssThemeContents = try? String(contentsOf: URL(fileURLWithPath: cssThemeFile), encoding: .utf8)
        else { return }

        baseCSS = cssContents
        css = cssThemeContents
    }

}

private extension Colors {
    static let background = UIColor(light: .white, dark: Colors.Palette.Gray.gray9.dark)
    static let codeBackground = UIColor(light: Colors.Palette.Gray.gray0.light, dark: Colors.Palette.Gray.gray8.dark)
    static let text = UIColor(light: Colors.Palette.Gray.gray9.light, dark: Colors.Palette.Gray.gray1.dark)
}
