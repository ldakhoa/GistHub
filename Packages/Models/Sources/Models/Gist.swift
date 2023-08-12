//
//  Gist.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import OrderedCollections

public struct Gist: Codable, Identifiable, Hashable {
    public let url: String?
    public let forksURL: String?
    public let commitsURL: String?
    public let id: String
    public let draftID: String?
    public let nodeID: String?
    public let gitPullURL: String?
    public let gitPushURL: String?
    public let htmlURL: String?
    public let files: OrderedDictionary<String, File>?
    public let fileTotalCount: Int?
    public let `public`: Bool?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let isUpdated: Bool?
    public let description: String?
    public let comments: Int?
    public let commentsURL: String?
    public let owner: User?
    public let truncated: Bool?
    public let stargazerCount: Int?
    public let fork: Fork?

    public init(
        id: String,
        url: String? = nil,
        forksURL: String? = nil,
        commitsURL: String? = nil,
        nodeID: String? = nil,
        draftID: String? = nil,
        gitPullURL: String? = nil,
        gitPushURL: String? = nil,
        htmlURL: String? = nil,
        files: OrderedDictionary<String, File>? = nil,
        fileTotalCount: Int? = 1,
        isPublic: Bool? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        isUpdated: Bool? = false,
        description: String? = nil,
        comments: Int? = nil,
        commentsURL: String? = nil,
        owner: User? = nil,
        isTruncated: Bool = false,
        stargazerCount: Int? = nil,
        fork: Fork? = nil
    ) {
        self.id = id
        self.url = url
        self.forksURL = forksURL
        self.commitsURL = commitsURL
        self.nodeID = nodeID
        self.draftID = draftID
        self.gitPullURL = gitPullURL
        self.gitPushURL = gitPushURL
        self.htmlURL = htmlURL
        self.files = files
        self.fileTotalCount = fileTotalCount
        self.public = isPublic
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isUpdated = isUpdated
        self.description = description
        self.comments = comments
        self.commentsURL = commentsURL
        self.owner = owner
        self.truncated = isTruncated
        self.stargazerCount = stargazerCount
        self.fork = fork
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.forksURL = try container.decodeIfPresent(String.self, forKey: .forksURL)
        self.commitsURL = try container.decodeIfPresent(String.self, forKey: .commitsURL)
        self.id = try container.decode(String.self, forKey: .id)
        self.nodeID = try container.decodeIfPresent(String.self, forKey: .nodeID)
        self.draftID = try container.decodeIfPresent(String.self, forKey: .draftID)
        self.gitPullURL = try container.decodeIfPresent(String.self, forKey: .gitPullURL)
        self.gitPushURL = try container.decodeIfPresent(String.self, forKey: .gitPushURL)
        self.htmlURL = try container.decodeIfPresent(String.self, forKey: .htmlURL)
        self.files = try container.decodeIfPresent([String: File].self, forKey: .files)?.toOrderedDictionary()
        self.fileTotalCount = try container.decodeIfPresent(Int.self, forKey: .fileTotalCount)
        self.public = try container.decodeIfPresent(Bool.self, forKey: .public)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.isUpdated = try container.decodeIfPresent(Bool.self, forKey: .isUpdated)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.comments = try container.decodeIfPresent(Int.self, forKey: .comments)
        self.commentsURL = try container.decodeIfPresent(String.self, forKey: .commentsURL)
        self.owner = try container.decodeIfPresent(User.self, forKey: .owner)
        self.truncated = try container.decodeIfPresent(Bool.self, forKey: .truncated)
        self.stargazerCount = try container.decodeIfPresent(Int.self, forKey: .stargazerCount)
        self.fork = try container.decodeIfPresent(Fork.self, forKey: .fork)
    }

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case forksURL = "forks_url"
        case commitsURL = "commits_url"
        case id = "id"
        case nodeID = "node_id"
        case draftID
        case gitPullURL = "git_pull_url"
        case gitPushURL = "git_push_url"
        case htmlURL = "html_url"
        case files = "files"
        case fileTotalCount = "fileCount"
        case `public` = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isUpdated
        case description
        case comments = "comments"
        case commentsURL = "comments_url"
        case owner = "owner"
        case truncated = "truncated"
        case stargazerCount
        case fork
    }

    public static func == (lhs: Gist, rhs: Gist) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension OrderedDictionary {
    public var fileName: String? {
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

public extension Gist {
    static var placeholders: [Gist] {
        [.placeholder, .placeholder, .placeholder, .placeholder, .placeholder, .placeholder]
    }

    static var placeholder: Gist {
        Gist(
            id: UUID().uuidString,
            url: "https://github.com/ldakhoa",
            forksURL: "https://github.com/ldakhoa",
            commitsURL: "https://github.com/ldakhoa",
            nodeID: "https://github.com/ldakhoa",
            gitPullURL: "https://github.com/ldakhoa",
            gitPushURL: "https://github.com/ldakhoa",
            htmlURL: "https://github.com/ldakhoa",
            files: [
                "Test file": File(filename: "Example.md", language: .markdown)
            ],
            isPublic: true,
            createdAt: Date(timeIntervalSince1970: TimeInterval.infinity),
            updatedAt: Date(timeIntervalSince1970: TimeInterval.infinity),
            description: "This is fake description to display redacted",
            comments: 1,
            commentsURL: "https://github.com/ldakhoa",
            owner: .stubbed,
            isTruncated: false,
            stargazerCount: 0,
            fork: Fork(totalCount: 0)
        )
    }
}
