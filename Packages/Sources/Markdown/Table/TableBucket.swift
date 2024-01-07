//
//  TableBucket.swift
//  GistHub
//
//  Created by Khoa Le on 04/01/2023.
//

import Foundation
import StyledTextKit

final class TableBucket {
    var rows = [MarkdownTableModel.Row]()
    var maxWidth: CGFloat = 0
    var maxHeight: CGFloat = 0
}

func fillBuckets(
    rows: [StyledTextRenderer],
    buckets: inout [TableBucket],
    rowHeights: inout [CGFloat],
    fill: Bool
) {
    var maxHeight: CGFloat = 0

    // prepopulate the buckets in case
    while buckets.count < rows.count {
        buckets.append(TableBucket())
    }

    // move text models from a row collection and place into column

    for (i, cell) in rows.enumerated() {
        let bucket = buckets[i]
        bucket.rows.append(MarkdownTableModel.Row(string: cell, fill: fill))

        // adjust the max width of each column using whatever is the largest so all cells are the same width
        let size = cell.viewSize(in: 0)
        bucket.maxWidth = max(bucket.maxWidth, size.width)
        maxHeight = max(maxHeight, size.height)
    }

    rowHeights.append(ceil(maxHeight))
}
