import Foundation

public enum UserFollowType {
    case follower
    case following

    public var title: String {
        switch self {
        case .follower:
            return "Followers"
        case .following:
            return "Followings"
        }
    }
}
