//
//  EditGistViewModel.swift
//  GistHub
//
//  Created by Hung Dao on 26/02/2023.
//

import SwiftUI
import OrderedCollections

@MainActor final class EditGistViewModel: ObservableObject {
    private let client: GistHubAPIClient
    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }
    @discardableResult
    func updateGist(
        gistID: String,
        description: String?,
        files: OrderedDictionary<String, File>
    ) async throws -> Gist {
        var filesWithContent = [String: String?]()
        for file in files {
            filesWithContent[file.key] = file.value.content
        }
        return try await client.updateGist(
            fromGistID: gistID,
            description: description,
            files: filesWithContent
        )
    }

}
