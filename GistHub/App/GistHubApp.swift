//
//  GistHubApp.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import DesignSystem
import AppAccount
import Environment
import Login

@main
struct GistHubApp: App {
//    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    @State private var selectedTab: Tab = .home
    @State private var showLogin: Bool = false
    @StateObject private var appAccountManager = AppAccountsManager.shared
    @StateObject private var currentAccount = CurrentAccount.shared

    private var tabs: [Tab] {
        appAccountManager.isAuth ? Tab.loggedInTabs() : Tab.loggedOutTabs()
    }

    // TODO: Migrate to AppAccountManager when done
//    private let sessionManager = GitHubSessionManager()

    var body: some Scene {
        WindowGroup {
            tabBarView
                .onAppear {
                    if appAccountManager.isAuth {
                        setupEnv()
                    } else {
                        showLogin.toggle()
                    }
                }
                .environmentObject(currentAccount)
                .environmentObject(appAccountManager)
                .onChange(of: appAccountManager.focusedAccount) { appAccount in
                    if appAccount == nil {
                        // present login
                        showLogin.toggle()
                    }
                    setupEnv()
                }
                .fullScreenCover(isPresented: $showLogin) {
                    LoginView()
                        .environmentObject(appAccountManager)
                }
        }
    }

    private var tabBarView: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabs) { tab in
                tab.makeContentView()
                    .tabItem {
                        Image(uiImage: UIImage(named: selectedTab == tab ? tab.iconSelectedName : tab.iconName)!)
                        Text(tab.title)
                    }
                    .tag(tab)
            }
        }
        .tint(Colors.accent.color)
    }

    private func setupEnv() {
        Task {
            await currentAccount.fetchCurrentUser()
        }
    }
}
