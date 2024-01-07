import Runestone
import UIKit
import DesignSystem

public final class GitHubDarkTheme: EditorTheme {
    public let backgroundColor = UIColor(colorValue: ColorValue(0x24292E))
    public let userInterfaceStyle: UIUserInterfaceStyle = .dark

    public let font: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)
    public let textColor = UIColor(colorValue: ColorValue(0xF6F8FA))

    public let gutterBackgroundColor = UIColor(colorValue: ColorValue(0x24292E))
    public let gutterHairlineColor = UIColor(colorValue: ColorValue(0xF6F8FA))

    public let lineNumberColor = UIColor(colorValue: ColorValue(0xF6F8FA))
    public let lineNumberFont: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)

    public let selectedLineBackgroundColor = UIColor(colorValue: ColorValue(0x444D56))
    public let selectedLinesLineNumberColor = UIColor(colorValue: ColorValue(0xF6F8FA))
    public let selectedLinesGutterBackgroundColor = UIColor.clear

    public let invisibleCharactersColor = UIColor(colorValue: ColorValue(0x6A737D))

    public let pageGuideHairlineColor = UIColor(colorValue: ColorValue(0x6A737D))
    public let pageGuideBackgroundColor = UIColor(colorValue: ColorValue(0x24292E))

    public let markedTextBackgroundColor = UIColor.red
    public let markedTextBackgroundCornerRadius: CGFloat = 4

    public init() {}

    public func textColor(for rawHighlightName: String) -> UIColor? {
        guard let highlightName = HighlightName(rawHighlightName) else {
            return nil
        }
        switch highlightName {
        case .comment:
            return UIColor(colorValue: ColorValue(0x959DA5))
        case .operator, .punctuation:
            return UIColor(colorValue: ColorValue(0x79B8FF))
        case .property:
            return UIColor(colorValue: ColorValue(0xC8E1FF))
        case .function:
            return UIColor(colorValue: ColorValue(0xF6F8FA))
        case .string:
            return UIColor(colorValue: ColorValue(0x79B8FF))
        case .number:
            return UIColor(colorValue: ColorValue(0xC8E1FF))
        case .keyword:
            return UIColor(colorValue: ColorValue(0xEA4A5A))
        case .variableBuiltin, .type:
            return UIColor(colorValue: ColorValue(0xEA4A5A))
        case .strong:
            return UIColor(colorValue: ColorValue(0xF6F8FA))
        case .emphasis:
            return UIColor(colorValue: ColorValue(0xF6F8FA))
        case .title:
            return UIColor(colorValue: ColorValue(0xC8E1FF))
        case .reference:
            return UIColor(colorValue: ColorValue(0xC8E1FF))
        case .literal:
            return UIColor(colorValue: ColorValue(0xC8E1FF))
        case .uri:
            return UIColor(colorValue: ColorValue(0xC8E1FF))
        case .none:
            return UIColor(colorValue: ColorValue(0xF6F8FA))
        case .variable:
            return UIColor(colorValue: ColorValue(0xF6F8FA))
        }
    }

    public func fontTraits(for rawHighlightName: String) -> FontTraits {
        if let highlightName = HighlightName(rawHighlightName) {
            if highlightName == .keyword ||
                highlightName == .title ||
                highlightName == .variableBuiltin {
                return .bold
            } else {
                return []
            }
        } else {
            return []
        }
    }
}
