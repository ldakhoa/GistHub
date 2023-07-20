import SwiftUI
import Common
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
    case editGist(_ gist: Gist, completion: ((Gist) -> Void)?)
    case commentTextEditor(
        gistId: String,
        navigationTitle: String,
        placeholder: String,
        commentViewModel: CommentViewModel
    )

    public var id: String {
        switch self {
        case .newGist, .editGist:
            return "composeGist"
        case .commentTextEditor:
            return "markdownTextEditorView"
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
