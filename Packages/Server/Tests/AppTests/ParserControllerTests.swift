import XCTest
import SwiftSoup
@testable import App

final class ParserControllerTests: XCTestCase {
    private let stubbedUrlString = "https://gist.github.com/gisthubtester"

    func test_parse() {
        var parserController: ParserController

        parserController = ParserController(urlString: stubbedUrlString)
        XCTAssertEqual(parserController.parse().count, 11)

        let failureUrlString = "https://gist.github.com/gisthubtester1000"
        parserController = ParserController(urlString: failureUrlString)
        XCTAssertTrue(parserController.parse().isEmpty)
    }

    func test_parseGistsFromUrl() throws {
        let parserController = ParserController(urlString: stubbedUrlString)
        let stubbedGist = Gist(
            id: "7cf4d30ae24b39e622f199c98d314be5",
            updatedAt: nil,
            description: nil,
            comments: 0,
            owner: App.User(
                userName: "gisthubtester",
                avatarUrl: "https://avatars.githubusercontent.com/u/121019184?s=60&v=4"),
            stargazerCount: 1,
            fileCount: 1,
            files: ["test11.md": App.File(filename: "test11.md")]
        )

        let snippet = try XCTUnwrap(buildSnippet(from: parserController))
        let gist = try parserController.gist(fromSnippet: snippet)
        XCTAssertNoThrow(gist)
        XCTAssertEqual(gist, stubbedGist)
    }

    func testBuildPagingUrl() throws {
        let parserController = ParserController(urlString: stubbedUrlString)
        var index = 1

        XCTAssertNotNil(parserController.buildPagingUrl(withIndex: index))

        let pureUrl = try XCTUnwrap(parserController.buildPagingUrl(withIndex: index))
        XCTAssertEqual(pureUrl.absoluteString, stubbedUrlString)

        index = 10
        let pagingUrl = try XCTUnwrap(parserController.buildPagingUrl(withIndex: index))
        XCTAssertEqual(pagingUrl.absoluteString, "https://gist.github.com/gisthubtester?page=\(index)")
    }

    private func buildSnippet(from parserController: ParserController) throws -> Element? {
        let url = try XCTUnwrap(parserController.buildPagingUrl(withIndex: 1))
        let html = try String(contentsOf: url)
        let soup = try SwiftSoup.parse(html)

        let gistSnippets = try soup.select("div.gist-snippet")

        return gistSnippets.isEmpty() ? nil : gistSnippets.first()
    }
}
