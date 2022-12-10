//
//  File.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

struct File: Codable {
    let filename: String?
    let type: String?
    let language: String?
    let rawURL: String?
    let size: Int?

    enum CodingKeys: String, CodingKey {
        case filename = "filename"
        case type = "type"
        case language = "language"
        case rawURL = "raw_url"
        case size = "size"
    }
}
