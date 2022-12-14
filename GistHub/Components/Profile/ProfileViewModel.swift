//
//  ProfileViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Combine

protocol ProfileDelegate: AnyObject {
    func shouldLogout()
}

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading
    weak var delegate: ProfileDelegate?

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

    func logout() {
        delegate?.shouldLogout()
    }
}

extension ProfileViewModel {
    enum ContentState {
        case loading
        case content(user: User)
        case error(error: String)
    }
}
