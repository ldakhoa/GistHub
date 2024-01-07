import UIKit
import SafariServices
import SwiftUI

final class GistHubWebView: NSObject, ObservableObject, SFSafariViewControllerDelegate {
    var windowScene: UIWindowScene?
    let viewController: UIViewController = .init()
    var window: UIWindow?

    @MainActor
    func open(_ url: URL) -> OpenURLAction.Result {
        guard
            let windowScene,
            let scheme = url.scheme,
            ["https", "http"].contains(scheme.lowercased())
        else {
            return .systemAction
        }

        window = setupWindow(windowScene: windowScene)

        let safari = SFSafariViewController(url: url)
        safari.delegate = self

        DispatchQueue.main.async { [weak self] in
            self?.viewController.present(safari, animated: true)
        }

        return .handled
    }

    func setupWindow(windowScene: UIWindowScene) -> UIWindow {
        let window = self.window ?? UIWindow(windowScene: windowScene)

        window.rootViewController = viewController
        window.makeKeyAndVisible()

        self.window = window
        return window
    }

    func safariViewControllerDidFinish(_: SFSafariViewController) {
        window?.resignKey()
        window?.isHidden = false
        window = nil
    }
}

struct WindowReader: UIViewRepresentable {
    var onUpdate: (UIWindow) -> Void

    func makeUIView(context _: Context) -> InjectView {
        InjectView(onUpdate: onUpdate)
    }

    func updateUIView(_: InjectView, context _: Context) {}

    final class InjectView: UIView {
        var onUpdate: (UIWindow) -> Void

        init(onUpdate: @escaping (UIWindow) -> Void) {
            self.onUpdate = onUpdate
            super.init(frame: .zero)
            isHidden = true
            isUserInteractionEnabled = false
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)

            if let window = newWindow {
                onUpdate(window)
            } else {
                DispatchQueue.main.async { [weak self] in
                    if let window = self?.window {
                        self?.onUpdate(window)
                    }
                }
            }
        }
    }
}
