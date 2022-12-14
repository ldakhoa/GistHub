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

    @Environment(\.dismiss) private var dismiss
    @ObserveInjection private var inject

    var body: some View {
        EditorViewRepresentable(content: $content, isEditable: true)
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 18))
                            .foregroundColor(Colors.accent.color)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Update") {
                        print(content)
                        dismiss()
                    }
                }
            }
            .enableInjection()
            .onChange(of: content) { newValue in
                NotificationCenter.default.post(name: .editorTextViewTextDidChange, object: newValue)
            }
    }
}

