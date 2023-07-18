import UIKit
import SwiftUI

public extension View {
    weak var topViewController: UIViewController? {
        UIApplication.shared.topViewController
    }
}

public extension UIWindow {
    // Credits: - https://gist.github.com/matteodanelli/b8dcdfef39e3417ec7116a2830ff67cf
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(viewController: rootViewController)
        }
        return nil
    }

    class func getVisibleViewControllerFrom(viewController: UIViewController) -> UIViewController {
        switch viewController {
        case is UINavigationController:
            let navigationController = viewController as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom(viewController: navigationController.visibleViewController!)

        case is UITabBarController:
            let tabBarController = viewController as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(viewController: tabBarController.selectedViewController!)

        default:
            if let presentedViewController = viewController.presentedViewController {
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(viewController: presentedViewController2)
                } else {
                    return viewController
                }
            } else {
                return viewController
            }
        }

    }
}

@objc public extension UIApplication {
    var topWindow: UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.windows.first(where: { $0.isKeyWindow })
        }
        return nil
    }

    var topViewController: UIViewController? {
        return topWindow?.visibleViewController()
    }
}
