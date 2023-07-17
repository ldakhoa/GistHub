import Foundation
import Networkable

public extension NetworkSession {

    static var github: NetworkSession {
        buildSession(urlString: "https://api.github.com", errorType: GitHubError.self)
    }

    static var accessToken: NetworkSession {
        buildSession(urlString: "https://github.com", errorType: GitHubError.self)
    }

    static var imgur: NetworkSession {
        buildSession(urlString: "https://api.imgur.com/3/", errorType: ImgurError.self)
    }

    private static func buildSession<Failure>(urlString: String, errorType: Failure.Type) -> NetworkSession where Failure: Error & Decodable {
        let baseURL = URL(string: urlString)
        let requestBuilder = URLRequestBuilder(baseURL: baseURL)
        let logging = LoggingMiddleware(type: .info)
        let statusCodeValidation = StatusCodeValidationMiddleware()
        let middlewares: [Middleware] = [
            logging,
            ErrorDecoderMiddleware<Failure>(),
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

    func imgurData<T: Codable>(for request: Request) async throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let response: ImgurResponse<T> = try await self.data(for: request, decoder: decoder)
        return response.data
    }
}
