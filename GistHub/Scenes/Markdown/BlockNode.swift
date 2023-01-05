//
//  BlockNode.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import Foundation
import StyledTextKit

protocol BlockNode {
    var identifier: String { get }
}

final class BlockModel {
    let nodes: [BlockNode]

    init(nodes: [BlockNode]) {
        self.nodes = nodes
    }
}

extension StyledTextRenderer: BlockNode {
    public var identifier: String {
        "\(self.string.hashValue)"
    }
}
