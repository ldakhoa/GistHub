//
// GistsResponse.swift
//
//
//  Created by Hung Dao on 27/07/2023.
//
import OrderedCollections
import Models
import GistHubGraphQL
import Foundation

typealias Node = GistsQuery.Data.Viewer.Gists.Edge.Node

public struct GistsResponse {
    public let gists: [Gist]
    public let cursor: String
    public let hasNextPage: Bool

    init(data: GistsQuery.Data) {
        let pageInfo = data.viewer.gists.pageInfo
        cursor = pageInfo.endCursor ?? ""
        hasNextPage = pageInfo.hasNextPage

        let dateFormatter = ISO8601DateFormatter()
        let gistsData = data.viewer.gists.edges ?? []
        gists = gistsData.map { edge in
            let gist = edge?.node
            return Gist(
                id: gist?.name ?? "",
                url: gist?.url,
                nodeID: gist?.id,
                htmlURL: gist?.url,
                files: OrderedDictionary<String, File>.create(with: gist?.files),
                isPublic: gist?.isPublic ?? false,
                createdAt: dateFormatter.date(from: gist?.createdAt ?? ""),
                updatedAt: dateFormatter.date(from: gist?.updatedAt ?? ""),
                description: gist?.description,
                comments: gist?.comments.totalCount,
                owner: gist?.owner?.user()
            )
        }
    }
}

private extension OrderedDictionary<String, File> {
    static func create(with fileNodes: [Node.File?]?) -> Self {
        guard let fileNodes else { return [:] }
        let files: [Node.File] = fileNodes.compactMap { $0 }
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

extension Node.Owner {
    func user() -> User {
        User(
            login: self.login,
            nodeID: self.id,
            avatarURL: self.avatarUrl,
            htmlURL: self.asUser?.url,
            siteAdmin: self.asUser?.isSiteAdmin,
            name: self.asUser?.name,
            email: self.asUser?.email,
            bio: self.asUser?.bio,
            twitterUsername: self.asUser?.twitterUsername)
    }
}
