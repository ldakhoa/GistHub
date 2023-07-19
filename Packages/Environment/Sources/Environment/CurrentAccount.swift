//
//  File.swift
//  
//
//  Created by Khoa Le on 19/07/2023.
//

import Foundation
import Networking
import Models

@MainActor
public class CurrentAccount: ObservableObject {
    public static let shared = CurrentAccount()

    @Published public private(set) var user: User?
    @Published public private(set) var isLoadingUser: Bool = false

    private let client: GistHubAPIClient

    public init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
    }

    public func fetchCurrentUser() async {
        if user == nil {
            isLoadingUser = true
        }
        user = try? await client.user()
        isLoadingUser = false
    }
}
