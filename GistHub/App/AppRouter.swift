//
//  AppRouter.swift
//  GistHub
//
//  Created by Khoa Le on 19/07/2023.
//

import SwiftUI
import Environment
import Gist
import Editor
import Profile
import Settings
import AppAccount

@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case let .gistDetail(gistId):
                GistDetailView(gistId: gistId)
            case let .editorDisplay(content, fileName, gist, language):
                EditorDisplayView(content: content, fileName: fileName, gist: gist, language: language)
            case .settings:
                SettingView()
            case .settingsAccount:
                SettingAccountView()
            case .editorCodeSettings:
                EditorCodeSettingsView()
            }
        }
    }

    func withSheetDestinations(sheetDestinations: Binding<SheetDestination?>) -> some View {
        sheet(item: sheetDestinations) { destination in
            switch destination {
            case let .newGist(completion):
                ComposeGistView(style: .createGist, completion: completion)
            case let .editGist(gist, completion):
                ComposeGistView(style: .update(gist: gist), completion: completion)
            case let .browseFiles(files, gist, dismissAction):
                BrowseFilesView(files: files, gist: gist, dismissAction: dismissAction)
                    .withEnvironments()
            case let .commentTextEditor(gistId, navigationTitle, placeholder, commentViewModel):
                MarkdownTextEditorView(
                    style: .writeComment,
                    gistID: gistId,
                    navigationTitle: navigationTitle,
                    placeholder: placeholder,
                    commentViewModel: commentViewModel
                )
            case .reportABug:
                ReportABugView()
            }
        }
    }

    func withEnvironments() -> some View {
      environmentObject(CurrentAccount.shared)
        .environmentObject(AppAccountsManager.shared)
    }
}