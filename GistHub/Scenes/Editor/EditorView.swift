//
//  EditorView.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import SwiftUI

struct EditorView: UIViewControllerRepresentable {
    typealias UIViewControllerType = EditorViewController

    @State var content = ""
    @State var isEditable = true

    func makeUIViewController(context: Context) -> EditorViewController {
        let viewController = EditorViewController(content: content, isEditable: isEditable)
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: EditorViewController,
        context: Context
    ) {

    }
}
