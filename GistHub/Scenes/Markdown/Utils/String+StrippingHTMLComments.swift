import Foundation

extension String {
    var strippingHTMLComments: String {
        guard let regex = try? NSRegularExpression(pattern: "<!--((.|\n|\r)*?)-->") else { return "" }
        let matches = regex.matches(in: self, options: [], range: nsrange)
        guard matches.count > 0 else { return self }
        var string = self
        for match in matches.reversed() {
            guard let range = range(from: match.range) else { continue }
            string.replaceSubrange(range, with: "")
        }
        return string
    }
}
