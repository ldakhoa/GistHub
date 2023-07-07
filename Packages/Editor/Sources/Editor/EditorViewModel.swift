//
//  EditorViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 15/12/2022.
//

import SwiftUI
import Networking

@MainActor final class EditorViewModel: ObservableObject {
    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    func updateGist(
        gistID: String,
        fileName: String,
        content: String,
        completion: (() -> Void)? = nil
    ) async throws {
        let gist = try await client.updateGist(
            fromGistID: gistID,
            fileName: fileName,
            content: content
        )
        if gist.url != nil {
            completion!()
        }
    }

    func deleteGist(
        gistID: String,
        fileName: String,
        completion: (() -> Void)? = nil
    ) async throws {
        let gist = try await client.updateGist(
            fromGistID: gistID,
            fileName: fileName,
            content: nil
        )
        if gist.url != nil {
            completion!()
        }
    }

    func updateDescription(
        _ description: String,
        gistID: String,
        completion: (() -> Void)? = nil
    ) async throws {
        let gist = try await client.updateDescription(
            fromGistID: gistID,
            description: description
        )
        if gist.url != nil {
            completion!()
        }
    }
}
