//
//  SettingAccountView.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import Inject
import SwiftUI

struct SettingAccountView: View {
    @ObserveInjection private var inject
    private let user: User
    private let sessionManager: GitHubSessionManager

    init(user: User, sessionManager: GitHubSessionManager) {
        self.user = user
        self.sessionManager = sessionManager
    }

    var body: some View {
        List {
            ForEach(sessionManager.userSessions) { userSession in
                HStack {
                    Text(userSession.username ?? "")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill").foregroundColor(Colors.accent.color)
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Accounts")
        .enableInjection()
    }
}
