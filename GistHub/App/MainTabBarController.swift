//
//  MainTabBarController.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {

    // MARK: Internal
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Colors.accent

        let homePage = UIHostingController(rootView: GistListsView(listsMode: .allGists))
        let starredPage = UIHostingController(rootView: GistListsView(listsMode: .starred))
        let profilePage = UIHostingController(rootView: ProfilePage())

        viewControllers = [
            createNavController(
                viewController: EditorViewController(),
                title: "Editor",
                imageName: "home",
                selectedImageName: "home-fill"
            ),
            createNavController(
                viewController: homePage,
                title: "Home",
                imageName: "home",
                selectedImageName: "home-fill"
            ),
            createNavController(
                viewController: starredPage,
                title: "Starred",
                imageName: "star",
                selectedImageName: "star-fill"
            ),
            createNavController(
                viewController: profilePage,
                title: "Profile",
                imageName: "person",
                selectedImageName: "person-fill"
            )
        ]
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

        navigationController?.navigationBar.tintColor = Colors.accent
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance

        navController.tabBarItem.title = title

        navController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysTemplate)
        navController.tabBarItem.image = UIImage(named: imageName)

        return navController
    }
}
