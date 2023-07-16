//
//  MainTabBarController.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import Foundation
import UIKit
import SwiftUI
import DesignSystem
import Models
import Gist
import Networking

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Colors.accent
        view.backgroundColor = .systemBackground
    }

    func reset(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }

    func present(url: URL) {
//        let client: GistHubAPIClient = DefaultGistHubAPIClient()
//        Task {
//            do {
//                let user = try await client.user()
//                // ["/", "<username>", "gist_id"]
//                // https://gist.github.com/ldakhoa/020ac54241d11e8616bea97f7a4292bc
//                // https://gist.github.com/chriseidhof/e1a8b3efad617fe35eb9e8814f04de9d
//                print("Present url: \(url)")
//                print(url.pathComponents.count)
//                let gist = Gist(id: url.pathComponents[2])
//
//                let gistDetailView = GistDetailView(gist: gist) {
//                    self.dismiss(animated: true)
//                }.environmentObject(UserStore(user: user))
//
//                let viewController = UIHostingController(rootView: gistDetailView)
//                let navigationController = UINavigationController(rootViewController: viewController)
//                present(navigationController, animated: true)
//            }
//        }
    }
}
