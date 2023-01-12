//
//  NewGistViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 12/01/2023.
//

import SwiftUI

@MainActor final class NewGistViewModel: ObservableObject {
    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    @discardableResult
    func createGist(
        description: String? = nil,
        files: [String: File],
        public: Bool
    ) async throws -> Gist {
        try await client.create(description: description, files: files, public: `public`)
    }

}
