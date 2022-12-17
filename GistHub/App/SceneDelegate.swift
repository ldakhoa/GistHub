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
}
