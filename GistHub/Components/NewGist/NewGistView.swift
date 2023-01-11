//
//  NewGistView.swift
//  GistHub
//
//  Created by Khoa Le on 11/12/2022.
//

import SwiftUI
import Inject

struct NewGistView: View {
    @ObserveInjection private var inject

    @Environment(\.dismiss) private var dismiss

    @State private var description: String = ""
    @State private var presentNewFileAlert = false
    @State private var presentCreateDialog = false
    @State private var pushToEditorView = false
    @State private var newFileTitle: String = ""
    @State private var enableCreateNewGist = false
    @State private var showCancelConfirmDialog = false
    @State private var files = [String: File]()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Gist description (Optional)", text: $description)
                } header: {
                    Text("Gist Description")
                }

                Section {
                    ForEach(files.keys.sorted(), id: \.self) { fileName in
                        let file = files[fileName]
                        NavigationLink(fileName) {
                            MarkdownTextEditorView(
                                style: .createGist,
                                content: file?.content ?? "",
                                navigationTitle: file?.filename ?? "",
                                createGistCompletion: { newFile in
                                    self.files[newFile.filename ?? ""] = newFile
                                })
                        }
                    }
                    Button("Add file") {
                        presentNewFileAlert = true
                    }
                    .alert("New file", isPresented: $presentNewFileAlert) {
                        TextField("Filename including extension", text: $newFileTitle)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.some(.never))
                            .font(.subheadline)

                        NavigationLink("Create") {
                            if let index = newFileTitle.firstIndex(of: ".") {
                                let language = String(newFileTitle.suffix(from: index))
                                    .replacingOccurrences(of: ".", with: "")

                                if language == "md" || language == "markdown" {
                                    MarkdownTextEditorView(
                                        style: .createGist,
                                        navigationTitle: newFileTitle,
                                        createGistCompletion: { file in
                                            self.files[file.filename ?? ""] = file
                                            newFileTitle = ""
                                        })
                                } else {
                                    MarkdownTextEditorView(style: .createGist, navigationTitle: newFileTitle)
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
            .navigationTitle("Create a new gist")
            .toolbar(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if enableCreateNewGist {
                            self.enableCreateNewGist.toggle()
                        } else {
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        presentCreateDialog = true
                    }
                    .disabled(!enableCreateNewGist)
                    .confirmationDialog("Create a gist", isPresented: $presentCreateDialog, titleVisibility: .visible) {
                        Button("Create secret gist") {}
                        Button("Create public gist") {}
                    } message: {
                        Text("Create secret gists are hidden by search engine but visible to anyone you give the URL to.\nCreate public gists are visible to everyone.")
                    }
                }
            }
            .tint(Colors.accent.color)
        }
        .onChange(of: files) { newFiles in
            self.enableCreateNewGist = !newFiles.isEmpty
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
        .enableInjection()
    }
}
