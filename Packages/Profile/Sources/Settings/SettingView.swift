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

    // MARK: - Dependencies

    private let user: User
    private let sessionManager: GitHubSessionManager
    private let logoutAction: () -> Void

    @ObserveInjection private var inject

    // MARK: - Misc

    @State private var showConfirmationDialog: Bool = false
    @State private var showReportABug: Bool = false

    // MARK: - Initializer

    public init(
        user: User,
        sessionManager: GitHubSessionManager,
        logoutAction: @escaping () -> Void,
        showConfirmationDialog: Bool = false
    ) {
        self.user = user
        self.sessionManager = sessionManager
        self.logoutAction = logoutAction
        self.showConfirmationDialog = showConfirmationDialog
    }

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
                Button {
                    showReportABug.toggle()
                } label: {
                    HStack {
                        Text("Report a Bug")
                            .foregroundColor(Colors.foreground.color)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                    }
                }
                .sheet(isPresented: $showReportABug) {
                    ReportABugView()
                }

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
