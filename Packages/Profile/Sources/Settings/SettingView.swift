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
import Environment

public struct SettingView: View {

    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var routerPath: RouterPath
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var userDefaultsStore: UserDefaultsStore
//    @EnvironmentObject private var codeSettingsStore: CodeSettingsStore
//    @ObserveInjection private var inject

    // MARK: - Misc

    @State private var showConfirmationDialog: Bool = false

    // MARK: - Initializer

    public init() {}

    public var body: some View {
        List {
            Section {
                ButtonRowView(title: "Manage Accounts") {
                    routerPath.navigate(to: .settingsAccount)
                }

                ButtonRowView(title: "Code Options") {
                    routerPath.navigate(to: .editorCodeSettings)
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
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                    }
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
//        .enableInjection()
    }
}

fileprivate extension Colors {
    static let foreground = UIColor(light: .black, dark: .white)
}
