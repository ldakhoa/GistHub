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
import Gist

@main
struct GistHubApp: App {
    @State private var selectedTab: Tab = .home
    @State private var showLogin: Bool = false
    @State private var popToRootTab: Tab = .other
    @State private var prevSelectedTab: Tab = .home
    @State private var openNewGist: Bool = false

    @StateObject private var appAccountManager = AppAccountsManager.shared
    @StateObject private var currentAccount = CurrentAccount.shared
    @StateObject private var userDefaultsStore = UserDefaultsStore.shared

    private var tabs: [Tab] {
        appAccountManager.isAuth ? Tab.loggedInTabs() : Tab.loggedOutTabs()
    }

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
                .environmentObject(userDefaultsStore)
                .onChange(of: appAccountManager.focusedAccount) { appAccount in
                    if appAccount == nil {
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
        TabView(selection: .init(get: {
            selectedTab
        }, set: { newTab in
            if newTab == selectedTab {
                popToRootTab = .other
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    popToRootTab = selectedTab
                }
                HapticManager.shared.fireHaptic(of: .tabSelection)
            }
            selectedTab = newTab

            if selectedTab == .newGist {
                HapticManager.shared.fireHaptic(of: .tabSelection)
                openNewGist.toggle()
                selectedTab = prevSelectedTab
            } else {
                prevSelectedTab = newTab
            }
        })) {
            ForEach(tabs) { tab in
                tab.makeContentView(popToRootTab: $popToRootTab, selectedTab: $selectedTab)
                    .tabItem {
                        Image(uiImage: UIImage(named: selectedTab == tab ? tab.iconSelectedName : tab.iconName)!)
                        Text(tab.title)
                    }
                    .tag(tab)
            }
        }
        .background(UIColor.systemBackground.color)
        .tint(Colors.accent.color)
        .sheet(isPresented: $openNewGist) {
            ComposeGistView(style: .createGist) { newGist in
                guard let htmlURL = newGist.htmlURL, let url = URL(string: htmlURL) else { return }
                NotificationCenter.default.post(name: .openGistDetailFromURL, object: url)
            }
        }
    }

    private func setupEnv() {
        Task {
            await currentAccount.fetchCurrentUser()
        }
        selectedTab = .home
    }
}
