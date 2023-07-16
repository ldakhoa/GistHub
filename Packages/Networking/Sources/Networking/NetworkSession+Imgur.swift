import Foundation
import Networkable

public extension NetworkSession {
    static var imgur: NetworkSession {
        buildSession(urlString: "https://api.imgur.com/3/")
    }

    private static func buildSession(urlString: String) -> NetworkSession {
        let baseURL = URL(string: urlString)
        let requestBuilder = URLRequestBuilder(baseURL: baseURL)
        let logging = LoggingMiddleware(type: .info)
        let statusCodeValidation = StatusCodeValidationMiddleware()
        let middlewares: [Middleware] = [
            logging,
            ErrorDecoderMiddleware<ImgurError>(),
            statusCodeValidation
        ]
        let result = NetworkSession(requestBuilder: requestBuilder, middlewares: middlewares)
        return result
    }
}
