//
//  GitHubError.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation

struct GitHubError: LocalizedError, Codable, Equatable {
    /// A message that describes why the error did occur.
    let message: String

    public var errorDescription: String? { message }
}
