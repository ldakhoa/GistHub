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

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let appController = appDelegate.appController
//        self.appController = appController
//
//        self.window = appController.boostrapWindow(from: scene)
//        // Share the window to the `AppDelegate`.
//        appDelegate.window = window
//
//        if let url = connectionOptions.urlContexts.first?.url {
//            appController.open(url: url)
//        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
//        appController.appDidBecomeActive()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        if let url = URLContexts.first?.url {
//            appController.open(url: url)
//        }
    }
 }
