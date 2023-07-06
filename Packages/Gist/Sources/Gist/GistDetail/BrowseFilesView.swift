//
//  BrowseFilesView.swift
//  GistHub
//
//  Created by Khoa Le on 02/01/2023.
//

import SwiftUI
import Inject
import DesignSystem
import Models
import Environment

public struct BrowseFilesView: View {
    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ViewModel()
    @EnvironmentObject var userStore: UserStore

    @State var files: [File]
    let gist: Gist
    let dismissAction: () -> Void

    public var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.contentState {
                case .loading:
                    ProgressView()
                case let .content(files):
                    List {
                        ForEach(files) { file in
                            NavigationLink {
                                buildEditorDisplayView(file: file)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(file.filename ?? "")
                                        .bold()
                                        .foregroundColor(Colors.fileNameForeground.color)
                                    Text(file.content ?? "")
                                        .font(.callout)
                                        .lineLimit(1)
                                        .foregroundColor(Colors.neutralEmphasis.color)
                                }
                            }
                        }
                    }
                    .listStyle(.grouped)
                    .searchable(text: $viewModel.searchText, prompt: Text("Search files..."))
                    .onChange(of: viewModel.searchText) { _ in viewModel.search() }
                    .animation(.default, value: files)
                }
            }
            .navigationTitle("Browse Files")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Colors.listBackground.color, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Colors.accent.color)
                }
            }
            .onLoad {
                viewModel.onLoad(files: self.files)
            }
            .onDisappear {
                dismissAction()
            }
        }
        .enableInjection()
    }

    private func buildEditorDisplayView(file: File) -> some View {
        let content = file.content ?? ""
        let language = file.language ?? .unknown
        let fileName = file.filename ?? ""

        return EditorDisplayView(
            content: content,
            fileName: fileName,
            gist: gist,
            language: language
        ) {}
            .environmentObject(userStore)
            .toolbar(.visible, for: .navigationBar)
            .contextMenu {
                let titlePreview = "\(gist.owner?.login ?? "")/\(gist.files?.fileName ?? "")"
                ShareLink(
                    item: gist.htmlURL ?? "",
                    preview: SharePreview(titlePreview, image: Image("default"))
                ) {
                    Label("Share via...", systemImage: "square.and.arrow.up")
                }
            } preview: {
                NavigationStack {
                    EditorDisplayView(
                        content: content,
                        fileName: fileName,
                        gist: gist,
                        language: language
                    ) {}
                        .environmentObject(userStore)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
    }
}

@MainActor private final class ViewModel: ObservableObject {
    @Published private var files = [File]()
    @Published var contentState: ContentState = .loading
    @Published var searchText = ""

    func onLoad(files: [File]) {
        contentState = .content(files: files)
        self.files = files
    }

    func search() {
        if searchText.isEmpty {
            contentState = .content(files: files)
        } else {
            let newFiles = files.filter { file in
                guard let filename = file.filename else { return false }
                return filename.localizedCaseInsensitiveContains(searchText)
            }
            self.contentState = .content(files: newFiles)
        }
    }

    enum ContentState {
        case loading
        case content(files: [File])
    }
 }

fileprivate extension Colors {
    static let fileNameForeground = UIColor(light: Colors.Palette.Black.black0.light, dark: .white)
}
