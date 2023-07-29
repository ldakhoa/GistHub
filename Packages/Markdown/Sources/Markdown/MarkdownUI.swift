//
//  MarkdownUI.swift
//  GistHub
//
//  Created by Khoa Le on 05/01/2023.
//

import SwiftUI

public struct MarkdownUI: UIViewControllerRepresentable {

    let markdown: String
    let markdownHeight: Binding<CGFloat>?
    let mode: MarkdownViewController.Mode

    public init(
        markdown: String,
        markdownHeight: Binding<CGFloat>? = nil,
        mode: MarkdownViewController.Mode = .file
    ) {
        self.markdown = markdown
        self.markdownHeight = markdownHeight
        self.mode = mode
    }

    public typealias UIViewControllerType = MarkdownViewController

    public func makeUIViewController(context: Context) -> MarkdownViewController {
        let viewController = MarkdownViewController(markdown: markdown, mode: mode)
        viewController.delegate = context.coordinator

        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: MarkdownViewController,
        context: Context
    ) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(markdownHeight: markdownHeight)
    }

    public class Coordinator: MarkdownViewControllerDelegate {
        let markdownHeight: Binding<CGFloat>?

        init(markdownHeight: Binding<CGFloat>?) {
            self.markdownHeight = markdownHeight
        }

        func collectionViewDidUpdateHeight(height: CGFloat) {
            markdownHeight?.wrappedValue = height
        }
    }
}
