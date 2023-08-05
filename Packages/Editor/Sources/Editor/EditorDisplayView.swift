//
//  EditorDisplayView.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import SwiftUI
import Models
import DesignSystem
import Environment
import Markdown

public struct EditorDisplayView: View {
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var routerPath: RouterPath

    @State private var content: String = ""
    @State private var fileName: String = ""
    private let gist: Gist
    private let language: File.Language
    private let completion: (() -> Void)?

    @State private var showConfirmDialog = false
    @State private var showSuccessToast = false
    @State private var showErrorToast = false
    @State private var error = ""

    @StateObject private var viewModel = EditorViewModel()
    @Environment(\.dismiss) private var dismiss

    public init(
        content: String,
        fileName: String,
        gist: Gist,
        language: File.Language,
        completion: (() -> Void)? = nil
    ) {
        _content = State(initialValue: content)
        _fileName = State(initialValue: fileName)
        self.gist = gist
        self.language = language
        self.completion = completion
    }

    public var body: some View {
        view
            .navigationTitle(fileName)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButtonItem
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        if gist.owner?.login == currentAccount.user?.login {
                            Button {
                                routerPath.presentedSheet = .editorView(
                                    fileName: fileName,
                                    content: content,
                                    language: language,
                                    gist: gist
                                )
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }

                        Button {
                            routerPath.presentedSheet = .editorCodeSettings
                        } label: {
                            Label("View Code Options", systemImage: "gear")
                        }

                        if gist.owner?.login == currentAccount.user?.login {
                            Divider()
                            Button(role: .destructive) {
                                showConfirmDialog.toggle()
                            } label: {
                                Label("Delete File", systemImage: "trash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18))
                    }
                    .confirmationDialog(
                        "Are you sure you want to delete this file?",
                        isPresented: $showConfirmDialog,
                        titleVisibility: .visible
                    ) {
                        Button("Delete File", role: .destructive) {
                            Task {
                                do {
                                    try await viewModel.deleteGist(gistID: gist.id, fileName: fileName) {
                                        showSuccessToast.toggle()
                                    }
                                } catch let updateError {
                                    error = updateError.localizedDescription
                                    showErrorToast.toggle()
                                }
                            }
                        }
                    }
                }
            }
            .toastSuccess(isPresenting: $showSuccessToast, title: "Deleted File") {
                self.completion?()
                dismiss()
            }
            .toastError(isPresenting: $showErrorToast, error: error)
    }

    @ViewBuilder
    private var view: some View {
        Group {
            if language == .markdown {
                MarkdownUI(markdown: content)
            } else {
                EditorViewRepresentable(content: $content, language: language, isEditable: false)
            }
        }
    }

    private var backButtonItem: some View {
        Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundColor(Colors.accent.color)
        })
    }
}
