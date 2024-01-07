import Foundation
import ApolloAPI

extension Optional {
    public func mapSome<T>(_ transform: (Wrapped) throws -> T?) rethrows -> GraphQLNullable<T> {
        switch self {
        case let .some(value):
            if let transformedValue = try transform(value) {
                return .some(transformedValue)
            } else {
                return .none
            }
        case .none:
            return .none
        }
    }
}
