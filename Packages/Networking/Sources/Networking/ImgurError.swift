//
//  ImgurError.swift
//  
//
//  Created by Hung Dao on 16/07/2023.
//

import Foundation

struct ImgurError: LocalizedError, Codable {
    let message: String

    public var errorDescription: String? { message }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.message = try dataContainer.decode(String.self, forKey: .message)
    }

    enum CodingKeys: String, CodingKey {
        case message = "error"
    }

    enum RootKeys: String, CodingKey {
        case data, success, status
    }

}
