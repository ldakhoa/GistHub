//
//  HomeTab.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Home
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
            HomeView()
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
        version: "1.1.0",
        title: "What's New in GistHub",
        features: [
            .init(
                image: .init(systemName: "person.crop.circle.badge.questionmark"),
                title: "Profile View",
                subtitle: "Get to know fellow Gist users with detailed profiles, all gists and starred gists."
            ),
            .init(
                image: .init(systemName: "magnifyingglass.circle"),
                title: "Discover Gists",
                subtitle: "Explore curated and trending gists to expand your knowledge."
            ),
            .init(
                image: .init(systemName: "star"),
                title: "Stargazer",
                subtitle: "See the popularity of gists which displays the number of users who have starred each gist."
            ),
            .init(
                image: .init(systemName: "note.text"),
                title: "New editor theme",
                subtitle: "Enhance your coding and viewing experience with a fresh and modern visual style."
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
            action: .openURL(URL(string: "https://github.com/ldakhoa/GistHub/releases/tag/1.1.0"))
        )
    )
}
