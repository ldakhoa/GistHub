import Runestone
import UIKit
//
// public final class TomorrowTheme: EditorTheme {
//    public let backgroundColor = UIColor(namedInModule: "TomorrowBackground")
//    public let userInterfaceStyle: UIUserInterfaceStyle = .light
//
//    public let font: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)
//    public let textColor = UIColor(namedInModule: "TomorrowForeground")
//
//    public let gutterBackgroundColor = UIColor(namedInModule: "TomorrowCurrentLine")
//    public let gutterHairlineColor = UIColor(namedInModule: "TomorrowComment")
//
//    public let lineNumberColor = UIColor(namedInModule: "TomorrowForeground").withAlphaComponent(0.5)
//    public let lineNumberFont: UIFont = .monospacedSystemFont(ofSize: 15, weight: .regular)
//
//    public let selectedLineBackgroundColor = UIColor(namedInModule: "TomorrowCurrentLine")
//    public let selectedLinesLineNumberColor = UIColor(namedInModule: "TomorrowForeground")
//    public let selectedLinesGutterBackgroundColor: UIColor = .clear
//
//    public let invisibleCharactersColor = UIColor(namedInModule: "TomorrowForeground").withAlphaComponent(0.7)
//
//    public let pageGuideHairlineColor = UIColor(namedInModule: "TomorrowForeground")
//    public let pageGuideBackgroundColor = UIColor(namedInModule: "TomorrowCurrentLine")
//
//    public let markedTextBackgroundColor = UIColor(namedInModule: "TomorrowForeground").withAlphaComponent(0.1)
//    public let markedTextBackgroundCornerRadius: CGFloat = 4
//
//    public init() {}
//
//    public func textColor(for rawHighlightName: String) -> UIColor? {
//        guard let highlightName = HighlightName(rawHighlightName) else {
//            return nil
//        }
//        switch highlightName {
//        case .comment:
//            return UIColor(namedInModule: "TomorrowComment")
//        case .operator, .punctuation:
//            return UIColor(namedInModule: "TomorrowForeground").withAlphaComponent(0.75)
//        case .property:
//            return UIColor(namedInModule: "TomorrowAqua")
//        case .function:
//            return UIColor(namedInModule: "TomorrowBlue")
//        case .string:
//            return UIColor(namedInModule: "TomorrowGreen")
//        case .number:
//            return UIColor(namedInModule: "TomorrowOrange")
//        case .keyword:
//            return UIColor(namedInModule: "TomorrowPurple")
//        case .variableBuiltin:
//            return UIColor(namedInModule: "TomorrowRed")
//        case .strong:
//            return UIColor(namedInModule: "TomorrowForeground")
//        case .emphasis:
//            return UIColor(namedInModule: "TomorrowForeground")
//        case .title:
//            return UIColor(namedInModule: "TomorrowBlue")
//        case .reference:
//            return UIColor(namedInModule: "TomorrowBlue")
//        case .literal:
//            return UIColor(namedInModule: "TomorrowBlue")
//        case .uri:
//            return UIColor(namedInModule: "TomorrowBlue")
//        case .none:
//            return UIColor(namedInModule: "TomorrowForeground")
//        case .variable:
//
//        case .type:
//
//        }
//    }
//
//    public func fontTraits(for rawHighlightName: String) -> FontTraits {
//        if let highlightName = HighlightName(rawHighlightName) {
//            if highlightName == .keyword ||
//               highlightName == .title {
//                return .bold
//            } else {
//                return []
//            }
//        } else {
//            return []
//        }
//    }
//  }
//
// private extension UIColor {
//    convenience init(namedInModule name: String) {
//        self.init(named: name, in: .module, compatibleWith: nil)!
//    }
// }
