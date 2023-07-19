//
//  HomeTab.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Gist

struct HomeTab: View {
    @StateObject private var routerPath: RouterPath = RouterPath()

    var body: some View {
        NavigationStack(path: $routerPath.path) {
            GistListsView(listsMode: .allGists) {
                GistListsViewModel(routerPath: routerPath)
            }
            .withAppRouter()
            .withSheetDestinations(sheetDestinations: $routerPath.presentedSheet)
        }
    }
}
