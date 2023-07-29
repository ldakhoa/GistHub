//
//  MarkdownQuoteModel.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import Foundation
import StyledTextKit

final class MarkdownQuoteModel: BlockNode {
    var identifier: String {
        _identifier
    }

    private let _identifier: String
    let level: Int
    let string: StyledTextRenderer

    init(level: Int, string: StyledTextRenderer) {
        self.level = level
        self.string = string
        self._identifier = "\(string.string.hashValue)"
    }
}
