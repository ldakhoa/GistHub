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

struct File: Codable, Identifiable, Hashable {
    var id: String {
        rawURL ?? ""
    }

    let filename: String?
    let type: String?
    let language: Language?
    let rawURL: String?
    let size: Int?
    let content: String?

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
    enum Language: String, Codable {
        case astro
        case bash = "shell"
        case c
        case cpp = "C++"
        case cSharp
        case css
        case elixir
        case elm
        case go
        case haskell
        case html
        case java
        case javaScript
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
        case swift = "TypeScript" // Since swift syntax highlighting currently slow to render, improve later
        case toml
        case tsx
        case typeScript
        case yaml
        case unknown

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawString = try container.decode(String.self)
            if let language = Language(rawValue: rawString.lowercased()) {
                self = language
            } else {
                self = .unknown
            }
        }

        var treeSitterLanguage: TreeSitterLanguage {
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
            case .swift: return .swift
            case .toml: return .toml
            case .tsx: return .tsx
            case .typeScript: return .typeScript
            case .yaml: return .yaml
            default: return .javaScript
            }
        }
    }

}
