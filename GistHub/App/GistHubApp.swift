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
import WhatsNewKit

@main
struct GistHubApp: App {
    @State private var selectedTab: Tab = .home
    @State private var showLogin: Bool = false
    @State private var popToRootTab: Tab = .other
    @StateObject private var appAccountManager = AppAccountsManager.shared
    @StateObject private var currentAccount = CurrentAccount.shared
    @StateObject private var codeSettings = CodeSettingsStore.shared

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
                .environmentObject(codeSettings)
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
                .sheet(
                    whatsNew: self.$whatsNew,
                    versionStore: UserDefaultsWhatsNewVersionStore()
                )
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
        })) {
            ForEach(tabs) { tab in
                tab.makeContentView(popToRootTab: $popToRootTab)
                    .tabItem {
                        Image(uiImage: UIImage(named: selectedTab == tab ? tab.iconSelectedName : tab.iconName)!)
                        Text(tab.title)
                    }
                    .tag(tab)
            }
        }
        .background(UIColor.systemBackground.color)
        .tint(Colors.accent.color)
    }

    private func setupEnv() {
        Task {
            await currentAccount.fetchCurrentUser()
        }
    }

    @State
    private var whatsNew: WhatsNew? = WhatsNew(
        version: "1.0.5",
        title: "What's New in GistHub",
        features: [
            .init(
                image: .init(systemName: "safari"),
                title: "Open in GistHub",
                subtitle: "Easily open gists in GistHub app from Safari for quick access, commenting, and browsing."
            ),
            .init(
                image: .init(systemName: "doc.text.image"),
                title: "Upload image in Gist markdown",
                subtitle: "Effortlessly include images in your Markdown gists by uploading them directly within the app."
            ),
            .init(
                image: .init(systemName: "pencil.circle"),
                title: "Edit a Gist",
                subtitle: "Update gist description and files right in the GistHub app, making changes on the go."
            ),
            .init(
                image: .init(systemName: "exclamationmark.bubble"),
                title: "Report a Bug",
                subtitle: "Instantly report bugs within GistHub app, eliminating the need to raise issues on GitHub."
            )
        ],
        primaryAction: WhatsNew.PrimaryAction(
            title: "Continue",
            backgroundColor: Colors.accent.color,
            foregroundColor: .white
        ),
        secondaryAction: WhatsNew.SecondaryAction(
            title: "Learn more",
            foregroundColor: Colors.accent.color,
            action: .openURL(URL(string: "https://github.com/ldakhoa/GistHub/releases/tag/1.0.5"))
        )
    )
}
