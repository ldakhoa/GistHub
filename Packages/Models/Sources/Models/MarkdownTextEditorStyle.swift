import Foundation

public enum MarkdownTextEditorStyle {
    case createGist
    case writeComment
    case updateComment

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

    public var placeholder: String {
        switch self {
        case .createGist:
            return ""
        case .writeComment, .updateComment:
            return "Write a comment..."
        }
    }
}
