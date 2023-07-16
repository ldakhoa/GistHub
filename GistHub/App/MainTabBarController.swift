//
//  MainTabBarController.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import UIKit
import DesignSystem

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Colors.accent
        view.backgroundColor = .systemBackground
    }

    func reset(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
}
