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

    private let client: GistHubAPIClient
    @EnvironmentObject var userStore: UserStore

    init(client: GistHubAPIClient = DefaultGistHubAPIClient()) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Colors.accent
        view.backgroundColor = .systemBackground

        Task {
            guard let user = await user() else { return }

            let homePage = UIHostingController(rootView: GistListsView(listsMode: .allGists, user: user))
            let starredPage = UIHostingController(rootView: GistListsView(listsMode: .starred, user: user))
            let profilePage = UIHostingController(rootView: ProfilePage(user: user))

            viewControllers = [
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
    }

    private func user() async -> User? {
        do {
            let user = try await client.user()
            return user
        } catch {
            print(error.localizedDescription)
            return nil
        }
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
