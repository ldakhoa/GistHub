import Foundation

public enum MarkdownTextEditorStyle: Equatable {
    case createGist
    case writeComment(content: String)
    case updateComment(content: String)

    public var navigationTitle: String {
        switch self {
        case .createGist:
            return ""
        case .writeComment:
            return "Write Comment"
        case .updateComment:
            return "Edit Comment"
        }
    }

    public var trailingBarTitle: String {
        switch self {
        case .createGist:
            return "Save"
        case .writeComment, .updateComment:
            return "Comment"
        }
    }

    public var placeholder: String {
        switch self {
        case .createGist:
            return ""
        case .writeComment, .updateComment:
            return "Write a comment..."
        }
    }
}
