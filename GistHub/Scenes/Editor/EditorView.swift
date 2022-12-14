//
//  EditorView.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import SwiftUI
import Inject

struct EditorView: View {
    @State var content: String = ""
    let language: File.Language

    @Environment(\.dismiss) private var dismiss
    @ObserveInjection private var inject

    var body: some View {
        EditorViewRepresentable(content: $content, language: language, isEditable: true)
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Colors.accent.color)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update") {
                        dismiss()
                    }
                    .foregroundColor(Colors.accent.color)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .enableInjection()
            .onChange(of: content) { newValue in
                NotificationCenter.default.post(name: .editorTextViewTextDidChange, object: newValue)
            }
    }
}
