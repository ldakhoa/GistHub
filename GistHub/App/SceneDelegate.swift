//
//  SceneDelegate.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import UIKit
import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var appController: AppController!

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appController = appDelegate.appController
        self.appController = appController

        self.window = appController.boostrapWindow(from: scene)
        // Share the window to the `AppDelegate`.
        appDelegate.window = window
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        appController.appDidBecomeActive()
    }

    /// Bootstrap a new window with root view controller to display.
    private func boostrapWidow(from scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else { return }
        // Make a window and then save it for later usuage.
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        // Make initial view controller.
//        let viewController = MainTabBarController()
//        let viewController = UIHostingController(rootView: LoginView())
        let viewController = UIViewController()
        // Display the initial view controller.
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        // Share the window to the `AppDelegate`.
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
    }
}
