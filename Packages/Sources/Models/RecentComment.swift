import Foundation

public struct RecentComment: Hashable, Identifiable {
    public let id: String
    public let gist: Gist
    public let author: User?
    public let body: String
    public let updatedAt: Date?
    public let createdAt: Date?

    public init(
        id: String,
        gist: Gist,
        author: User?,
        body: String,
        updatedAt: Date?,
        createdAt: Date?
    ) {
        self.id = id
        self.gist = gist
        self.author = author
        self.body = body
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
