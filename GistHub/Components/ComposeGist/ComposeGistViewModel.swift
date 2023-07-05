//
//  ComposeGistViewModel.swift
//  GistHub
//
//  Created by Hung Dao on 27/02/2023.
//
import SwiftUI
import OrderedCollections

@MainActor final class ComposeGistViewModel: ObservableObject {
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

    @discardableResult
    func updateGist(
        gistID: String,
        description: String?,
        files: [String: File]
    ) async throws -> Gist {
        try await client.updateGist(
            fromGistID: gistID,
            description: description,
            files: files
        )
    }

}
