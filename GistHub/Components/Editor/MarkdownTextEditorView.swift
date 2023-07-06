//
//  PlainTextEditor.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import AlertToast
import SwiftUI
import Inject
import Models
import DesignSystem

/// A view that uses for write comments and descriptions.
struct MarkdownTextEditorView: View {

    // MARK: - Dependencies

    private let style: Style
    @State private var content: String
    private let gistID: String?
    private let commentID: Int?
    private let navigationTitle: String
    private let placeholder: String
    @ObservedObject private var commentViewModel: CommentViewModel
    @State private var files: [String: File]?
    private let completion: (() -> Void)?
    private let createGistCompletion: ((File) -> Void)?

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

    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializer

    init(
        style: Style,
        content: String = "",
        gistID: String? = nil,
        commentID: Int? = nil,
        navigationTitle: String,
        placeholder: String = "",
        commentViewModel: CommentViewModel? = nil,
        files: [String: File]? = nil,
        completion: (() -> Void)? = nil,
        createGistCompletion: ((File) -> Void)? = nil
    ) {
        self.style = style
        _content = State(initialValue: content)
        self.gistID = gistID
        self.commentID = commentID
        self.navigationTitle = navigationTitle
        self.placeholder = placeholder
        self.commentViewModel = commentViewModel ?? CommentViewModel()
        _files = State(wrappedValue: files)
        self.completion = completion
        self.createGistCompletion = createGistCompletion
    }

    var body: some View {
        NavigationStack {
            EditorViewRepresentable(content: $content, language: .markdown)
                .focused($isFocused)
                .navigationTitle(navigationTitle)
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
                            case .changeDescription: updateDescription()
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
            placeholderState = content.isEmpty ? placeholder : ""
            isFocused = true
        }
        .onChange(of: content) { newValue in
            contentHasChanged = newValue != originalContent ? true : false
            placeholderState = content.isEmpty ? placeholder : ""
        }
        .confirmationDialog("Are you sure you want to cancel?", isPresented: $showConfirmDialog, titleVisibility: .visible) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Your changes will be discarded.")
        }
        .toastError(isPresenting: $showErrorToast, error: error)
        .toastError(isPresenting: $commentViewModel.showErrorToast, error: commentViewModel.errorToastTitle)
        .interactiveDismissDisabled(contentHasChanged)
        .enableInjection()
    }

    private func createFile() {
        let fileName = navigationTitle
//        self.files?[fileName] = File(filename: fileName, content: self.content
        let file = File(filename: fileName, content: self.content)
        dismiss()
        createGistCompletion!(file)
    }

    private func updateDescription() {
        guard let gistID = gistID else { return }
        Task {
            do {
                try await viewModel.updateDescription(content, gistID: gistID) {
                    dismiss()
                    completion!()
                }
            } catch let gistError {
                error = gistError.localizedDescription
                self.showErrorToast.toggle()
                showLoadingSaveButton = false
            }
        }
    }

    private func createComment() {
        guard let gistID = gistID else { return }
        Task {
            do {
                await commentViewModel.createComment(gistID: gistID, body: content) {
                    dismiss()
                }
            }
            showLoadingSaveButton = false
        }
    }

    private func updateComment() {
        guard let gistID = gistID else { return }
        Task {
            do {
                guard let commentID = commentID else { return }
                await commentViewModel.updateComment(
                    gistID: gistID,
                    commentID: commentID,
                    body: content
                ) {
                    dismiss()
                }
            }
            showLoadingSaveButton = false
        }
    }
}

extension MarkdownTextEditorView {
    enum Style {
        case createGist
        case changeDescription
        case writeComment
        case updateComment
    }
}
