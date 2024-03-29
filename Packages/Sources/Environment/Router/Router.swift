import SwiftUI
import Networking
import Models

public enum RouterDestination: Hashable {
    case gistDetail(gistId: String)
    case stargazersFromGistDetail(gistID: String)
    case editorDisplay(
        content: String,
        fileName: String,
        gist: Gist,
        language: File.Language
    )
    case settings
    case settingsAccount
    case editorCodeSettings
    case gistLists(mode: GistListsMode)
    case draftGistLists
    case userProfile(userName: String)
    case searchUsers(query: String)
    case searchGists(query: String)
    case userFollows(login: String, type: UserFollowType)
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

    public func navigateToUserProfileView(with userName: String) {
        navigate(to: .userProfile(userName: userName))
    }

    public func navigateToGistDetail(with gistId: String) {
        navigate(to: .gistDetail(gistId: gistId))
    }

    // Possible URL
    // https://gist.github.com/<username>/<gistid>
    // https://gist.github.com/<username>/<gistid>#file-<file-name>
    // https://gist.github.com/<username>/<gistid>/stargazers (Support later)
    @discardableResult
    public func handle(url: URL) -> OpenURLAction.Result {
        guard let host = url.host(), host == AppInfo.mainHost else {
            return urlHandler?(url) ?? .systemAction
        }

        let pathComponents: [String] = url.pathComponents
        let userName = pathComponents[1]

        if pathComponents.count == 2, !userName.isEmpty {
            navigateToUserProfileView(with: userName)
            return .handled
        } else if pathComponents.count >= 3 {
            if pathComponents[2] == "starred" {
                navigateToUserProfileView(with: userName)
                return .handled
            } else {
                navigate(to: .gistDetail(gistId: pathComponents[2]))
                return .handled
            }
        }

        return urlHandler?(url) ?? .systemAction
    }
}
