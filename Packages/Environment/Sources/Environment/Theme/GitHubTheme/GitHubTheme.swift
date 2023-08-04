import Runestone
import UIKit
import DesignSystem

public final class GitHubTheme: EditorTheme {
    public let backgroundColor = UIColor.white
    public let userInterfaceStyle: UIUserInterfaceStyle = .light

    public let font: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)
    public let textColor = UIColor(colorValue: ColorValue(0x24292E))

    public let gutterBackgroundColor = UIColor.white
    public let gutterHairlineColor = UIColor(colorValue: ColorValue(0x24292E))

    public let lineNumberColor = UIColor(colorValue: ColorValue(0x24292E))
    public let lineNumberFont: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)

    public let selectedLineBackgroundColor = UIColor(colorValue: ColorValue(0xFAFBFC))
    public let selectedLinesLineNumberColor = UIColor(colorValue: ColorValue(0x24292E))
    public let selectedLinesGutterBackgroundColor = UIColor.clear

    public let invisibleCharactersColor = UIColor(colorValue: ColorValue(0x959DA5))

    public let pageGuideHairlineColor = UIColor(colorValue: ColorValue(0x24292E))
    public let pageGuideBackgroundColor = UIColor.white

    public let markedTextBackgroundColor = UIColor.red
    public let markedTextBackgroundCornerRadius: CGFloat = 4

    public init() {}

    public func textColor(for rawHighlightName: String) -> UIColor? {
        guard let highlightName = HighlightName(rawHighlightName) else {
            return nil
        }
        switch highlightName {
        case .comment:
            return UIColor(colorValue: ColorValue(0x6A737D))
        case .operator, .punctuation:
            return UIColor(colorValue: ColorValue(0x032F62))
        case .property:
            return UIColor(colorValue: ColorValue(0x005CC5))
        case .function:
            return UIColor(colorValue: ColorValue(0x24292E))
        case .string:
            return UIColor(colorValue: ColorValue(0x032F62))
        case .number:
            return UIColor(colorValue: ColorValue(0x005CC5))
        case .keyword:
            return UIColor(colorValue: ColorValue(0xD73A49))
        case .variableBuiltin, .type:
            return UIColor(colorValue: ColorValue(0xD73A49))
        case .strong:
            return UIColor(colorValue: ColorValue(0x24292E))
        case .emphasis:
            return UIColor(colorValue: ColorValue(0x24292E))
        case .title:
            return UIColor(colorValue: ColorValue(0x005CC5))
        case .reference:
            return UIColor(colorValue: ColorValue(0x005CC5))
        case .literal:
            return UIColor(colorValue: ColorValue(0x005CC5))
        case .uri:
            return UIColor(colorValue: ColorValue(0x005CC5))
        case .none:
            return UIColor(colorValue: ColorValue(0x24292E))
        case .variable:
            return UIColor(colorValue: ColorValue(0x24292E))
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
