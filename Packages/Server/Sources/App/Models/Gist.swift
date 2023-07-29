import Foundation
import Vapor

public struct Gist: Content, Codable {
    public var id: String?
    public var updatedAt: Date?
    public var description: String?
    public var comments: Int?
    public var owner: User?
    public var stargazerCount: Int?
    public var filesCount: Int?
    public var files: [String: File]?

    public init(
        id: String? = nil,
        updatedAt: Date? = nil,
        description: String? = nil,
        comments: Int? = nil,
        owner: User? = nil,
        stargazerCount: Int? = nil,
        filesCount: Int? = nil,
        files: [String: File]? = nil
    ) {
        self.id = id
        self.updatedAt = updatedAt
        self.description = description
        self.comments = comments
        self.owner = owner
        self.stargazerCount = stargazerCount
        self.filesCount = filesCount
        self.files = files
    }
}

public struct File: Content, Codable {
    public var filename: String?

    public init(filename: String? = nil) {
        self.filename = filename
    }
}
