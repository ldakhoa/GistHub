//
//  EditorViewRepresentable.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import SwiftUI
import Models

public struct EditorViewRepresentable: UIViewControllerRepresentable {
    public typealias UIViewControllerType = EditorViewController

    private let content: Binding<String>
    private let language: File.Language
    private let style: EditorViewController.Style
    @State private var isEditable = true
    @State private var isSelectable = true

    public init(
        style: EditorViewController.Style = .normal,
        content: Binding<String>,
        language: File.Language,
        isEditable: Bool = true,
        isSelectable: Bool = true
    ) {
        self.style = style
        self.content = content
        self.language = language
        self.isEditable = isEditable
        self.isSelectable = isSelectable
    }

    public func makeUIViewController(context: Context) -> EditorViewController {
        let viewController = EditorViewController(
            style: style,
            content: content,
            isEditable: isEditable,
            isSelectable: isSelectable,
            language: language)
        viewController.delegate = context.coordinator
        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: EditorViewController,
        context: Context
    ) {

    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(content: content)
    }
}

extension EditorViewRepresentable {
    public class Coordinator: EditorViewControllerDelegate {
        var parentObserver: NSKeyValueObservation?
        let content: Binding<String>

        public init(parentObserver: NSKeyValueObservation? = nil, content: Binding<String>) {
            self.parentObserver = parentObserver
            self.content = content
        }

        public func textViewDidChange(text: String) {
            content.wrappedValue = text
        }
     }
}
