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
}
