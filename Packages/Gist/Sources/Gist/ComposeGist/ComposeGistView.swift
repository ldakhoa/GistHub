//
//  ComposeGitView.swift
//  GistHub
//
//  Created by Hung Dao on 27/02/2023.
//

import SwiftUI
import OrderedCollections
import Models
import DesignSystem
import Editor
import Utilities
import Environment

public struct ComposeGistView: View {

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = ComposeGistViewModel()
    @ObservedObject private var filesObservableObject = FilesObservableObject()

    @State private var description: String = ""
    @State private var presentNewFileAlert = false
    @State private var presentCreateDialog = false
    @State private var pushToEditorView = false
    @State private var newFileTitle: String = ""
    @State private var enableCreateNewGist = false
    @State private var showCancelConfirmDialog = false
    @State private var error = ""
    @State private var showErrorToast = false
    @State private var descriptionChanged = false
    @State private var filesChanged = false
    private var completion: ((Gist) -> Void)?

    private let style: ComposeGistView.Style
    private var originalFiles = [String: File]()

    public init(
        style: ComposeGistView.Style,
        completion: ((Gist) -> Void)? = nil
    ) {
        self.style = style
        self.completion = completion
        if case let .update(gist) = style {
            for file in gist.files ?? [:] {
                originalFiles[file.key] = File(filename: file.key, content: file.value.content)
            }
            _description = State(initialValue: gist.description ?? "")
            filesObservableObject.files = originalFiles
        }
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Gist description (Optional)", text: $description)
                        .autocorrectionDisabled()
                } header: {
                    Text("Gist Description")
                }
                Section {
                    ForEach(filesObservableObject.files.keys.sorted(), id: \.self) { fileName in
                        let file = filesObservableObject.files[fileName]
                        NavigationLink(fileName) {
                            buildEditorView(file: file, fileName: fileName)
                        }
                    }
                    Button("Add file") {
                        hideKeyboard()
                        presentNewFileAlert = true
                    }
                    .alert("New file", isPresented: $presentNewFileAlert) {
                        TextField("Filename including extension", text: $newFileTitle)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.some(.never))
                            .font(.subheadline)

                        NavigationLink("Create") {
                            buildEditorView(fileName: newFileTitle)
//                            newFileTitle = ""
                        }

                        Button("Cancel", role: .cancel) {
                            newFileTitle = ""
                        }
                    }
                } header: {
                    Text("Files")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(style.navigationTitle)
            .toolbar(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        switch style {
                        case .createGist:
                            if enableCreateNewGist {
                                showCancelConfirmDialog = true
                            } else {
                                dismiss()
                            }
                        case .update:
                            if descriptionChanged || filesChanged {
                                showCancelConfirmDialog = true
                            } else {
                                dismiss()
                            }
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    switch style {
                    case .createGist:
                        buildCreateButton()
                    case .update(let gist):
                        buildUpdateButton(gistID: gist.id)
                    }
                }
            }
            .tint(Colors.accent.color)
        }
        .onChange(of: filesObservableObject.files) { newFiles in
            switch style {
            case .createGist:
                enableCreateNewGist = !newFiles.isEmpty
            case .update:
                filesChanged = originalFiles != newFiles
            }
            newFileTitle = ""
        }
        .onChange(of: description) { newDescription in
            if case .update(let gist) = style {
                descriptionChanged = gist.description != newDescription
            }
        }
        .confirmationDialog(
            "Are you sure you want to cancel?",
            isPresented: $showCancelConfirmDialog,
            titleVisibility: .visible
        ) {
            Button("Discard", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Your changes will be discarded.")
        }
        .toastError(isPresenting: $showErrorToast, error: error)
    }

    private func buildUpdateButton(gistID: String) -> some View {
        Button("Update") {
            Task {
                do {
                    let gist = try await viewModel.updateGist(
                        gistID: gistID,
                        description: description,
                        files: filesObservableObject.files
                    )
                    completion!(gist)
                    dismiss()
                } catch let updateError {
                    error = updateError.localizedDescription
                    self.showErrorToast.toggle()
                }
            }
        }
        .disabled(!(filesChanged || descriptionChanged))
    }

    private func buildCreateButton() -> some View {
        Button("Create") {
            presentCreateDialog = true
        }
        .disabled(!enableCreateNewGist)
        .confirmationDialog("Create a gist", isPresented: $presentCreateDialog, titleVisibility: .visible) {
            Button("Create secret gist") {
                Task {
                    do {
                        let gist = try await viewModel.createGist(
                            description: description,
                            files: filesObservableObject.files,
                            public: false)
                        dismiss()
                        completion!(gist)
                    } catch let createError {
                        error = createError.localizedDescription
                        self.showErrorToast.toggle()
                    }
                }
            }
            Button("Create public gist") {
                Task {
                    do {
                        let gist = try await viewModel.createGist(
                            description: description,
                            files: filesObservableObject.files,
                            public: true)
                        dismiss()
                        completion!(gist)
                    } catch let createError {
                        error = createError.localizedDescription
                        self.showErrorToast.toggle()
                    }
                }
            }
        } message: {
            Text("Create secret gists are hidden by search engine but visible to anyone you give the URL to.\nCreate public gists are visible to everyone.")
        }
    }

    @ViewBuilder
    private func buildEditorView(
        file: File? = nil,
        fileName: String
    ) -> some View {
        let language = fileName
            .getFileExtension()?
            .getLanguage() ?? .markdown

        EditorView(
            style: .createFile,
            fileName: fileName,
            content: file?.content ?? "",
            language: language,
            filesObservableObject: filesObservableObject
        )
    }
}

extension ComposeGistView {
    public enum Style {
        case createGist
        case update(gist: Gist)

        var navigationTitle: String {
            switch self {
            case .createGist: return "Create a new gist"
            case .update: return "Edit gist"
            }
        }
    }
}
