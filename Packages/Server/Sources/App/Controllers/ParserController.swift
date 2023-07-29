import Foundation
import SwiftSoup

public final class ParserController {
    private let urlString: String

    public init(urlString: String) {
        self.urlString = urlString
    }

    public func parse() -> [Gist] {
        var index = 1
        var gists: [Gist] = []

        while index > 0 {
            let gistsFromUrl = gistsFromUrl(withIndex: index)

            if gistsFromUrl.isEmpty {
                break
            }

            gists.append(contentsOf: gistsFromUrl)
            index += 1
        }
        return gists
    }

    private func gistsFromUrl(withIndex index: Int) -> [Gist] {
        do {
            guard let url = buildPagingUrl(withIndex: index) else { return [] }

            print("Parsing Gists from \(url)...")

            let html = try String(contentsOf: url)
            let soup = try SwiftSoup.parse(html)
            let gistSnippets = try soup.select("div.gist-snippet")

            var gists: [Gist] = []

            for snippet in gistSnippets {
                var gist = Gist()
                var user = User()

                // Avatar user
                if let avatar = try snippet.select("img[src*=avatars.githubusercontent.com]").first() {
                    let avatarURL = try avatar.attr("src")
                    user.avatarUrl = avatarURL
                }

                // Title
                if let fileName = try snippet.select("a[href*=gist] strong").first()?.text() {
                    let file = File(filename: fileName)
                    let files: [String: File] = [fileName: file]
                    gist.files = files
                }

                // Gist url
                if let gistUrlString = try snippet.select("a[href*=gist]").first()?.attr("href"),
                   let gistUrl = URL(string: gistUrlString) {
                    let username = gistUrl.pathComponents[1]
                    user.userName = username

                    let gistId = gistUrl.pathComponents[2]
                    gist.id = gistId
                }

                // File count
                if let fileCountElement = try snippet.select("a[href*=/\(user.userName!)/\(gist.id!)]").first() {
                    let fileCount = try fileCountElement
                        .text()
                        .components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()
                    gist.fileCount = Int(fileCount)
                }

                // Comment count
                if let commentLink = try snippet.select("a[href*=comments]").first() {
                   let commentCount = try commentLink
                        .text()
                        .components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()
                    gist.comments = Int(commentCount)
                }

                // Stargazers count
                if let stargazersLink = try snippet.select("a[href$=/stargazers]").first() {
                    let stargazerCount = try stargazersLink
                        .text()
                        .components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()
                    gist.stargazerCount = Int(stargazerCount)
                }

                gist.owner = user
                gists.append(gist)
            }

            return gists
        } catch {
            // TODO: Handle error
        }

        return []
    }

    private func buildPagingUrl(withIndex index: Int) -> URL? {
        index >= 2 ? URL(string: "\(urlString)?page=\(index)") : URL(string: urlString)
    }
}
