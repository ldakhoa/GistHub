import Runestone
import UIKit
import DesignSystem

public final class GitHubTheme: EditorTheme {
    public let backgroundColor = UIColor(
        light: .white,
        dark: UIColor(colorValue: ColorValue(0x24292E))
    )

    public let font: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)
    public let textColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x24292E)),
        dark: UIColor(colorValue: ColorValue(0xF6F8FA))
    )

    public let gutterBackgroundColor = UIColor(
        light: .white,
        dark: UIColor(colorValue: ColorValue(0x24292E))
    )
    public let gutterHairlineColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x24292E)),
        dark: UIColor(colorValue: ColorValue(0xF6F8FA))
    )

    public let lineNumberColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x24292E)),
        dark: UIColor(colorValue: ColorValue(0xF6F8FA))
    )
    public let lineNumberFont: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)

    public let selectedLineBackgroundColor = UIColor(
        light: UIColor(colorValue: ColorValue(0xFAFBFC)),
        dark: UIColor(colorValue: ColorValue(0x444D56))
    )
    public let selectedLinesLineNumberColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x24292E)),
        dark: UIColor(colorValue: ColorValue(0xF6F8FA))
    )
    public let selectedLinesGutterBackgroundColor = UIColor.clear

    public let invisibleCharactersColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x959DA5)),
        dark: UIColor(colorValue: ColorValue(0x6A737D))
    )

    public let pageGuideHairlineColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x24292E)),
        dark: UIColor(colorValue: ColorValue(0x6A737D))
    )
    public let pageGuideBackgroundColor = UIColor(
        light: .white,
        dark: UIColor(colorValue: ColorValue(0x24292E))
    )

    public let markedTextBackgroundColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x24292E)),
        dark: UIColor(colorValue: ColorValue(0xF6F8FA))
    ).withAlphaComponent(0.1)
    public let markedTextBackgroundCornerRadius: CGFloat = 4

    public init() {}

    public func textColor(for rawHighlightName: String) -> UIColor? {
        guard let highlightName = HighlightName(rawHighlightName) else {
            return nil
        }
        switch highlightName {
        case .comment:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x6A737D)),
                dark: UIColor(colorValue: ColorValue(0x959DA5))
            )
        case .operator, .punctuation:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x032F62)),
                dark: UIColor(colorValue: ColorValue(0x79B8FF))
            )
        case .property:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x005CC5)),
                dark: UIColor(colorValue: ColorValue(0xC8E1FF))
            )
        case .function:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x24292E)),
                dark: UIColor(colorValue: ColorValue(0xF6F8FA))
            )
        case .string:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x032F62)),
                dark: UIColor(colorValue: ColorValue(0x79B8FF))
            )
        case .number:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x005CC5)),
                dark: UIColor(colorValue: ColorValue(0xC8E1FF))
            )
        case .keyword:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0xD73A49)),
                dark: UIColor(colorValue: ColorValue(0xEA4A5A))
            )
        case .variableBuiltin, .type:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0xD73A49)),
                dark: UIColor(colorValue: ColorValue(0xEA4A5A))
            )
        case .strong:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x24292E)),
                dark: UIColor(colorValue: ColorValue(0xF6F8FA))
            )
        case .emphasis:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x24292E)),
                dark: UIColor(colorValue: ColorValue(0xF6F8FA))
            )
        case .title:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x005CC5)),
                dark: UIColor(colorValue: ColorValue(0xC8E1FF))
            )
        case .reference:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x005CC5)),
                dark: UIColor(colorValue: ColorValue(0xC8E1FF))
            )
        case .literal:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x005CC5)),
                dark: UIColor(colorValue: ColorValue(0xC8E1FF))
            )
        case .uri:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x005CC5)),
                dark: UIColor(colorValue: ColorValue(0xC8E1FF))
            )
        case .none:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x24292E)),
                dark: UIColor(colorValue: ColorValue(0xF6F8FA))
            )
        case .variable:
            return UIColor(
                light: UIColor(colorValue: ColorValue(0x24292E)),
                dark: UIColor(colorValue: ColorValue(0xF6F8FA))
            )
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
