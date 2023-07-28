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

protocol GraphQLLanguage {
    var name: String { get }
}

protocol GraphQLComments {
    var totalCount: Int { get }
}

protocol GraphQLFile {
    associatedtype Language: GraphQLLanguage
    var name: String? { get }
    var language: Language? { get }
    var size: Int? { get }
    var text: String? { get }
}

extension GraphQLFile {
    func toFile() -> Models.File {
        File(
            filename: self.name,
            language: Models.File.Language(rawValue: self.language?.name.lowercased() ?? "") ?? .unknown,
            size: self.size,
            content: self.text
        )
    }
}

protocol GraphQLAsUser {
    var name: String? { get }
    var twitterUsername: String? { get }
    var isSiteAdmin: Bool { get }
    var url: String { get }
    var bio: String? { get }
    var email: String { get }
}

protocol GraphQLUser {
    associatedtype AsUser: GraphQLAsUser
    var id: String { get }
    var login: String { get }
    var avatarUrl: String { get }
    var asUser: AsUser? { get }
}

extension GraphQLUser {
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

protocol GraphQLGist {
    associatedtype File: GraphQLFile
    associatedtype Owner: GraphQLUser
    associatedtype Comments: GraphQLComments
    var id: String { get }
    var name: String { get }
    var description: String? { get }
    var files: [File?]? { get }
    var createdAt: String { get }
    var updatedAt: String { get }
    var comments: Comments { get }
    var isPublic: Bool { get }
    var url: String { get }
    var owner: Owner? { get }
}

extension GraphQLGist {
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
            owner: self.owner?.toUser()
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
    static func create(with fileNodes: [(any GraphQLFile)?]?) -> Self {
        guard let fileNodes else { return [:] }
        let files: [any GraphQLFile] = fileNodes.compactMap { $0 }
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

// MARK: - Protocol apdoption

// MARK: GistsQuery

typealias GistsQueryNode = GistsQuery.Data.Viewer.Gists.Edge.Node
extension GistsQueryNode: GraphQLGist {}
extension GistsQueryNode.Comments: GraphQLComments {}
extension GistsQueryNode.Owner.AsUser: GraphQLAsUser {}
extension GistsQueryNode.Owner: GraphQLUser {}
extension GistsQueryNode.File: GraphQLFile {}
extension GistsQueryNode.File.Language: GraphQLLanguage {}

// MARK: GistQuery

typealias GistQueryNode = GistQuery.Data.Viewer.Gist
extension GistQueryNode: GraphQLGist {}
extension GistQueryNode.Comments: GraphQLComments {}
extension GistQueryNode.Owner.AsUser: GraphQLAsUser {}
extension GistQueryNode.Owner: GraphQLUser {}
extension GistQueryNode.File: GraphQLFile {}
extension GistQueryNode.File.Language: GraphQLLanguage {}

// MARK: GistFromUserQuery

typealias GistsFromUserQueryNode = GistsFromUserQuery.Data.User.Gists.Edge.Node
extension GistsFromUserQueryNode: GraphQLGist {}
extension GistsFromUserQueryNode.Comments: GraphQLComments {}
extension GistsFromUserQueryNode.Owner.AsUser: GraphQLAsUser {}
extension GistsFromUserQueryNode.Owner: GraphQLUser {}
extension GistsFromUserQueryNode.File: GraphQLFile {}
extension GistsFromUserQueryNode.File.Language: GraphQLLanguage {}
