import Foundation
import Networkable

public extension NetworkSession {
    static var github: NetworkSession {
        buildSession(urlString: "https://api.github.com")
    }

    static var accessToken: NetworkSession {
        buildSession(urlString: "https://github.com")
    }

    private static func buildSession(urlString: String) -> NetworkSession {
        let baseURL = URL(string: urlString)
        let requestBuilder = URLRequestBuilder(baseURL: baseURL)
        let logging = LoggingMiddleware(type: .info)
        let statusCodeValidation = StatusCodeValidationMiddleware()
        let middlewares: [Middleware] = [
            logging,
            ErrorDecoderMiddleware<GitHubError>(),
            statusCodeValidation
        ]
        let result = NetworkSession(requestBuilder: requestBuilder, middlewares: middlewares)
        return result
    }

    func data<T: Codable>(for request: Request) async throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try await self.data(for: request, decoder: decoder)
    }
}
