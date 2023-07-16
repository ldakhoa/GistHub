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
    enum API: Request {
        case upload(base64Image: String)
        var headers: [String: String]? {
            return [
                "Authoriazation": "Client-ID \(Secrets.Imgur.clientId)"
            ]
        }

        var url: String {
            return "/3/image"
        }

        var method: Networkable.Method {
            return .post
        }

        func body() throws -> Data? {
            switch self {
            case let .upload(base64Image):
                struct Request: Codable {
                    let image: String
                    func toData() throws -> Data? {
                        return try JSONEncoder().encode(self)
                    }
                }
                let request = Request(image: base64Image)
                return try? request.toData()
            }
        }
    }
}
