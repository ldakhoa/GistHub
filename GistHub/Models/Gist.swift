//
//  Gist.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

struct Gist: Codable, Identifiable {
    let url: String?
    let forksURL: String?
    let commitsURL: String?
    let id: String?
    let nodeID: String?
    let gitPullURL: String?
    let gitPushURL: String?
    let htmlURL: String?
    let files: [String: File]?
    let `public`: Bool?
    let createdAt: Date?
    let updatedAt: Date?
    let description: String?
    let comments: Int?
    let commentsURL: String?
    let owner: User?
    let truncated: Bool?

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
