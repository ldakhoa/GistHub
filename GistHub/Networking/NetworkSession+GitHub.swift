import Foundation
import Networkable

extension NetworkSession {
    public static var github: NetworkSession {
        let baseURL = URL(string: "https://api.github.com")
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
}
