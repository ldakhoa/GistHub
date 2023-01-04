//
//  RootViewControllers.swift
//  GistHub
//
//  Created by Khoa Le on 18/12/2022.
//

import UIKit
import SwiftUI

@MainActor
func testRootViewController() -> UIViewController {
    let markdown = """
     **Bold**, _Italic_, ~~Strike~~, ___bold italic___

     # h1
     ## h2
     ### h3
     #### h4
     ##### h5
     ###### h6
     ####### h7 will not support

    **This is multiline text** this should be wrapped by **default**

     * List
     * List

    - List
    - List

     1. Order list
     2. Order list

     - [ ] todo box
     - [x] another check

     | table | c2  |
     | ---   | --- |
     | r1    | r2  |

     Image

     <img width="928" alt="image" src="https://user-images.githubusercontent.com/39718754/208992692-d8d642f2-545a-4f71-a831-246c8fdfef02.png">

    ## Image 2

    ![Image](https://user-images.githubusercontent.com/39718754/208992692-d8d642f2-545a-4f71-a831-246c8fdfef02.png)

    ## GIF Image

    ![Image](https://raw.githubusercontent.com/onevcat/Kingfisher-TestImages/master/DemoAppImage/GIF/GifHeavy.gif)

     `code inline`

     ```javascript
     console.log("code block in js")
     ```

     [Link](https://github.com/ldakhoa/GistHub)

    > quote
    > > quote 1
    > > quote 2

    <h1>Heading 1</h1>
    <h2>Heading 2</h2>
    <h3>Heading 3</h3>

    """
    let controller = MarkdownViewController(markdown: markdown)
    return createNavController(
        viewController: controller,
        title: "Markdown",
        imageName: "home",
        selectedImageName: "home-fill"
    )
}

@MainActor
func homeRootViewController(user: User) -> UIViewController {
    let controller = UIHostingController(rootView: GistListsView(listsMode: .allGists, user: user))
    return createNavController(
        viewController: controller,
        title: "Home",
        imageName: "home",
        selectedImageName: "home-fill"
    )
}

@MainActor
func starredRootViewController(user: User) -> UIViewController {
    let controller = UIHostingController(rootView: GistListsView(listsMode: .starred, user: user))
    return createNavController(
        viewController: controller,
        title: "Starred",
        imageName: "star",
        selectedImageName: "star-fill"
    )
}

@MainActor
func profileRootViewController(
    user: User,
    sessionManager: GitHubSessionManager,
    delegate: ProfileDelegate
) -> UIViewController {
    let controller = UIHostingController(rootView: ProfilePage(user: user, delegate: delegate, sessionManager: sessionManager))
    return createNavController(
        viewController: controller,
        title: "Profile",
        imageName: "person",
        selectedImageName: "person-fill"
    )
}

private func createNavController(
    viewController: UIViewController,
    title: String,
    imageName: String,
    selectedImageName: String
) -> UIViewController {
    let navController = UINavigationController(rootViewController: viewController)
    navController.navigationBar.prefersLargeTitles = true
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = Colors.listBackground

    navController.navigationBar.tintColor = Colors.accent
    navController.navigationBar.standardAppearance = appearance
    navController.navigationBar.scrollEdgeAppearance = appearance

    navController.tabBarItem.title = title

    navController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysTemplate)
    navController.tabBarItem.image = UIImage(named: imageName)

    return navController
}
