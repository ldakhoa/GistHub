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
    case settings
    case settingsAccount
    case editorCodeSettings
}

public enum SheetDestination: Identifiable {
    case newGist(completion: ((Gist) -> Void)?)
    case editGist(_ gist: Gist, completion: ((Gist) -> Void)?)
    case browseFiles(files: [File], gist: Gist, dismissAction: () -> Void)
    case commentTextEditor(
        gistId: String,
        navigationTitle: String,
        placeholder: String,
        commentViewModel: CommentViewModel
    )
    case reportABug

    public var id: String {
        switch self {
        case .newGist, .editGist:
            return "composeGist"
        case .browseFiles:
            return "browseFiles"
        case .commentTextEditor:
            return "markdownTextEditorView"
        case .reportABug:
            return "reportABug"
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
