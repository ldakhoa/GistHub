//
//  StarredTab.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Profile

struct StarredTab: View {
    @StateObject private var routerPath: RouterPath = RouterPath()

    var body: some View {
        NavigationStack(path: $routerPath.path) {
            Text("Starred")
        }
    }
}
