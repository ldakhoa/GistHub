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
    @StateObject private var currentAccount = CurrentAccount.shared

    private var tabs: [Tab] = Tab.loggedInTabs()

    // TODO: Migrate to AppAccountManager when done
    private let sessionManager = GitHubSessionManager()

    var body: some Scene {
        WindowGroup {
            appView
                .onAppear {
                    setupEnv()
                }
                .environmentObject(currentAccount)
        }
    }

    @ViewBuilder
    private var appView: some View {
        if sessionManager.focusedUserSession != nil {
            tabBarView
        } else {
            // show login
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
