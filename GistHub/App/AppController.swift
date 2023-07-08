//
//  AppController.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import UIKit
import SwiftUI
import Environment
import AppAccount
import Login
import Networking
import Profile

final class AppController: NSObject, LoginDelegate, GitHubSessionListener, ProfileDelegate {

    // MARK: - Misc

    private let mainTabBarController = MainTabBarController()
    private let sessionManager = GitHubSessionManager()
    private var loginViewController: UIHostingController<LoginView>?

    // MARK: - Initializer

    override init() {
        super.init()
        sessionManager.listener = self
    }

    // MARK: - App LifeCycle

    func appDidFinishLaunching() {

        if sessionManager.focusedUserSession != nil {
            resetViewController()
        }
    }

    func boostrapWindow(from scene: UIScene) -> UIWindow {
        guard let windowScene = scene as? UIWindowScene else { return UIWindow() }
        // Make a window and then save it for later usuage.
        let window = UIWindow(windowScene: windowScene)
        // Make initial view controller.
        window.rootViewController = mainTabBarController
        window.makeKeyAndVisible()
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
        return window
    }

    func appDidBecomeActive() {
        // dont need to login if there's a user session
        guard sessionManager.focusedUserSession == nil && loginViewController == nil else { return }
        showLogin(animated: false)
    }

    // MARK: - Side Effects

    private func showLogin(animated: Bool) {
        let loginView = LoginView(delegate: self)
        let controller = UIHostingController(rootView: loginView)
        controller.modalPresentationStyle = .fullScreen
        loginViewController = controller

        let present: () -> Void = {
            self.mainTabBarController.present(controller, animated: animated)
        }

        if let presented = mainTabBarController.presentedViewController {
            presented.dismiss(animated: animated, completion: present)
        } else {
            present()
        }
    }

    private func resetViewController() {
        let client: GistHubAPIClient = DefaultGistHubAPIClient()
        Task {
            do {
                let user = try await client.user()
                await mainTabBarController.reset(viewControllers: [
                    homeRootViewController(user: user),
                    starredRootViewController(user: user),
                    profileRootViewController(user: user, sessionManager: sessionManager, delegate: self)
                ])
            }
        }
    }

    // MARK: - LoginDelegate

    func finishLogin(
        token: String,
        authMethod: GitHubUserSession.AuthMethod,
        username: String
    ) {
        sessionManager.focus(
            GitHubUserSession(
                token: token,
                authMethod: authMethod,
                username: username
            )
        )
    }

    // MARK: - GitHubSessionListener

    func didFocus() {
        mainTabBarController.presentedViewController?.dismiss(animated: true)
        resetViewController()
    }

    // MARK: - ProfileDelegate

    func shouldLogout() {
        sessionManager.logout()
        showLogin(animated: true)
    }
}
