//
//  EditorView.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import AlertToast
import SwiftUI
import Models
import DesignSystem

public struct EditorView: View {

    // MARK: - Dependencies

    private let style: Style
    private let fileName: String
    @State private var content: String
    private let language: File.Language
    private let gist: Gist?
    private let navigationTitle: String
    private let updateContentCompletion: (() -> Void)?
    private let createGistCompletion: ((File) -> Void)?
    private let alertPublisher = NotificationCenter.default.publisher(for: .markdownEditorViewShouldShowAlert)

    // Only need if style is create
    @State private var files: [String: File]?

    // MARK: - State

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditorViewModel()
    @State private var originalContent: String = ""

    @State private var contentHasChanged = false
    @State private var showErrorToast = false
    @State private var showConfirmDialog = false
    @State private var error = ""

    // MARK: - Initializer

    public init(
        style: Style,
        fileName: String,
        content: String = "",
        language: File.Language,
        gist: Gist? = nil,
        navigationTitle: String = "Edit",
        files: [String: File]? = nil,
        updateContentCompletion: (() -> Void)? = nil,
        createGistCompletion: ((File) -> Void)? = nil
    ) {
        self.style = style
        self.fileName = fileName
        _content = State(initialValue: content)
        self.language = language
        self.gist = gist
        self.navigationTitle = navigationTitle
        _files = State(wrappedValue: files)
        self.updateContentCompletion = updateContentCompletion
        self.createGistCompletion = createGistCompletion
    }

    public var body: some View {
        EditorViewRepresentable(content: $content, language: language, isEditable: true)
            .navigationTitle(style == .update ? "Edit" : fileName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if contentHasChanged {
                            showConfirmDialog.toggle()
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(Colors.accent.color)
                    .confirmationDialog("Are you sure you want to cancel?", isPresented: $showConfirmDialog, titleVisibility: .visible) {
                        Button("Discard Changes", role: .destructive) {
                            self.content = originalContent
                            dismiss()
                        }

                    } message: {
                        Text("Your changes will be discarded.")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(style == .update ? "Update" : "Save") {
                        switch style {
                        case .createFile:
                            createGist()
                        case .update:
                            updateGist()
                        }
                    }
                    .bold()
                    .foregroundColor(contentHasChanged ? Colors.accent.color : Colors.accentDisabled.color)
                    .disabled(!contentHasChanged)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .onChange(of: content) { newValue in
                NotificationCenter.default.post(name: .editorTextViewTextDidChange, object: newValue)
                contentHasChanged = newValue != originalContent ? true : false
            }
            .toastError(isPresenting: $showErrorToast, error: error)
            .onAppear {
                self.originalContent = self.content
            }
            .interactiveDismissDisabled(contentHasChanged)
            .onReceive(alertPublisher) { notification in
                guard let errorMessage = notification.object as? String else { return }
                error = errorMessage
                showErrorToast.toggle()
            }
    }

    private func updateGist() {
        Task {
            do {
                try await viewModel.updateGist(gistID: gist?.id ?? "", fileName: fileName, content: self.content) {
                    self.dismiss()
                    self.updateContentCompletion!()
                    if language == .markdown {
                        NotificationCenter.default.post(name: .markdownPreviewShouldReload, object: content)
                    }
                }
            } catch let updateError {
                error = updateError.localizedDescription
                showErrorToast.toggle()
            }
        }
    }

    private func createGist() {
        let file = File(filename: fileName, content: self.content)
        dismiss()
        createGistCompletion!(file)
    }
}

extension EditorView {
    public enum Style {
        case createFile
        case update
    }
}
