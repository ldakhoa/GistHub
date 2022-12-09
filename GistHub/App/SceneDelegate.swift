//
//  SceneDelegate.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        boostrapWidow(from: scene)
    }

    /// Bootstrap a new window with root view controller to display.
    private func boostrapWidow(from scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        // Make a window and then save it for later usuage.
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        // Make initial view controller.
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        let navigationController = UINavigationController(rootViewController: viewController)
        // Display the initial view controller.
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        // Share the window to the `AppDelegate`.
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
    }
}
