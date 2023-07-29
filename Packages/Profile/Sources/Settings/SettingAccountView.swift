//
//  SettingAccountView.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import Inject
import SwiftUI
import Models
import DesignSystem
import AppAccount
import Environment

public struct SettingAccountView: View {
    @ObserveInjection private var inject
    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var currentAccount: CurrentAccount

    public init() {}

    public var body: some View {
        List {
            ForEach(appAccountsManager.userSessions) { userSession in
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
