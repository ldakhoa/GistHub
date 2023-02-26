//
//  EditGistView.swift
//  GistHub
//
//  Created by Hung Dao on 26/02/2023.
//

import Foundation
import SwiftUI
import Inject
import AlertToast
import OrderedCollections

struct EditGistView: View {
    @ObserveInjection private var inject

    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = EditGistViewModel()
    @State private var description: String = ""
    @State private var originalDescription: String = ""
    @State private var presentNewFileAlert = false
    @State private var presentCreateDialog = false
    @State private var pushToEditorView = false
    @State private var newFileTitle: String = ""
    @State private var enableUpdateGist = false
    @State private var showCancelConfirmDialog = false
    @State private var files = OrderedDictionary<String, File>()
    @State private var error = ""
    @State private var showErrorToast = false

    var completion: (() -> Void)?
    private let gistID: String

    init(
        gist: Gist,
        completion: (() -> Void)? = nil
    ) {
        _description = State(initialValue: gist.description ?? "")
        _files = State(initialValue: gist.files ?? [:])
        gistID = gist.id
        self.completion = completion
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
                            if let language = fileName.getFileExtension() {
                                if language == "md" || language == "markdown" {
                                    MarkdownTextEditorView(
                                        style: .createGist,
                                        content: file?.content ?? "",
                                        navigationTitle: file?.filename ?? "",
                                        createGistCompletion: { newFile in
                                            self.files[newFile.filename ?? ""] = newFile
                                        })
                                } else {
                                    EditorView(
                                        style: .createFile,
                                        fileName: fileName,
                                        content: file?.content ?? "",
                                        language: File.Language(rawValue: language) ?? .javaScript,
                                        createGistCompletion: { file in
                                            self.files[file.filename ?? ""] = file
                                        })
                                }
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
            .navigationTitle("Edit gist")
            .toolbar(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if enableUpdateGist {
                            self.enableUpdateGist.toggle()
                        } else {
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update") {
                        Task {
                            do {
                                try await viewModel.updateGist(gistID: gistID, description: description, files: files)
                                completion!()
                                dismiss()
                            } catch let updateError {
                                error = updateError.localizedDescription
                                self.showErrorToast.toggle()
                            }
                        }
                    }
                }
            }
            .tint(Colors.accent.color)
        }
        .onChange(of: files) { newFiles in
            self.enableUpdateGist = !newFiles.isEmpty
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
}
