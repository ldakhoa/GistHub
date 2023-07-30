//
//  HomeTab.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Gist
import WhatsNewKit
import DesignSystem

struct HomeTab: View {
    @StateObject private var routerPath: RouterPath = RouterPath()
    @Binding var selectedTab: Tab
    @Binding var popToRootTab: Tab

    init(
        selectedTab: Binding<Tab>,
        popToRootTab: Binding<Tab>
    ) {
        _selectedTab = selectedTab
        _popToRootTab = popToRootTab
    }

    var body: some View {
        NavigationStack(path: $routerPath.path) {
            GistListsView(listsMode: .currentUserGists)
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
        }
        .onChange(of: $popToRootTab.wrappedValue) { popToRootTab in
            if popToRootTab != .home {
                routerPath.path = []
            }
        }
        .withSafariRouter(isActiveTab: selectedTab == .home)
        .environmentObject(routerPath)
        .sheet(
            whatsNew: self.$whatsNew,
            versionStore: UserDefaultsWhatsNewVersionStore()
        )
    }

    // Only show at Home Tab when login
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
