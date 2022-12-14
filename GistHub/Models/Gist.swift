//
//  Gist.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import OrderedCollections

struct Gist: Codable, Identifiable {
    let url: String?
    let forksURL: String?
    let commitsURL: String?
    let id: String
    let nodeID: String?
    let gitPullURL: String?
    let gitPushURL: String?
    let htmlURL: String?
    let files: OrderedDictionary<String, File>?
    let `public`: Bool?
    let createdAt: Date?
    let updatedAt: Date?
    let description: String?
    let comments: Int?
    let commentsURL: String?
    let owner: User?
    let truncated: Bool?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.forksURL = try container.decodeIfPresent(String.self, forKey: .forksURL)
        self.commitsURL = try container.decodeIfPresent(String.self, forKey: .commitsURL)
        self.id = try container.decode(String.self, forKey: .id)
        self.nodeID = try container.decodeIfPresent(String.self, forKey: .nodeID)
        self.gitPullURL = try container.decodeIfPresent(String.self, forKey: .gitPullURL)
        self.gitPushURL = try container.decodeIfPresent(String.self, forKey: .gitPushURL)
        self.htmlURL = try container.decodeIfPresent(String.self, forKey: .htmlURL)
        self.files = try container.decodeIfPresent([String: File].self, forKey: .files)?.toOrderedDictionary()
        self.public = try container.decodeIfPresent(Bool.self, forKey: .public)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.comments = try container.decodeIfPresent(Int.self, forKey: .comments)
        self.commentsURL = try container.decodeIfPresent(String.self, forKey: .commentsURL)
        self.owner = try container.decodeIfPresent(User.self, forKey: .owner)
        self.truncated = try container.decodeIfPresent(Bool.self, forKey: .truncated)
    }

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case forksURL = "forks_url"
        case commitsURL = "commits_url"
        case id = "id"
        case nodeID = "node_id"
        case gitPullURL = "git_pull_url"
        case gitPushURL = "git_push_url"
        case htmlURL = "html_url"
        case files = "files"
        case `public` = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description
        case comments = "comments"
        case commentsURL = "comments_url"
        case owner = "owner"
        case truncated = "truncated"
    }
}

extension OrderedDictionary {
    var fileName: String? {
        if let fileName = self.keys.first as? String {
            return fileName
        }
        return nil
    }
}

private extension Dictionary where Key == String, Value == File {
    func toOrderedDictionary() -> OrderedDictionary<String, File> {
        var orderedDict = OrderedDictionary<String, File>()
        for file in self {
            orderedDict[file.key] = file.value
        }
        orderedDict.sort { file1, file2 in
            file1.key < file2.key
        }
        return orderedDict
    }
}
