//
//  EditorDisplayView.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import SwiftUI
import Inject

struct EditorDisplayView: View {
    @State var content: String = ""
    @State var fileName: String = ""

    @State private var showEditorInEditMode = false

    @Environment(\.dismiss) private var dismiss
    @ObserveInjection private var inject

    var body: some View {
        EditorViewRepresentable(content: $content, isEditable: false)
            .navigationTitle(fileName)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    makeBackButtonItem()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showEditorInEditMode.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }

                        Button {
                            showEditorInEditMode.toggle()
                        } label: {
                            Label("View Code Options", systemImage: "gear")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18))
                    }
                    .sheet(isPresented: $showEditorInEditMode) {
                        NavigationView {
                            EditorView(content: content)
                        }
                    }
                }
            }
            .enableInjection()
    }

    private func makeBackButtonItem() -> some View {
        Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundColor(Colors.accent.color)
        })
    }
}
