import Foundation

public struct RecentComment: Hashable, Identifiable {
    public let gist: Gist
    public let author: User?
    public let body: String
    public let updatedAt: Date?
    public let createdAt: Date?

    public init(
        gist: Gist,
        author: User?,
        body: String,
        updatedAt: Date?,
        createdAt: Date?
    ) {
        self.gist = gist
        self.author = author
        self.body = body
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }

    // MARK: Identifiable

    public var id: String {
        gist.id
    }
}
