import SwiftUI
import Networking

public enum RouterDestination: Hashable {
    case gistDetail(gistId: String)
}

public enum SheetDestination: Identifiable {
    public var id: String {
        return "id"
    }
}

@MainActor
public class RouterPath: ObservableObject {
    @Published public var path: [RouterDestination] = []
    @Published public var presentedSheet: SheetDestination?

    public init() {}

    public func navigate(to destination: RouterDestination) {
        path.append(destination)
    }
}
