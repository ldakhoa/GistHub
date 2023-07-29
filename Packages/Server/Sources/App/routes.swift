import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "Hello from GistHub"
    }

    app.get("users", ":username" ,"starred") { req async -> [Gist] in
        guard let username = req.parameters.get("username") else {
            return []
        }

        let urlString = "\(Constants.host)/\(username)/starred"
        let parser = ParserController(urlString: urlString)
        let gists = parser.parse()

        return gists
    }
}

enum Constants {
    static let host = "https://gist.github.com"
}
