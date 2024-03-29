//
//  EditorViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 15/12/2022.
//

import SwiftUI
import Networking
import Models

@MainActor
final class EditorViewModel: ObservableObject {
    private let client: GistHubAPIClient
    private let imgurClient: ImgurAPIClient

    init(
        client: GistHubAPIClient = DefaultGistHubAPIClient(),
        imgurClient: ImgurAPIClient = DefaultImgurAPIClient()
    ) {
        self.client = client
        self.imgurClient = imgurClient
    }

    func updateGist(
        gistID: String,
        files: [String: File?],
        completion: (() -> Void)? = nil
    ) async throws {
        let gist = try await client.updateGist(fromGistID: gistID, description: nil, files: files)
        if gist.url != nil {
            completion?()
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
            completion?()
        }
    }

    func uploadImage(base64Image: String) async throws -> ImgurImage {
        try await imgurClient.upload(base64Image: base64Image)
    }

    func getCredits() async throws -> ImgurCredits {
        try await imgurClient.credits()
    }
}
