//
//  Owner.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

public struct User: Codable {
    public let login: String?
    public let id: Int?
    public let nodeID: String?
    public let avatarURL: String?
    public let gravatarID: String?
    public let url: String?
    public let htmlURL: String?
    public let gistsURL: String?
    public let starredURL: String?
    public let reposURL: String?
    public let eventsURL: String?
    public let receivedEventsURL: String?
    public let type: String?
    public let siteAdmin: Bool?
    public let name: String?
    public let location: String?
    public let company: String?
    public let followers: Int?
    public let following: Int?
    public let email: String?
    public let bio: String?
    public let twitterUsername: String?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url = "url"
        case htmlURL = "html_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
        case name
        case location
        case company
        case followers
        case following
        case email
        case bio
        case twitterUsername = "twitter_username"
    }
}

public class UserStore: ObservableObject {
    public var user: User

    init(user: User) {
        self.user = user
    }
}
