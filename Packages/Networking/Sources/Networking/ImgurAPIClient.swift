//
//  ImgurAPIClient.swift
//  
//
//  Created by Hung Dao on 16/07/2023.
//

import Foundation
import Networkable
import Models
import Environment

public protocol ImgurAPIClient {
    func upload(base64Image: String) async throws -> ImgurImage
}

public final class DefaultImgurAPIClient: ImgurAPIClient {
    private let session: NetworkSession

    public init(session: NetworkSession = .imgur) {
        self.session = session
    }

    public func upload(base64Image: String) async throws -> ImgurImage {
        try await session.data(for: API.upload(base64Image: base64Image))
    }
}

extension DefaultImgurAPIClient {
    enum Constants {
        static var boundary = UUID().uuidString
    }
    enum API: Request {
        case upload(base64Image: String)
        var headers: [String: String]? {
            return [
                "Authorization": "Client-ID \(Secrets.Imgur.clientId)",
                "Content-Type": "multipart/form-data; boundary=\(Constants.boundary)"
            ]
        }

        var url: String {
            return "image"
        }

        var method: Networkable.Method {
            return .post
        }

        func body() throws -> Data? {
            switch self {
            case let .upload(base64Image):
                var body = ""
                body += "--\(Constants.boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"image\""
                body += "\r\n\r\n\(base64Image)\r\n"
                body += "--\(Constants.boundary)--\r\n"
                return body.data(using: .utf8)
            }
        }
    }
}
