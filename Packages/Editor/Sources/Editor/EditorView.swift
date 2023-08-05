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

    private let style: EditorViewStyle
    @State private var fileName: String
    @State private var content: String
    private let language: File.Language
    private let gist: Gist?
    private let navigationTitle: String
    private let updateContentCompletion: (() -> Void)?
    private let alertPublisher = NotificationCenter.default.publisher(for: .markdownEditorViewShouldShowAlert)
    @ObservedObject private var filesObservableObject: FilesObservableObject

    // MARK: - State

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = EditorViewModel()
    @State private var originalContent: String = ""

    @State private var contentHasChanged = false
    @State private var showErrorToast = false
    @State private var showConfirmDialog = false
    @State private var error = ""

    private let originalFileName: String
    @State private var showRenameFileTextField: Bool = false
    @FocusState private var focusRenameFileTextField: Bool

    // MARK: - Initializer

    public init(
        style: EditorViewStyle,
        fileName: String,
        content: String = "",
        language: File.Language,
        gist: Gist? = nil,
        navigationTitle: String = "Edit",
        filesObservableObject: FilesObservableObject = .init(),
        updateContentCompletion: (() -> Void)? = nil
    ) {
        self.style = style
        _fileName = State(initialValue: fileName)
        self.originalFileName = fileName
        _content = State(initialValue: content)
        self.language = language
        self.gist = gist
        self.navigationTitle = navigationTitle
        self.filesObservableObject = filesObservableObject
        self.updateContentCompletion = updateContentCompletion
    }

    // MARK: - View

    public var body: some View {
        EditorViewRepresentable(content: $content, language: language, isEditable: true)
            .navigationTitle(style == .update ? "Edit" : fileName)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                if showRenameFileTextField {
                    ToolbarItem(placement: .principal) {
                        renameFileTextField
                    }
                } else {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: -2) {
                            Text(style == .update ? "Edit" : fileName)
                                .bold()
                            Menu {
                                Button {
                                    showRenameFileTextField = true
                                    focusRenameFileTextField = true
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                            } label: {
                                Image(systemName: "chevron.down.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                            }
                        }
                    }

                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(style == .update ? "Cancel" : "Back") {
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
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .onChange(of: content) { newValue in
                NotificationCenter.default.post(name: .editorTextViewTextDidChange, object: newValue)
                contentHasChanged = newValue != originalContent ? true : false
            }
            .onChange(of: fileName) { newValue in
                contentHasChanged = newValue != originalFileName ? true : false
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

    @ViewBuilder
    private var renameFileTextField: some View {
        TextField("", text: $fileName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(UIColor.secondarySystemBackground.color)
            .frame(height: 40)
            .showClearButton($fileName)
            .tint(Colors.textFieldTint.color)
            .focused($focusRenameFileTextField)
            .onReceive(UITextField.textDidBeginEditingNotification) { notification in
                if let textField = notification.object as? UITextField {
                    DispatchQueue.main.async {
                        textField.selectAll(nil)
                    }
                }
            }
            .onReceive(.editorTextViewDidBeginEditing) { _ in
                onRenameFile()
            }
            .submitLabel(.done)
            .onSubmit {
                onRenameFile()
            }
    }

    private func onRenameFile() {
        showRenameFileTextField = false

        let language = fileName
            .getFileExtension()?
            .getLanguage() ?? .markdown

        NotificationCenter.default.post(name: .textViewShouldUpdateState, object: language)
    }

    private func updateGist() {
        Task {
            do {
                let files: [String: File?]
                let currentFile: File = File(filename: fileName, content: content)

                // File name has changed, should delete old file
                if originalFileName != fileName {
                    files = [
                        originalFileName: nil,
                        fileName: currentFile
                    ]
                } else {
                    files = [fileName: currentFile]
                }

                try await viewModel.updateGist(gistID: gist?.id ?? "", files: files) {
                    if language == .markdown {
                        NotificationCenter.default.post(name: .markdownPreviewShouldReload, object: content)
                    }
                    self.dismiss()
                }
            } catch let updateError {
                error = updateError.localizedDescription
                showErrorToast.toggle()
            }
        }
    }

    private func createGist() {
        let file = File(filename: fileName, content: self.content)
        filesObservableObject.files[fileName] = file
        dismiss()
    }
}

public enum EditorViewStyle {
    case createFile
    case update
}

fileprivate extension Colors {
    static let textFieldBackground: UIColor = UIColor(
        light: .white,
        dark: UIColor(colorValue: ColorValue(0x24292E))
    )

    static let textFieldTint: UIColor = UIColor(
        light: UIColor(colorValue: ColorValue(0x24292E)),
        dark: UIColor(colorValue: ColorValue(0xF7F8FA))
    )
}
