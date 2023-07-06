//
//  BoundedImageSize.swift
//  GistHub
//
//  Created by Khoa Le on 05/01/2023.
//

import Foundation

func BoundedImageSize(originalSize: CGSize, containerWidth: CGFloat) -> CGSize {
    guard originalSize.width > containerWidth else {
        return CGSize(
            width: containerWidth,
            height: min(originalSize.height, MarkdownSizes.maxImageHeight)
        )
    }
    let ratio = originalSize.width / originalSize.height
    return CGSize(
        width: containerWidth,
        height: min(ceil(containerWidth / ratio), MarkdownSizes.maxImageHeight)
    )
}
