//
//  EditorViewRepresentable.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import SwiftUI
import Inject

struct EditorViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = EditorViewController

    let content: Binding<String>
    @State var isEditable = true

    func makeUIViewController(context: Context) -> EditorViewController {
        let viewController = EditorViewController(content: content, isEditable: isEditable)
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: EditorViewController,
        context: Context
    ) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(content: content)
    }
}

extension EditorViewRepresentable {
    class Coordinator: EditorViewControllerDelegate {
        var parentObserver: NSKeyValueObservation?
        let content: Binding<String>

        init(parentObserver: NSKeyValueObservation? = nil, content: Binding<String>) {
            self.parentObserver = parentObserver
            self.content = content
        }

        func textViewDidChange(text: String) {
            content.wrappedValue = text
        }
     }
}
