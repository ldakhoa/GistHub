import Foundation
import Networking
import Models
import OrderedCollections

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var contentState: ContentState = .loading
    @Published private(set) var recentComments: OrderedSet<RecentComment> = []

    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    func fetchRecentComments(from currentUserName: String?) async {
        guard let currentUserName else { return }
        do {
            if let recentComments = try await client.recentComments(fromUserName: currentUserName) {
                var recentCommentsSet = OrderedSet(recentComments)
                recentCommentsSet.reverse()
                self.recentComments = recentCommentsSet
            }
            contentState = .content
        } catch {
            contentState = .error
        }
    }

    func refresh(from currentUserName: String?) async {
        contentState = .loading
        await fetchRecentComments(from: currentUserName)
    }
}

extension HomeViewModel {
    enum ContentState {
        case loading
        case error
        case content
    }
}
