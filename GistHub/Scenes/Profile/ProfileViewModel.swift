//
//  ProfileViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Combine

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading

    private let client: GistHubAPIClient

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    func fetchUser() async {
        do {
            let user = try await client.user()
            contentState = .content(user: user)
        } catch {
            contentState = .error(error: error.localizedDescription)
        }
    }
}

extension ProfileViewModel {
    enum ContentState {
        case loading
        case content(user: User)
        case error(error: String)
    }
}
