//
//  MarkdownImageModel.swift
//  GistHub
//
//  Created by Khoa Le on 05/01/2023.
//

import Foundation

final class MarkdownImageModel: BlockNode {
    let url: URL
    let title: String?

    init(url: URL, title: String?) {
        self.url = url
        self.title = title
    }

    var identifier: String {
        "\(url.absoluteString)\(title ?? "")"
    }
}
