//
//  Comment.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import Foundation

public struct Comment: Codable {
    public let url: String
    public let id: Int?
    public let nodeID: String?
    public let user: User
    public let authorAssociation: String?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let body: String?

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

public extension Comment {
    static var placeholders: [Comment] {
        [.placeholder, .placeholder, .placeholder]
    }

    static var placeholder: Comment {
        Comment(
            url: "",
            id: 0,
            nodeID: "",
            user: .stubbed,
            authorAssociation: "",
            createdAt: Date(timeIntervalSince1970: TimeInterval.infinity),
            updatedAt: Date(timeIntervalSince1970: TimeInterval.infinity),
            body: "This is fake comment to display redacted, This is fake comment to display redacted."
        )
    }
}

extension Comment: Equatable {
    public static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
}
