//
//  ProfilePage.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject
import DesignSystem
import Models
import AppAccount
import Settings
import Environment

public struct ProfileView: View {
    @ObserveInjection private var inject

    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var routerPath: RouterPath

    @StateObject private var viewModel = ProfileViewModel()

    public init() {}

    public var body: some View {
        //        ZStack {
        //            if let user = currentAccount.user {
        //                makeMainView(user: user)
        //            } else {
        //                switch viewModel.contentState {
        //                case .loading:
        //                    makeMainView(user: .stubbed)
        //                        .redacted(reason: .placeholder)
        //                case let .content(user):
        //                    makeMainView(user: user)
        //                case let .error(error):
        //                    Text(error)
        //                        .foregroundColor(Colors.danger.color)
        //                }
        //            }
        //        }
        UserProfileView(userName: "ldakhoa")
        //        .navigationBarTitleDisplayMode(.inline)
        //        .toolbar {
        //            ToolbarItem(placement: .navigationBarTrailing) {
        //                HStack {
        //                    Button {
        //                        routerPath.navigate(to: .settings)
        //                    } label: {
        //                        Image(systemName: "gear")
        //                            .foregroundColor(Colors.accent.color)
        //                    }
        //
        //                    let titlePreview = "\(currentAccount.user?.login ?? "") - Overview"
        //                    ShareLink(
        //                        item: currentAccount.user?.htmlURL ?? "",
        //                        preview: SharePreview(titlePreview, image: Image("default"))
        //                    ) {
        //                        Image(systemName: "square.and.arrow.up")
        //                            .foregroundColor(Colors.accent.color)
        //                    }
        //                }
        //            }
        //        }
        //        .toolbarBackground(UIColor.systemGroupedBackground.color, for: .navigationBar)
        //        .refreshable { fetchUser() }
        //        .enableInjection()
    }
}
