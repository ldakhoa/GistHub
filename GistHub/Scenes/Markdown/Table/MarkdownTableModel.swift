//
//  MarkdownTableModel.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import Foundation
import StyledTextKit

final class MarkdownTableModel: NSObject, BlockNode {
    final class Row {
        let string: StyledTextRenderer
        let fill: Bool

        init(string: StyledTextRenderer, fill: Bool) {
            self.string = string
            self.fill = fill
        }
    }

    final class Column {
        let width: CGFloat
        let rows: [Row]

        init(width: CGFloat, rows: [Row]) {
            self.width = width
            self.rows = rows
        }
    }

    let columns: [Column]
    let rowHeights: [CGFloat]
    let size: CGSize

    init(columns: [Column], rowHeights: [CGFloat]) {
        self.columns = columns
        self.rowHeights = rowHeights

        let inset = MarkdownTableCell.inset
        self.size = CGSize(
            width: columns.reduce(0) { $0 + $1.width } + inset.left + inset.right,
            height: rowHeights.reduce(0) { $0 + $1 } + inset.top + inset.bottom
        )
    }

    convenience init(buckets: [TableBucket], rowHeights: [CGFloat]) {
        self.init(
            columns: buckets.map { MarkdownTableModel.Column(width: $0.maxWidth, rows: $0.rows) },
            rowHeights: rowHeights
        )
    }

    var identifier: String {
        description
    }
}
