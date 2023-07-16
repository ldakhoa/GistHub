//
//  File 2.swift
//  
//
//  Created by Hung Dao on 16/07/2023.
//

import Foundation

public struct ImgurImage: Codable {
    public let id: String
    public let title: String?
    public let link: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.id = try dataContainer.decode(String.self, forKey: .id)
        self.title = try dataContainer.decodeIfPresent(String.self, forKey: .title)
        self.link = try dataContainer.decode(String.self, forKey: .link)
    }

    enum RootKeys: String, CodingKey {
        case data, success, status
    }
}
