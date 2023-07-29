//
//  ImgurImage.swift
//
//
//  Created by Hung Dao on 16/07/2023.
//

import Foundation

public struct ImgurImage: Codable {
    public let id: String
    public let title: String?
    public let link: String

    public init(
        id: String = "",
        title: String? = nil,
        link: String = ""
    ) {
        self.id = id
        self.title = title
        self.link = link
    }
}
