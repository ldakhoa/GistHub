//
//  EditorView.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import SwiftUI

struct EditorView: UIViewControllerRepresentable {
    typealias UIViewControllerType = EditorViewController

    func makeUIViewController(context: Context) -> EditorViewController {
        let viewController = EditorViewController()
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: EditorViewController,
        context: Context
    ) {

    }
}
