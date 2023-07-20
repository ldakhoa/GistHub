import SwiftUI
import Networking
import Models

public enum RouterDestination: Hashable {
    case gistDetail(gistId: String)
    case editorDisplay(
        content: String,
        fileName: String,
        gist: Gist,
        language: File.Language
    )
}

public enum SheetDestination: Identifiable {
    case newGist(completion: ((Gist) -> Void)?)

    public var id: String {
        switch self {
        case .newGist:
            return "composeGist"
        }
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
