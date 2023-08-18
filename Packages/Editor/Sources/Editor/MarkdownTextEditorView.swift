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

/// A view that uses for write comments and descriptions.
public struct MarkdownTextEditorView: View {

    // MARK: - Dependencies

    private let style: MarkdownTextEditorStyle
    @State private var content: String
    @State private var files: [String: File]?
    private let completion: ((String) -> Void)?
    private let alertPublisher = NotificationCenter.default.publisher(for: .markdownEditorViewShouldShowAlert)

    // MARK: - State

    @StateObject private var viewModel = EditorViewModel()
    @State private var originalContent = ""
    @FocusState private var isFocused: Bool
    @State private var contentHasChanged = false
    @State private var showConfirmDialog = false
    @State private var showErrorToast = false
    @State private var error = ""
    @State private var placeholder = ""
    @State private var showLoadingSaveButton = false

    // MARK: - Environments

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializer

    public init(
        style: MarkdownTextEditorStyle,
        content: String = "",
        files: [String: File]? = nil,
        completion: ((String) -> Void)? = nil
    ) {
        self.style = style

        switch style {
        case .createGist:
            _content = State(initialValue: "")
        case let .writeComment(content):
            _content = State(initialValue: content)
        case let .updateComment(content):
            _content = State(initialValue: content)
        }

        _files = State(wrappedValue: files)
        self.completion = completion
    }

    public var body: some View {
        NavigationStack {
            ZStack {
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
                                completion?(content)
                                dismiss()
                            } label: {
                                if showLoadingSaveButton {
                                    ProgressView()
                                        .tint(Colors.accent.color)
                                } else {
                                    Text(style.trailingBarTitle)
                                }
                            }
                            .bold()
                            .foregroundColor(contentHasChanged ? Colors.accent.color : Colors.accentDisabled.color)
                            .disabled(!contentHasChanged)
                        }
                    }

                placeholderView
            }
        }
        .onAppear {
            self.originalContent = content
            placeholder = content.isEmpty ? style.placeholder : ""
            isFocused = true
        }
        .onChange(of: content) { newValue in
            contentHasChanged = newValue != originalContent ? true : false
            placeholder = content.isEmpty ? style.placeholder : ""
        }
        .confirmationDialog(
            "Are you sure you want to cancel?",
            isPresented: $showConfirmDialog,
            titleVisibility: .visible
        ) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Your changes will be discarded.")
        }
        .toastError(isPresenting: $showErrorToast, error: error)
        .interactiveDismissDisabled(contentHasChanged)
        .onReceive(alertPublisher) { notification in
            guard let errorMessage = notification.object as? String else { return }
            error = errorMessage
            showErrorToast.toggle()
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        // TODO: Use UserPreferences when done
        let showLineNumbers = UserDefaults.standard.bool(forKey: "GistHub.showLineNumbers")
        VStack {
            HStack {
                Text(placeholder)
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                    .foregroundColor(Colors.neutralEmphasis.color)
                    .padding(.top, 9)
                    .padding(.leading, showLineNumbers ? 22 : 6)
                Spacer()
            }
            Spacer()
        }
    }
}
