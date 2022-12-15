//
//  PlainTextEditor.swift
//  GistHub
//
//  Created by Khoa Le on 16/12/2022.
//

import AlertToast
import SwiftUI
import Inject

struct PlainTextEditorView: View {
    @State var description: String
    let gistID: String
    let navigationTitle: String
    let placeholder: String
    let completion: () -> Void

    @ObserveInjection private var inject
    
    @StateObject private var viewModel = EditorViewModel()
    @State private var originalDescription = ""
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var contentHasChanged = false
    @State private var showConfirmDialog = false
    @State private var showSuccessToast = false
    @State private var showErrorToast = false
    @State private var error = ""
    @State private var placeholderState = ""

    var body: some View {
        NavigationStack {
            ZStack {
                TextEditor(text: $description)
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
                                Task {
                                    do {
                                        try await viewModel.updateDescription(description, gistID: gistID) {
                                            self.showSuccessToast.toggle()
                                        }
                                    } catch let gistError {
                                        error = gistError.localizedDescription
                                        self.showErrorToast.toggle()
                                    }
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
            self.originalDescription = description
            placeholderState = description.isEmpty ? placeholder : ""
            isFocused = true
        }
        .onChange(of: description) { newValue in
            contentHasChanged = newValue != originalDescription ? true : false
            placeholderState = description.isEmpty ? placeholder : ""
        }
        .confirmationDialog("Are you sure you want to cancel?", isPresented: $showConfirmDialog, titleVisibility: .visible) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Your changes will be discarded.")
        }
        .toast(isPresenting: $showSuccessToast, duration: 1.0) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .complete(Colors.success.color),
                title: "Updated Description",
                style: .style(backgroundColor: Colors.toastBackground.color)
            )
        } completion: {
            dismiss()
            completion()
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
}
