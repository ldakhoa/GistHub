import Foundation

public struct GistSearchResult: Codable {
    public let gists: [Gist]
    public let languages: [GistSearchResultLanguage]?
}

public struct GistSearchResultLanguage: Codable {
    public let language: String
    public let count: Int
}

public enum GistSearchResultSortOption: Int, Identifiable, Hashable, CaseIterable {
    case bestMatch
    case mostStars
    case fewestStars
    case mostForks
    case fewestForks
    case recentlyUpdated
    case leastRecentlyUpdated

    public var id: Int {
        rawValue
    }

    public var title: String {
        switch self {
        case .bestMatch:
            return "Best match"
        case .mostStars:
            return "Most stars"
        case .fewestStars:
            return "Fewest stars"
        case .mostForks:
            return "Most forks"
        case .fewestForks:
            return "Fewest forks"
        case .recentlyUpdated:
            return "Recently updated"
        case .leastRecentlyUpdated:
            return "Least recently updated"
        }
    }

    public var sortOption: SortOption {
        switch self {
        case .bestMatch:
            return SortOption(field: .bestMatch, direction: .desc)
        case .mostStars:
            return SortOption(field: .stars, direction: .desc)
        case .fewestStars:
            return SortOption(field: .stars, direction: .asc)
        case .mostForks:
            return SortOption(field: .forks, direction: .desc)
        case .fewestForks:
            return SortOption(field: .forks, direction: .asc)
        case .recentlyUpdated:
            return SortOption(field: .updated, direction: .desc)
        case .leastRecentlyUpdated:
            return SortOption(field: .updated, direction: .asc)
        }
    }

    public struct SortOption {
        public let field: Field
        public let direction: Direction
    }

    public enum Field: String {
        case stars
        case forks
        case updated
        case bestMatch = ""
    }

    public enum Direction: String {
        case asc
        case desc
    }
}
