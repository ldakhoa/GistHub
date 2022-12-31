import Foundation

#if DEBUG
private var previousUnrecognizedHighlightNames: [String] = []
#endif

enum HighlightName: String {
    case comment
    case function
    case keyword
    case number
    case `operator`
    case property
    case punctuation
    case string
    case variableBuiltin = "variable.builtin"
    case strong = "text.strong"
    case emphasis = "text.emphasis"
    case title = "text.title"
    case reference = "text.reference"
    case literal = "text.literal"
    case uri = "text.uri"
    case none

    public init?(_ rawHighlightName: String) {
        var comps = rawHighlightName.split(separator: ".")
        while !comps.isEmpty {
            let candidateRawHighlightName = comps.joined(separator: ".")
            if let highlightName = Self(rawValue: candidateRawHighlightName) {
                self = highlightName
                return
            }
            comps.removeLast()
        }
#if DEBUG
        if !previousUnrecognizedHighlightNames.contains(rawHighlightName) {
            previousUnrecognizedHighlightNames.append(rawHighlightName)
            print("Unrecognized highlight name: '\(rawHighlightName)'."
                  + " Add the highlight name to HighlightName.swift if you want to add support for syntax highlighting it."
                  + " This message will only be shown once per highlight name.")
        }
#endif
        return nil
    }
}
