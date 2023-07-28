//
//  ProfilePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject
import DesignSystem
import Models
import AppAccount
import Settings
import Environment

public struct ProfileView: View {
    @ObserveInjection private var inject

    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var routerPath: RouterPath

    public init() {}

    public var body: some View {
        UserProfileView(userName: currentAccount.user?.login ?? "")
    }
}
