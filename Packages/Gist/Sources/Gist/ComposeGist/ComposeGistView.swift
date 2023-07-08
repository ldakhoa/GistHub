//
//  ComposeGitView.swift
//  GistHub
//
//  Created by Hung Dao on 27/02/2023.
//

import Foundation
import SwiftUI
import Inject
import AlertToast
import OrderedCollections
import Models
import DesignSystem
import Editor
import Utilities

struct ComposeGistView: View {
    @ObserveInjection private var inject

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = ComposeGistViewModel()
    @State private var description: String = ""
    @State private var presentNewFileAlert = false
    @State private var presentCreateDialog = false
    @State private var pushToEditorView = false
    @State private var newFileTitle: String = ""
    @State private var enableCreateNewGist = false
    @State private var showCancelConfirmDialog = false
    @State private var files = [String: File]()
    @State private var error = ""
    @State private var showErrorToast = false
    @State private var descriptionChanged = false
    @State private var filesChanged = false
    var completion: ((Gist) -> Void)?
    private let style: ComposeGistView.Style
    private var originalFiles = [String: File]()

    init(
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
            _files = State(initialValue: originalFiles)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Gist description (Optional)", text: $description)
                        .autocorrectionDisabled()
                } header: {
                    Text("Gist Description")
                }
                Section {
                    ForEach(files.keys.sorted(), id: \.self) { fileName in
                        let file = files[fileName]
                        NavigationLink(fileName) {
                            FileEditorView(file: file, fileName: fileName) { [weak self] newFile in
                                self?.files[newFile.filename ?? ""] = newFile
                            }
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
                            if let language = newFileTitle.getFileExtension() {
                                if language == "md" || language == "markdown" {
                                    MarkdownTextEditorView(
                                        style: .createGist,
                                        navigationTitle: newFileTitle,
                                        createGistCompletion: { file in
                                            self.files[file.filename ?? ""] = file
                                            newFileTitle = ""
                                        })
                                } else if language.isEmpty {
                                    // TODO: Handle case language is empty
                                } else {
                                    EditorView(
                                        style: .createFile,
                                        fileName: newFileTitle,
                                        language: File.Language(rawValue: language) ?? .javaScript,
                                        createGistCompletion: { file in
                                            self.files[file.filename ?? ""] = file
                                            newFileTitle = ""
                                        })
                                }
                            }
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
        .onChange(of: files) { newFiles in
            switch style {
            case .createGist:
                enableCreateNewGist = !newFiles.isEmpty
            case .update:
                filesChanged = originalFiles != newFiles
            }
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
        .enableInjection()
    }

    private func buildUpdateButton(gistID: String) -> some View {
        Button("Update") {
            Task {
                do {
//                    let gist = try await viewModel.updateGist(gistID: gistID, description: description, files: files)
//                    completion!(gist)
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
                        let gist = try await viewModel.createGist(description: description, files: files, public: false)
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
                        let gist = try await viewModel.createGist(description: description, files: files, public: true)
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
}

struct FileEditorView: View {
    let file: File?
    let fileName: String
    let completion: ((File) -> Void)? = nil

    var body: some View {
        if let language = fileName.getFileExtension() {
            if language == "md" || language == "markdown" {
                MarkdownTextEditorView(
                    style: .createGist,
                    content: file?.content ?? "",
                    navigationTitle: file?.filename ?? "",
                    createGistCompletion: { newFile in
                        self.completion!(newFile)
//                        self.files[newFile.filename ?? ""] = newFile
                    })
            } else {
                EditorView(
                    style: .createFile,
                    fileName: fileName,
                    content: file?.content ?? "",
                    language: File.Language(rawValue: language) ?? .javaScript,
                    createGistCompletion: { file in
                        self.completion!(file)
//                        self.files[file.filename ?? ""] = file
                    })
            }
        }
    }
}

extension ComposeGistView {
    enum Style {
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
