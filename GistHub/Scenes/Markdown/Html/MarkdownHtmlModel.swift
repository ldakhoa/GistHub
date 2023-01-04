//
//  MarkdownHtmlModel.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

final class MarkdownHtmlModel: BlockNode {
    let html: String

    init(html: String) {
        self.html = html
    }

    var identifier: String {
        html
    }
}
