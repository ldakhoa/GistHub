//
//  SettingView.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import SwiftUI
import Inject
import AppAccount
import Models
import DesignSystem
import Editor
import Utilities

public struct SettingView: View {
    let user: User
    let sessionManager: GitHubSessionManager
    let logoutAction: () -> Void

    @ObserveInjection private var inject
    @State private var showConfirmationDialog = false

    public var body: some View {
        List {
            Section {
                NavigationLink("Manage Accounts") {
                    SettingAccountView(user: user, sessionManager: sessionManager)
                }
                NavigationLink("Code Options") {
                    EditorCodeSettingsView()
                }
            }

            Section {
                Link(destination: URL(string: "https://github.com/ldakhoa/GistHub")!) {
                    HStack {
                        Text("View GistHub Repo")
                            .foregroundColor(Colors.foreground.color)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                    }
                }
            }

            Section {
                Button("Sign Out") {
                    showConfirmationDialog.toggle()
                }
                .foregroundColor(Colors.danger.color)
            }

            Section {

            } header: {
                HStack {
                    Spacer()
                    Text(Bundle.main.prettyVersionString)
                        .font(.body)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .textCase(nil)
                    Spacer()
                }
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

fileprivate extension Colors {
    static let foreground = UIColor(light: .black, dark: .white)
}
