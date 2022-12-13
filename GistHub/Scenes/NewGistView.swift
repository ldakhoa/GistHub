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

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Gist description (Optional)", text: $description)
                } header: {
                    Text("Gist Description")
                }

                Section {
                    Button("Add file") {
                        presentNewFileAlert = true
                    }
                    .alert("New file", isPresented: $presentNewFileAlert) {
                        TextField("Filename including extension", text: $newFileTitle)
                            .font(.subheadline)

                        NavigationLink("Create") {
                            EditorView()
                                .navigationTitle(newFileTitle)
                        }

                        Button("Cancel", role: .cancel, action: {})
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
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        presentCreateDialog = true
                    }
                    .disabled(true)
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

        .enableInjection()
    }
}
