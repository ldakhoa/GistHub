//
//  DiscoverTab.swift
//  GistHub
//
//  Created by Khoa Le on 02/08/2023.
//

import SwiftUI
import Environment
import Gist
import DesignSystem

struct DiscoverTab: View {
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
            if popToRootTab != .discover {
                routerPath.path = []
            }
        }
        .withSafariRouter(isActiveTab: selectedTab == .discover)
        .environmentObject(routerPath)
    }
}
