//
//  GistHubApp.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import DesignSystem

@main
struct GistHubApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    @State private var selectedTab: Tab = .home

    private var tabs: [Tab] = Tab.loggedInTabs()

    var body: some Scene {
        WindowGroup {
            tabBarView
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

}
