//
//  UIImage+Extensions.swift
//  GistHub
//
//  Created by Khoa Le on 23/12/2022.
//

import UIKit

extension UIImage {
    public func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        return newImage!
    }

    /// Compressed and Encodes in Base64 the given image.
    public func compressAndEncode(compression: CGFloat = 0.65) async throws -> String {
        let task = Task(priority: .background) {
            guard let data = self.jpegData(compressionQuality: compression) else {
                throw CompressionError()
            }
            return data
        }
        let result = try await task.value
        return result.base64EncodedString()
    }
}

struct CompressionError: LocalizedError {
    var errorDescription: String? {
        return "Error compressing image"
    }
}
