//
//  PlainTextEditor.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import AlertToast
import SwiftUI
import Models
import DesignSystem
import Common

/// A view that uses for write comments and descriptions.
public struct MarkdownTextEditorView: View {

    // MARK: - Dependencies

    private let style: MarkdownTextEditorStyle
    @State private var content: String
    private let commentID: Int?
    @State private var files: [String: File]?
    private let completion: (() -> Void)?
    private let createGistCompletion: ((File) -> Void)?
    private let alertPublisher = NotificationCenter.default.publisher(for: .markdownEditorViewShouldShowAlert)

    // MARK: - State

    @StateObject private var viewModel = EditorViewModel()
    @State private var originalContent = ""
    @FocusState private var isFocused: Bool
    @State private var contentHasChanged = false
    @State private var showConfirmDialog = false
    @State private var showErrorToast = false
    @State private var error = ""
    @State private var placeholderState = ""
    @State private var showLoadingSaveButton = false

    // MARK: - Environments

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializer

    public init(
        style: MarkdownTextEditorStyle,
        content: String = "",
        commentID: Int? = nil,
        files: [String: File]? = nil,
        completion: (() -> Void)? = nil,
        createGistCompletion: ((File) -> Void)? = nil
    ) {
        self.style = style
        _content = State(initialValue: content)
        self.commentID = commentID
        _files = State(wrappedValue: files)
        self.completion = completion
        self.createGistCompletion = createGistCompletion
    }

    public var body: some View {
        NavigationStack {
            EditorViewRepresentable(content: $content, language: .markdown)
                .focused($isFocused)
                .navigationTitle(style.navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.visible, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(style == .createGist ? "Back" : "Cancel") {
                            if contentHasChanged {
                                showConfirmDialog.toggle()
                            } else {
                                dismiss()
                            }
                        }
                        .foregroundColor(Colors.accent.color)
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showLoadingSaveButton = true
                            switch style {
                            case .createGist: createFile()
                            case .writeComment: createComment()
                            case .updateComment: updateComment()
                            }
                        } label: {
                            if showLoadingSaveButton {
                                ProgressView()
                                    .tint(Colors.accent.color)
                            } else {
                                Text("Save")
                            }
                        }
                        .bold()
                        .foregroundColor(contentHasChanged ? Colors.accent.color : Colors.accentDisabled.color)
                        .disabled(!contentHasChanged)
                    }
                }
        }
        .onAppear {
            self.originalContent = content
            placeholderState = content.isEmpty ? style.placeholder : ""
            isFocused = true
        }
        .onChange(of: content) { newValue in
            contentHasChanged = newValue != originalContent ? true : false
            placeholderState = content.isEmpty ? style.placeholder : ""
        }
        .confirmationDialog("Are you sure you want to cancel?", isPresented: $showConfirmDialog, titleVisibility: .visible) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Your changes will be discarded.")
        }
        .toastError(isPresenting: $showErrorToast, error: error)
//        .toastError(isPresenting: $commentViewModel.showErrorToast, error: commentViewModel.errorToastTitle)
        .interactiveDismissDisabled(contentHasChanged)
        .onReceive(alertPublisher) { notification in
            guard let errorMessage = notification.object as? String else { return }
            error = errorMessage
            showErrorToast.toggle()
        }
    }

    private func createFile() {
//        let fileName = navigationTitle
//        self.files?[fileName] = File(filename: fileName, content: self.content
//        let file = File(filename: fileName, content: self.content)
//        dismiss()
//        createGistCompletion!(file)
    }

    private func createComment() {
//        guard let gistID = gistID else { return }
//        Task {
//            do {
//                await commentViewModel.createComment(gistID: gistID, body: content) {
//                    dismiss()
//                }
//            }
//            showLoadingSaveButton = false
//        }
    }

    private func updateComment() {
//        guard let gistID = gistID else { return }
//        Task {
//            do {
//                guard let commentID = commentID else { return }
//                await commentViewModel.updateComment(
//                    gistID: gistID,
//                    commentID: commentID,
//                    body: content
//                ) {
//                    dismiss()
//                }
//            }
//            showLoadingSaveButton = false
//        }
    }
}

extension MarkdownTextEditorView {
    public enum Style {
        case createGist
        case writeComment
        case updateComment

        var navigationTitle: String {
            switch self {
            case .createGist:
                return ""
            case .writeComment:
                return "Write Comment"
            case .updateComment:
                return "Edit Comment"
            }
        }

        var placeholder: String {
            switch self {
            case .createGist:
                return ""
            case .writeComment, .updateComment:
                return "Write a comment..."
            }
        }
    }
}
