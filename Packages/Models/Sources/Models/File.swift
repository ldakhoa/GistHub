//
//  File.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import Runestone
import TreeSitterAstroRunestone
import TreeSitterBashRunestone
import TreeSitterCRunestone
import TreeSitterCPPRunestone
import TreeSitterCSharpRunestone
import TreeSitterCSSRunestone
import TreeSitterElixirRunestone
import TreeSitterElmRunestone
import TreeSitterGoRunestone
import TreeSitterHaskellRunestone
import TreeSitterHTMLRunestone
import TreeSitterJavaRunestone
import TreeSitterJavaScriptRunestone
import TreeSitterJSDocRunestone
import TreeSitterJSONRunestone
import TreeSitterJSON5Runestone
import TreeSitterJuliaRunestone
import TreeSitterLaTeXRunestone
import TreeSitterLuaRunestone
import TreeSitterMarkdownRunestone
import TreeSitterOCamlRunestone
import TreeSitterPerlRunestone
import TreeSitterPHPRunestone
import TreeSitterPythonRunestone
import TreeSitterRRunestone
import TreeSitterRegexRunestone
import TreeSitterRubyRunestone
import TreeSitterRustRunestone
import TreeSitterSCSSRunestone
import TreeSitterSvelteRunestone
import TreeSitterSwiftRunestone
import TreeSitterTOMLRunestone
import TreeSitterTSXRunestone
import TreeSitterTypeScriptRunestone
import TreeSitterYAMLRunestone

public struct File: Codable, Identifiable, Hashable, Equatable {
    public var id: String {
        rawURL ?? ""
    }

    public let filename: String?
    public let type: String?
    public let language: Language?
    public let rawURL: String?
    public let size: Int?
    public let content: String?

    public init(
        filename: String? = nil,
        type: String? = nil,
        language: Language? = nil,
        rawURL: String? = nil,
        size: Int? = nil,
        content: String? = nil
    ) {
        self.filename = filename
        self.type = type
        self.language = language
        self.rawURL = rawURL
        self.size = size
        self.content = content
    }

    enum CodingKeys: String, CodingKey {
        case filename
        case type
        case language
        case rawURL = "raw_url"
        case size
        case content = "content"
    }
}

extension File {
    public enum Language: String, Codable, Hashable {
        case astro
        case bash = "shell"
        case c
        case cpp = "C++"
        case cSharp = "csharp"
        case css
        case elixir
        case elm
        case go
        case haskell
        case html
        case java
        case javaScript = "javascript"
        case jsdoc
        case json
        case json5
        case julia
        case latex
        case lua
        case markdown
        case ocaml
        case perl
        case php
        case python
        case r
        case regex
        case ruby
        case rust
        case scss
        case svelte
        case swift
        case toml
        case tsx
        case typeScript = "typescript"
        case yaml
        case unknown

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawString = try container.decode(String.self)
            if let language = Language(rawValue: rawString.lowercased()) {
                self = language
            } else if rawString.lowercased() == "md" || rawString.lowercased() == "markdown" {
                self = .markdown
            } else {
                self = .unknown
            }
        }

        public var treeSitterLanguage: TreeSitterLanguage {
            switch self {
            case .astro: return .astro
            case .bash: return .bash
            case .c: return .c
            case .cpp: return .cpp
            case .cSharp: return .cSharp
            case .css: return .css
            case .elixir: return .elixir
            case .elm: return .elm
            case .go: return .go
            case .haskell: return .haskell
            case .html: return .html
            case .java: return .java
            case .javaScript: return .javaScript
            case .jsdoc: return .jsDoc
            case .json: return .json
            case .json5: return .json5
            case .julia: return .julia
            case .latex: return .latex
            case .lua: return .lua
            case .markdown: return .markdown
            case .ocaml: return .ocaml
            case .perl: return .perl
            case .php: return .php
            case .python: return .python
            case .r: return .r
            case .regex: return .regex
            case .ruby: return .ruby
            case .rust: return .rust
            case .scss: return .scss
            case .svelte: return .svelte
            case .swift: return .java
            case .toml: return .toml
            case .tsx: return .tsx
            case .typeScript: return .typeScript
            case .yaml: return .yaml
            default: return .javaScript
            }
        }
    }

}

extension File {
    public static var placeholder: File {
        .init(
            filename: "placeholder.md",
            language: .markdown,
            content: "# Placeholder.md\n## Placeholder.md# Placeholder.md\n## Placeholder.md"
        )
    }

    public static var placeholders: [File] {
        [.placeholder, .placeholder, .placeholder]
    }
}
