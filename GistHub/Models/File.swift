//
//  File.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

struct File: Codable, Identifiable, Hashable {
    var id: String {
        rawURL ?? ""
    }

    let filename: String?
    let type: String?
    let language: String?
    let rawURL: String?
    let size: Int?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case filename
        case type
        case language
        case rawURL = "raw_url"
        case size
        case content = "content"
    }
}
