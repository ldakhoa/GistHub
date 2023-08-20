//
//  GraphQLResponseMapper.swift
//
//
//  Created by Hung Dao on 28/07/2023.
//

import Models
import OrderedCollections
import Foundation
import GistHubGraphQL

extension GistDetails.File {
    func toFile() -> Models.File {
        File(
            filename: self.name,
            language: Models.File.Language(rawValue: self.language?.name.lowercased() ?? "") ?? .unknown,
            size: self.size,
            content: self.text
        )
    }
}

extension GistDetails.Owner {
    func toUser() -> User {
        User(
            login: self.login,
            nodeID: self.id,
            avatarURL: self.avatarUrl,
            htmlURL: self.asUser?.url,
            siteAdmin: self.asUser?.isSiteAdmin,
            name: self.asUser?.name,
            email: self.asUser?.email,
            bio: self.asUser?.bio,
            twitterUsername: self.asUser?.twitterUsername
        )
    }
}

extension GistDetails {
    func toGist() -> Gist {
        let dateFormatter = ISO8601DateFormatter()
        return Gist(
            id: self.name,
            url: self.url,
            nodeID: self.id,
            htmlURL: self.url,
            files: filesModel,
            isPublic: self.isPublic,
            createdAt: dateFormatter.date(from: self.createdAt),
            updatedAt: dateFormatter.date(from: self.updatedAt),
            description: self.description,
            comments: self.comments.totalCount,
            owner: self.owner?.toUser(),
            stargazerCount: self.stargazerCount,
            fork: Models.Fork(totalCount: forks.totalCount)
        )
    }

    private var filesModel: OrderedDictionary<String, Models.File> {
        guard let files else { return [:] }
        let filesNodes = files.compactMap { $0 }
        var result: OrderedDictionary<String, Models.File> = [:]
        for fileNode in filesNodes {
            let fileObject = fileNode.toFile()
            result[fileObject.filename ?? ""] = fileObject
        }
        result.sort { file1, file2 in
            file1.key < file2.key
        }
        return result
    }
}

private extension OrderedDictionary<String, File> {
    static func create(with fileNodes: [(GistDetails.File)?]?) -> Self {
        guard let fileNodes else { return [:] }
        let files: [GistDetails.File] = fileNodes.compactMap { $0 }
        var result: OrderedDictionary<String, File> = [:]
        for file in files {
            let fileObject = File(
                filename: file.name,
                language: File.Language(rawValue: file.language?.name ?? "") ?? .unknown,
                size: file.size,
                content: file.text
            )
            result[file.name ?? ""] = fileObject
        }
        result.sort { file1, file2 in
            file1.key < file2.key
        }
        return result
    }
}

// MARK: - Helpers

// MARK: GistList

extension GistList.Gists.Edge.Node {
    var gistDetails: GistDetails {
        Self.Fragments(_dataDict: __data).gistDetails
    }
}

// MARK: GistQuery

public extension GistQuery.Data {
    var gist: Models.Gist? {
        viewer.gist?.gistDetails.toGist()
    }
}

extension GistQuery.Data.Viewer.Gist {
    var gistDetails: GistDetails {
        Self.Fragments(_dataDict: __data).gistDetails
    }
}

// MARK: User Queries...

extension FollowersQuery.Data.User.Followers.Node {
    var toUser: User {
        User(
            login: self.login,
            avatarURL: self.avatarUrl,
            url: self.url,
            name: self.name,
            bio: self.bio
        )
    }
}

extension FollowingsQuery.Data.User.Following.Node {
    var toUser: User {
        User(
            login: self.login,
            avatarURL: self.avatarUrl,
            url: self.url,
            name: self.name,
            bio: self.bio
        )
    }
}

// MARK: UserSearchQuery

extension UserSearchQuery.Data.Search.Edge.Node {
    var toUser: User? {
        if let user = self.asUser {
            let login = user.login
            let name = user.name
            let avatarUrl = user.avatarUrl
            let bio = user.bio

            return User(login: login, avatarURL: avatarUrl, name: name, bio: bio)
        }
        return nil
    }
}

// MARK: RecentCommentsQuery

extension RecentCommentsQuery.Data.User.GistComments.Node {
    func toRecentComment() -> RecentComment {
        let dateFormatter = ISO8601DateFormatter()

        let gist = Models.Gist(
            id: self.gist.name,
            url: self.gist.url,
            files: filesModel,
            description: self.gist.description,
            owner: User(
                login: self.gist.owner?.login,
                avatarURL: self.gist.owner?.avatarUrl
            )
        )
        let recentComment = RecentComment(
            id: self.id,
            gist: gist,
            author: User(login: self.author?.login),
            body: self.body,
            updatedAt: dateFormatter.date(from: self.updatedAt),
            createdAt: dateFormatter.date(from: self.createdAt)
        )
        return recentComment
    }

    private var filesModel: OrderedDictionary<String, Models.File> {
        guard let files = self.gist.files else { return [:] }
        let filesNodes = files.compactMap { $0 }
        var result: OrderedDictionary<String, Models.File> = [:]
        for fileNode in filesNodes {
            let file = File(filename: fileNode.name)
            let fileObject = file
            result[fileObject.filename ?? ""] = fileObject
        }
        result.sort { file1, file2 in
            file1.key < file2.key
        }
        return result
    }
}
