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
import Search

// swiftlint:disable cyclomatic_complexity
@MainActor
extension View {
    func withAppRouter() -> some View {
        navigationDestination(for: RouterDestination.self) { destination in
            switch destination {
            case let .gistDetail(gistId):
                GistDetailView(gistId: gistId)
            case let .stargazersFromGistDetail(gistId):
                StargazersView(gistID: gistId)
            case let .editorDisplay(content, fileName, gist, language):
                EditorDisplayView(
                    content: content,
                    fileName: fileName,
                    gist: gist,
                    language: language
                )
            case .settings:
                SettingView()
            case .settingsAccount:
                SettingAccountView()
            case .editorCodeSettings:
                EditorCodeSettingsView()
            case let .gistLists(mode):
                GistListsView(listsMode: mode)
            case .draftGistLists:
                DraftGistListsView()
            case let .userProfile(userName):
                UserProfileView(userName: userName)
            case let .searchUsers(query):
                SearchUsersView(query: query)
            case let .searchGists(query):
                SearchGistListsView(query: query)
            case let .userFollows(login, type):
                UserFollowsView(login: login, type: type)
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
            case let .browseFiles(files, gist, completion):
                BrowseFilesView(files: files, gist: gist, completion: completion)
                    .withEnvironments()
            case let .markdownTextEditor(style, completion):
                MarkdownTextEditorView(
                    style: style,
                    completion: completion)
            case .reportABug:
                ReportABugView()
            case .editorCodeSettings:
                NavigationStack {
                    EditorCodeSettingsView()
                        .withEnvironments()
                }
            case let .editorView(fileName, content, language, gist):
                NavigationStack {
                    EditorView(
                        style: .update,
                        fileName: fileName,
                        content: content,
                        language: language,
                        gist: gist
                    )
                }
            }
        }
    }

    func withEnvironments() -> some View {
      environmentObject(CurrentAccount.shared)
        .environmentObject(AppAccountsManager.shared)
        .environmentObject(UserDefaultsStore.shared)
    }
}
// swiftlint:enable cyclomatic_complexity
