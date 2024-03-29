//
//  ProfileViewModel.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Combine
import Networking
import Models

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var contentState: ContentState = .loading
    @Published private(set) var user: User = .stubbed

    private let client: UserAPIClient

    init(client: UserAPIClient = DefaultUserAPIClient()) {
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

    func fetchUser(fromUserName userName: String) async {
        do {
            let user = try await client.user(fromUserName: userName)
            contentState = .content(user: user)
            self.user = user
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
