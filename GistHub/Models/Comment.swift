//
//  Comment.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import Foundation

struct Comment: Codable {
    let url: String
    let id: Int?
    let nodeID: String?
    let user: User
    let authorAssociation: String?
    let createdAt: Date?
    let updatedAt: Date?
    let body: String?

    enum CodingKeys: String, CodingKey {
        case url
        case id
        case nodeID = "node_id"
        case user
        case authorAssociation = "author_association"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case body
    }
}
