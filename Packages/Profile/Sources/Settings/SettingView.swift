//
//  SettingView.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import SwiftUI
import AppAccount
import Models
import DesignSystem
import Editor
import Utilities
import Environment
import Networking

public struct SettingView: View {

    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var routerPath: RouterPath
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var userDefaultsStore: UserDefaultsStore

    // MARK: - Misc

    @State private var showConfirmationDialog: Bool = false

    // MARK: - Initializer

    public init() {}

    public var body: some View {
        List {
            Section {
                Link(destination: reviewAccessUrl) {
                    HStack {
                        Text("Review GitHub Access")
                            .foregroundColor(Colors.foreground.color)
                        Spacer()
                        RightChevronRowImage()
                    }
                }

                ButtonRowView(title: "Manage Accounts") {
                    routerPath.navigate(to: .settingsAccount)
                }
            }

            Section {
                ButtonRowView(title: "Report a Bug") {
                    routerPath.presentedSheet = .reportABug
                }

                Link(destination: URL(string: AppInfo.repoWeblink)!) {
                    HStack {
                        Text("View GistHub Repo")
                            .foregroundColor(Colors.foreground.color)
                        Spacer()
                        RightChevronRowImage()
                    }
                }

                ButtonRowView(title: "Code Options") {
                    routerPath.navigate(to: .editorCodeSettings)
                }

                Toggle(isOn: $userDefaultsStore.openExternalsLinksInSafari) {
                    Text("Open external links in Safari")
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
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarRole(.automatic)
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            "Are you sure?",
            isPresented: $showConfirmationDialog,
            titleVisibility: .visible
        ) {
            Button("Sign out", role: .destructive) {
                appAccountsManager.logout()
            }
        } message: {
            Text("You will be signed out from all of your accounts. Do you want to sign out?")
        }
    }

    private var reviewAccessUrl: URL {
        guard let url = URLBuilder
            .github()
            .add(paths: ["settings", "connections", "applications", Secrets.GitHub.clientId])
            .url
        else {
            return URLBuilder.github().url!
        }
        return url
    }
}

fileprivate extension Colors {
    static let foreground = UIColor(light: .black, dark: .white)
}
