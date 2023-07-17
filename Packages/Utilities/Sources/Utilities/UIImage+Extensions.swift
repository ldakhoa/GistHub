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
        let data: Data = try await withCheckedThrowingContinuation { continuation in
            guard let result = self.jpegData(compressionQuality: compression) else {
                continuation.resume(throwing: CompressionError())
                return
            }
            continuation.resume(returning: result)
        }
        return data.base64EncodedString()
    }
}

struct CompressionError: LocalizedError {
    var errorDescription: String? {
        return "Error compressing image"
    }
}
