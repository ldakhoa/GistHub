//
//  ErrorDecoderMiddleware.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import Networkable

/// A middleware that determines whether a response is unsuccessfu to decode instances of an error type.
struct ErrorDecoderMiddleware<Failure>: Middleware where Failure: Error & Decodable {
    // MARK: Dependencies

    /// A range of HTTP response status codes that specifies a response is success.
    let successfulStatusCodes: ResponseStatusCodes

    /// An object that decodes instances of a data type from JSON objects.
    let decoder: JSONDecoder

    // MARK: Init

    init(
        successfulStatusCodes: ResponseStatusCodes = .success,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.successfulStatusCodes = successfulStatusCodes
        self.decoder = decoder
    }

    // MARK: Middleware

    func prepare(request: URLRequest) throws -> URLRequest { request }

    func willSend(request: URLRequest) {}

    func didReceive(response: URLResponse, data: Data) throws {
        // Verifies the response is an instance of `HTTPURLResponse`.
        guard let response = response as? HTTPURLResponse else { return }
        // Verifies the status code is unsuccessful.
        guard !successfulStatusCodes.contains(response.statusCode) else { return }
        // Try to decode an error.
        guard let result = try? decoder.decode(Failure.self, from: data) else { return }
        // Throw the result.
        throw result
    }

    func didReceive(error: Error, of request: URLRequest) {}
}
