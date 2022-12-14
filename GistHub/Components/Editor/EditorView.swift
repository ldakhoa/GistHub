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
    let fileName: String
    @State var content: String = ""
    let language: File.Language
    let gist: Gist

    @Environment(\.dismiss) private var dismiss
    @ObserveInjection private var inject
    @StateObject private var viewModel = EditorViewModel()
    @State var originalContent: String = ""
    @State var updateContentCompletion: () -> Void

    @State private var contentHasChanged = false
    @State private var showErrorToast = false
    @State private var showConfirmDialog = false
    @State private var error = ""

    var body: some View {
        EditorViewRepresentable(content: $content, language: language, isEditable: true)
            .navigationTitle("Edit")
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
                    Button("Update") {
                        Task {
                            do {
                                try await viewModel.updateGist(gistID: gist.id, fileName: fileName, content: self.content) {
                                    self.dismiss()
                                    self.updateContentCompletion()
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
            .toast(isPresenting: $showErrorToast, duration: 2.5) {
                AlertToast(
                    displayMode: .banner(.pop),
                    type: .error(Colors.danger.color),
                    title: error,
                    style: .style(backgroundColor: Colors.errorToastBackground.color)
                )
            }
            .onAppear {
                self.originalContent = self.content
            }
            .interactiveDismissDisabled(contentHasChanged)
    }
}
