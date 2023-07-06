//
//  RootViewControllers.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import UIKit
import SwiftUI
import Gist

@MainActor
func homeRootViewController(user: User) -> UIViewController {
    let controller = UIHostingController(rootView: GistListsView(listsMode: .allGists, user: user))
    return createNavController(
        viewController: controller,
        title: "Home",
        imageName: "home",
        selectedImageName: "home-fill"
    )
}

@MainActor
func starredRootViewController(user: User) -> UIViewController {
    let controller = UIHostingController(rootView: GistListsView(listsMode: .starred, user: user))
    return createNavController(
        viewController: controller,
        title: "Starred",
        imageName: "star",
        selectedImageName: "star-fill"
    )
}

@MainActor
func profileRootViewController(
    user: User,
    sessionManager: GitHubSessionManager,
    delegate: ProfileDelegate
) -> UIViewController {
    let controller = UIHostingController(rootView: ProfilePage(user: user, delegate: delegate, sessionManager: sessionManager))
    return createNavController(
        viewController: controller,
        title: "Profile",
        imageName: "person",
        selectedImageName: "person-fill"
    )
}

private func createNavController(
    viewController: UIViewController,
    title: String,
    imageName: String,
    selectedImageName: String
) -> UIViewController {
    let navController = UINavigationController(rootViewController: viewController)
    navController.navigationBar.prefersLargeTitles = true
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = Colors.listBackground

    navController.navigationBar.tintColor = Colors.accent
    navController.navigationBar.standardAppearance = appearance
    navController.navigationBar.scrollEdgeAppearance = appearance

    navController.tabBarItem.title = title

    navController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysTemplate)
    navController.tabBarItem.image = UIImage(named: imageName)

    return navController
}
