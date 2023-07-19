//
//  ImgurAPIClient.swift
//  
//
//  Created by Hung Dao on 16/07/2023.
//

import Foundation
import Networkable
import Models

public protocol ImgurAPIClient {
    /// Upload an image under base64 format to Imgur
    /// - Parameter base64Image: The base64 encoded string of the image
    /// - Returns: Image object which contains the image URL
    func upload(base64Image: String) async throws -> ImgurImage

    func credits() async throws -> ImgurCredits
}

public final class DefaultImgurAPIClient: ImgurAPIClient {
    private let session: NetworkSession

    public init(session: NetworkSession = .imgur) {
        self.session = session
    }

    public func upload(base64Image: String) async throws -> ImgurImage {
        try await session.imgurData(for: API.upload(base64Image: base64Image))
    }

    public func credits() async throws -> ImgurCredits {
        try await session.imgurData(for: API.credits)
    }
}

extension DefaultImgurAPIClient {
    enum Constants {
        static var boundary = UUID().uuidString
    }

    enum API: Request {
        case upload(base64Image: String)
        case credits

        var headers: [String: String]? {
            switch self {
            case .upload:
                return [
                    "Authorization": "Client-ID \(Secrets.Imgur.clientId)",
                    "Content-Type": "multipart/form-data; boundary=\(Constants.boundary)"
                ]
            default:
                return [
                    "Authorization": "Client-ID \(Secrets.Imgur.clientId)"
                ]
            }
        }

        var url: String {
            switch self {
            case .upload:
                return "image"
            case .credits:
                return "credits"
            }
        }

        var method: Networkable.Method {
            switch self {
            case .upload:
                return .post
            case .credits:
                return .get
            }
        }

        func body() throws -> Data? {
            switch self {
            case let .upload(base64Image):
                var data = Data()
                data.appendString("--\(Constants.boundary)\r\n")
                data.appendString("Content-Disposition:form-data; name=\"image\"")
                data.appendString("\r\n\r\n\(base64Image)\r\n")
                data.appendString("--\(Constants.boundary)--\r\n")
                return data
            default:
                return nil
            }
        }
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) else {
            return
        }
        append(data)
    }
}
