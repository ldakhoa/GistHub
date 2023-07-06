//
//  URLBuilder.swift
//  GistHub
//
//  Created by Khoa Le on 17/12/2022.
//

import Foundation

public final class URLBuilder {
    private var components = URLComponents()
    private var pathComponents = [String]()

    public init(host: String, scheme: String) {
        components.host = host
        components.scheme = scheme
    }

    public convenience init(host: String, https: Bool = true) {
        self.init(host: host, scheme: https ? "https" : "http")
    }

    public static func github() -> URLBuilder {
        return URLBuilder(host: "github.com", https: true)
    }

    @discardableResult
    public func add(path: LosslessStringConvertible) -> URLBuilder {
        pathComponents.append(String(describing: path))
        return self
    }

    @discardableResult
    public func add(paths: [LosslessStringConvertible]) -> URLBuilder {
        paths.forEach { self.add(path: $0) }
        return self
    }

    @discardableResult
    public func add(item: String, value: LosslessStringConvertible) -> URLBuilder {
        var items = components.queryItems ?? []
        items.append(URLQueryItem(name: item, value: String(describing: value)))
        components.queryItems = items
        return self
    }

    public var url: URL? {
        var components = self.components
        if !pathComponents.isEmpty {
            components.path = "/" + pathComponents.joined(separator: "/")
        }
        return components.url
    }

}
