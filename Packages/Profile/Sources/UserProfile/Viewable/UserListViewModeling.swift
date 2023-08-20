import Foundation
import Networking
import Models

public enum UserListContentState {
    case loading
    case content
    case error
}

public protocol UserListViewModeling: ObservableObject, AnyObject {
    var contentState: UserListContentState { get }
    var isLoadingMoreUsers: Bool { get }
    var users: [User] { get }

    func fetchUsers(refresh: Bool) async
    func fetchMoreUsersIfNeeded(currentUserLogin: String) async
    func refresh() async
}
