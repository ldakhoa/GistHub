//
//  EditorCodeSettingsView.swift
//  GistHub
//
//  Created by Khoa Le on 14/12/2022.
//

import SwiftUI
import Environment
import DesignSystem

public struct EditorCodeSettingsView: View {
    @EnvironmentObject private var userDefaultsStore: UserDefaultsStore

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
                EditorViewRepresentable(
                    content: $codeSample,
                    language: .javaScript,
                    isEditable: true,
                    isSelectable: true
                )
                .frame(height: 130)
            } header: {
                Text("Preview")
            }
            Section {
                makeToggleView(isOn: $userDefaultsStore.showLineNumbers, title: "Show Line Numbers")
                makeToggleView(isOn: $userDefaultsStore.wrapLines, title: "Line Wrapping")
                makeToggleView(isOn: $userDefaultsStore.highlightSelectedLine, title: "Highlight Selected Line")
            } header: {
                Text("display")
            }

            Section {
                makeToggleView(isOn: $userDefaultsStore.showPageGuide, title: "Show Page Guide")
                makeToggleView(isOn: $userDefaultsStore.showInvisibleCharacters, title: "Show Line Break")
                makeToggleView(isOn: $userDefaultsStore.showSpaces, title: "Show Spaces")
                makeToggleView(isOn: $userDefaultsStore.showTabs, title: "Show Tabs")
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
    }

    private func makeToggleView(isOn: Binding<Bool>, title: String) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
        }
        .tint(Colors.accent.color)
    }
}
