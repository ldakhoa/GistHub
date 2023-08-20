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
        version: "1.2.0",
        title: "What's New in GistHub",
        features: [
            .init(
                image: .init(systemName: "house.circle"),
                title: "New UI",
                subtitle: "Enjoy a fresh look with Recent Activities and easier gist selection."
            ),
            .init(
                image: .init(systemName: "magnifyingglass.circle"),
                title: "Global Search",
                subtitle: "Find global gists and user profiles effortlessly with our enhanced search feature."
            ),
            .init(
                image: .init(systemName: "fork.knife.circle"),
                  title: "View Forked Gists",
                  subtitle: "View Forked Gists: Explore forked gists from any user in our open-source community."
            ),
            .init(
                image: .init(systemName: "square.and.arrow.up.circle"),
                title: "Share Things",
                subtitle: "Share gists, files, comments, and profiles easily with our improved sharing options."
            ),
            .init(
                image: .init(systemName: "point.3.connected.trianglepath.dotted"),
                title: "Explore Followers and Following User's Gists",
                subtitle: "Discover and view gist profiles of your followers and the users you follow."
            )
        ],
        primaryAction: WhatsNew.PrimaryAction(
            title: "Explore now",
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
