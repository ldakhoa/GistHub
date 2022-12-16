//
//  PlainTextEditor.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import AlertToast
import SwiftUI
import Inject

/// A view that uses for write comments and descriptions.
struct PlainTextEditorView: View {

    // MARK: - Dependencies

    private let style: Style
    @State private var content: String
    private let gistID: String
    private let navigationTitle: String
    private let placeholder: String
    @ObservedObject var commentViewModel: CommentViewModel
    private let completion: (() -> Void)?

    // MARK: - State

    @StateObject private var viewModel = EditorViewModel()
    @State private var originalContent = ""
    @FocusState private var isFocused: Bool
    @State private var contentHasChanged = false
    @State private var showConfirmDialog = false
    @State private var showErrorToast = false
    @State private var error = ""
    @State private var placeholderState = ""

    // MARK: - Environments

    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializer

    init(
        style: Style,
        content: String = "",
        gistID: String,
        navigationTitle: String,
        placeholder: String = "",
        commentViewModel: CommentViewModel,
        completion: (() -> Void)? = nil
    ) {
        self.style = style
        _content = State(initialValue: content)
        self.gistID = gistID
        self.navigationTitle = navigationTitle
        self.placeholder = placeholder
        self.commentViewModel = commentViewModel
        self.completion = completion
    }

    var body: some View {
        NavigationStack {
            ZStack {
                TextEditor(text: $content)
                    .focused($isFocused)
                    .padding(8)
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                    .navigationTitle(navigationTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar(.visible, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
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
                        }

                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                if style == .description {
                                    updateDescription()
                                } else if style == .comment {
                                    createComment()
                                } else if style == .updateComment {

                                }
                            }
                            .bold()
                            .foregroundColor(contentHasChanged ? Colors.accent.color : Colors.accentDisabled.color)
                            .disabled(!contentHasChanged)
                        }
                }

                VStack {
                    HStack {
                        Text(placeholderState)
                            .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                            .foregroundColor(Colors.neutralEmphasis.color)
                            .padding(.top, 16)
                            .padding(.leading, 13)
                        Spacer()
                    }
                    Spacer()
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
        .toast(isPresenting: $showErrorToast, duration: 2.5) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .error(Colors.danger.color),
                title: error,
                style: .style(backgroundColor: Colors.errorToastBackground.color)
            )
        }
        .interactiveDismissDisabled(contentHasChanged)
        .enableInjection()
    }

    private func updateDescription() {
        Task {
            do {
                try await viewModel.updateDescription(content, gistID: gistID) {
                    dismiss()
                    completion!()
                }
            } catch let gistError {
                error = gistError.localizedDescription
                self.showErrorToast.toggle()
            }
        }
    }

    private func createComment() {
        Task {
            do {
                try await commentViewModel.createComment(gistID: gistID, body: content)
                dismiss()
            } catch let commentError {
                error = commentError.localizedDescription
                self.showErrorToast.toggle()
            }
        }
    }

    private func updateComment() {

    }
}

extension PlainTextEditorView {
    enum Style {
        case description
        case comment
        case updateComment
    }
}
