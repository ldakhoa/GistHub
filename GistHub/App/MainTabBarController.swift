//
//  MainTabBarController.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: Internal
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Colors.accent

        let home = UIViewController()
        home.view.backgroundColor = .white

        viewControllers = [
            createNavController(
                viewController: home,
                title: "Home",
                imageName: "home",
                selectedImageName: "home-fill"
            ),
            createNavController(
                viewController: home,
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
        navigationController?.navigationBar.tintColor = Colors.accent

        navController.tabBarItem.title = title

        navController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysTemplate)
        navController.tabBarItem.image = UIImage(named: imageName)

        navController.setNavigationBarHidden(true, animated: true)

        return navController
    }
}
