//
//  ProfileTab.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Profile

struct ProfileTab: View {
    @StateObject private var routerPath: RouterPath = RouterPath()

    @Binding var popToRootTab: Tab

    init(popToRootTab: Binding<Tab>) {
        _popToRootTab = popToRootTab
    }

    var body: some View {
        NavigationStack(path: $routerPath.path) {
            ProfileView()
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
        }
        .onChange(of: $popToRootTab.wrappedValue) { popToRootTab in
            if popToRootTab != .profile {
                routerPath.path = []
            }
        }
        .withSafariRouter()
        .environmentObject(routerPath)
    }
}
