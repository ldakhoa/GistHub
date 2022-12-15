//
//  EditorViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 15/12/2022.
//

import SwiftUI

@MainActor final class EditorViewModel: ObservableObject {
    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    func updateGist(gistID: String, fileName: String, content: String, completion: (() -> Void)? = nil) async throws {
        let gist = try await client.updateGist(
            fromGistID: gistID,
            description: nil,
            fileName: fileName,
            content: content
        )
        if gist.url != nil {
            completion!()
        }
    }
}
