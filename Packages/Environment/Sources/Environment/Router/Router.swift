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
    case settings
    case settingsAccount
    case editorCodeSettings
}

public enum SheetDestination: Identifiable {
    case newGist(completion: ((Gist) -> Void)?)
    case editGist(_ gist: Gist, completion: ((Gist) -> Void)?)
    case browseFiles(
        files: [File],
        gist: Gist,
        completion: ((File) -> Void)?
    )
    case markdownTextEditor(
        style: MarkdownTextEditorStyle,
        completion: ((String) -> Void)?
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
        case .markdownTextEditor:
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

    @discardableResult
    public func handle(url: URL) -> OpenURLAction.Result {
        // TODO: Handle open GistHub profile when ready
        if let host = url.host(), host == AppInfo.mainHost {
            if url.pathComponents.count >= 3 {
                navigate(to: .gistDetail(gistId: url.pathComponents[2]))
                return .handled
            }
        }

        return urlHandler?(url) ?? .systemAction
    }
}
