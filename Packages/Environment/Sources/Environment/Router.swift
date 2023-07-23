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
    case editorCodeSettings
    case editorView(fileName: String, content: String, language: File.Language, gist: Gist)

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
        case .editorCodeSettings:
            return "editorCodeSettings"
        case .editorView:
            return "editorView"
        }
    }
}

@MainActor
public class RouterPath: ObservableObject {
    @Published public var path: [RouterDestination] = []
    @Published public var presentedSheet: SheetDestination?
    public var urlHandler: ((URL) -> OpenURLAction.Result)?

    public init() {}

    public func navigate(to destination: RouterDestination) {
        path.append(destination)
    }

    public func handle(url: URL) -> OpenURLAction.Result {
        print("Handle", url)
        return urlHandler?(url) ?? .systemAction
    }
}
