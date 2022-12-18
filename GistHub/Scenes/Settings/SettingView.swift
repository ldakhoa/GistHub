//
//  SettingView.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import SwiftUI
import Inject

struct SettingView: View {
    let user: User
    let sessionManager: GitHubSessionManager
    let logoutAction: () -> Void

    @ObserveInjection private var inject
    @State private var showConfirmationDialog = false

    var body: some View {
        List {
            Section {
                NavigationLink("Manage Accounts") {
                    SettingAccountView(user: user, sessionManager: sessionManager)
                }
            }

            Section {
                Button("Sign Out") {
                    showConfirmationDialog.toggle()
                }
                .foregroundColor(Colors.danger.color)
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog("Are you sure?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Sign out", role: .destructive) {
                logoutAction()
            }
        } message: {
            Text("You will be signed out from all of your accounts. Do you want to sign out?")
        }
        .enableInjection()
    }
}
