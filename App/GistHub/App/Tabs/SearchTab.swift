//
//  StarredTab.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Gist
import Search

struct SearchTab: View {
    @EnvironmentObject private var currentAccount: CurrentAccount
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
            SearchView()
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
        }
        .onChange(of: $popToRootTab.wrappedValue) { popToRootTab in
            if popToRootTab != .search {
                routerPath.path = []
            }
        }
        .withSafariRouter(isActiveTab: selectedTab == .search)
        .environmentObject(routerPath)
    }
}
