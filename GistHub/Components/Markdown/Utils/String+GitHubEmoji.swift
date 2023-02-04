//
//  String+GitHubEmoji.swift
//  GistHub
//
//  Created by Khoa Le on 05/01/2023.
//

import Foundation

private let regex: NSRegularExpression = {
    let pattern = "(" + GithubEmojis.alias.map({ $0.key }).joined(separator: "|") + ")"
    return try! NSRegularExpression(pattern: pattern, options: [])
}()

extension String {

    var replacingGithubEmoji: String {
        let matches = regex.matches(in: self, options: [], range: nsrange)
        var replacedString = self
        for match in matches.reversed() {
            guard let substr = substring(with: match.range),
                let range = range(from: match.range),
                let emoji = GithubEmojis.alias[substr]
                else { continue }
            replacedString = replacedString.replacingCharacters(in: range, with: emoji.emoji)
        }
        return replacedString
    }

}
