//
//  EditorCodeSettingsView.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import SwiftUI
import Inject

public struct EditorCodeSettingsView: View {
    @ObservedObject private var codeSettingsStore = CodeSettingsStore()

    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss

    @State private var codeSample: String =
        """
        function fibonacci(n) {
            return n < 1 ? 0
                : n <= 2 ? 1
                : fibonacci(n - 1) + fibonacci(n - 2)
        }
        """

    public init() {}

    public var body: some View {
        List {
            Section {
                EditorViewRepresentable(content: $codeSample, language: .javaScript, isEditable: true, isSelectable: true)
                    .frame(height: 130)
            } header: {
                Text("Preview")
            }
            Section {
                makeToggleView(isOn: $codeSettingsStore.showLineNumbers, title: "Show Line Numbers")
                makeToggleView(isOn: $codeSettingsStore.wrapLines, title: "Line Wrapping")
                makeToggleView(isOn: $codeSettingsStore.highlightSelectedLine, title: "Highlight Selected Line")
                makeToggleView(isOn: $codeSettingsStore.forceDarkTheme, title: "Force Dark Theme")
            } header: {
                Text("display")
            }

            Section {
                makeToggleView(isOn: $codeSettingsStore.showPageGuide, title: "Show Page Guide")
                makeToggleView(isOn: $codeSettingsStore.showInvisibleCharacters, title: "Show Line Break")
                makeToggleView(isOn: $codeSettingsStore.showSpaces, title: "Show Spaces")
                makeToggleView(isOn: $codeSettingsStore.showTabs, title: "Show Tabs")
            } header: {
                Text("Editing")
            }
        }
        .navigationTitle("Code Options")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .enableInjection()
    }

    private func makeToggleView(isOn: Binding<Bool>, title: String) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
        }
        .tint(Colors.accent.color)
    }
}
