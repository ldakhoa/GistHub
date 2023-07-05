//
//  Owner.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

struct User: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url: String?
    let htmlURL: String?
    let gistsURL: String?
    let starredURL: String?
    let reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?
    let name: String?
    let location: String?
    let company: String?
    let followers: Int?
    let following: Int?
    let email: String?
    let bio: String?
    let twitterUsername: String?

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

class UserStore: ObservableObject {
    var user: User

    init(user: User) {
        self.user = user
    }
}
