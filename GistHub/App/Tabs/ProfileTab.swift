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

    var body: some View {
        NavigationStack(path: $routerPath.path) {
            ProfileView()
                .withAppRouter()
                .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
        }
        .withSafariRouter()
        .environmentObject(routerPath)
    }
}
