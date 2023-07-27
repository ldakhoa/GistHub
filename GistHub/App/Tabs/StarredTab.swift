//
//  StarredTab.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Gist

struct StarredTab: View {
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
            GistListsView(listsMode: .starred) {
                GistListsViewModel(routerPath: routerPath)
            }
            .withAppRouter()
            .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
        }
        .onChange(of: $popToRootTab.wrappedValue) { popToRootTab in
            if popToRootTab != .starred {
                routerPath.path = []
            }
        }
        .withSafariRouter(isActiveTab: selectedTab == .starred)
        .environmentObject(routerPath)
    }
}
