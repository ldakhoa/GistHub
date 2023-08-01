//
//  Owner.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

public struct User: Codable, Identifiable, Hashable, Sendable {
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

    public init(
        login: String? = nil,
        id: Int? = nil,
        nodeID: String? = nil,
        avatarURL: String? = nil,
        gravatarID: String? = nil,
        url: String? = nil,
        htmlURL: String? = nil,
        gistsURL: String? = nil,
        starredURL: String? = nil,
        reposURL: String? = nil,
        eventsURL: String? = nil,
        receivedEventsURL: String? = nil,
        type: String? = nil,
        siteAdmin: Bool? = nil,
        name: String? = nil,
        location: String? = nil,
        company: String? = nil,
        followers: Int? = nil,
        following: Int? = nil,
        email: String? = nil,
        bio: String? = nil,
        twitterUsername: String? = nil
    ) {
        self.login = login
        self.id = id
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.url = url
        self.htmlURL = htmlURL
        self.gistsURL = gistsURL
        self.starredURL = starredURL
        self.reposURL = reposURL
        self.eventsURL = eventsURL
        self.receivedEventsURL = receivedEventsURL
        self.type = type
        self.siteAdmin = siteAdmin
        self.name = name
        self.location = location
        self.company = company
        self.followers = followers
        self.following = following
        self.email = email
        self.bio = bio
        self.twitterUsername = twitterUsername
    }

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

    public init(user: User) {
        self.user = user
    }
}

public extension User {
    static var stubbed: User {
        User(
            login: "octocat",
            id: 1,
            nodeID: "123123123",
            avatarURL: "https://github.com/images/error/octocat_happy.gif",
            url: "https://api.github.com/users/octocat",
            htmlURL: "https://github.com/octocat",
            gistsURL: "https://api.github.com/users/octocat/gists{/gist_id}",
            starredURL: "https://api.github.com/users/octocat/starred{/owner}{/repo}",
            reposURL: "https://api.github.com/users/octocat/repos",
            eventsURL: "https://api.github.com/users/octocat/events{/privacy}",
            receivedEventsURL: "https://api.github.com/users/octocat/received_events",
            type: "User",
            siteAdmin: false
        )
    }
}
