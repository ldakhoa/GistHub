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

    func createGist(
        description: String? = nil,
        files: [String: File]
    ) async {
        _ = try? await client.create(description: description, files: files)
    }

}
