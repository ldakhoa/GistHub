//
//  AppDelegate.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let appController = AppController()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        appController.appDidFinishLaunching(with: window)
        UserDefaults.standard.registerDefaults()
        return true
    }

    /// Bootstrap a new window with root view controller to display.
    private func boostrapWidow() {
        if #available(iOS 13, *) {
            // The `SceneDelegate` take reponsibilities for bootstrapping the window.
        } else {
            let window = UIWindow()
            self.window = window
            let viewController = MainTabBarController()
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
