//
//  EditorView.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import AlertToast
import SwiftUI
import Inject

struct EditorView: View {

    // MARK: - Dependencies

    private let style: Style
    private let fileName: String
    @State private var content: String
    private let language: File.Language
    private let gist: Gist?
    private let navigationTitle: String
    private let updateContentCompletion: (() -> Void)?

    // Only need if style is create
    @State private var files: [String: File]?

    // MARK: - State

    @Environment(\.dismiss) private var dismiss
    @ObserveInjection private var inject
    @StateObject private var viewModel = EditorViewModel()
    @State var originalContent: String = ""

    @State private var contentHasChanged = false
    @State private var showErrorToast = false
    @State private var showConfirmDialog = false
    @State private var error = ""

    // MARK: - Initializer

    init(
        style: Style,
        fileName: String,
        content: String = "",
        language: File.Language,
        gist: Gist? = nil,
        navigationTitle: String = "Edit",
        files: [String: File]? = nil,
        updateContentCompletion: (() -> Void)? = nil
    ) {
        self.style = style
        self.fileName = fileName
        _content = State(initialValue: content)
        self.language = language
        self.gist = gist
        self.navigationTitle = navigationTitle
        _files = State(wrappedValue: files)
        self.updateContentCompletion = updateContentCompletion
    }

    var body: some View {
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
                    .bold()
                    .foregroundColor(contentHasChanged ? Colors.accent.color : Colors.accentDisabled.color)
                    .disabled(!contentHasChanged)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .enableInjection()
            .onChange(of: content) { newValue in
                NotificationCenter.default.post(name: .editorTextViewTextDidChange, object: newValue)
                contentHasChanged = newValue != originalContent ? true : false
            }
            .toastError(isPresenting: $showErrorToast, error: error)
            .onAppear {
                self.originalContent = self.content
            }
            .interactiveDismissDisabled(contentHasChanged)
    }
}

extension EditorView {
    enum Style {
        case create
        case update
    }
}
