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
import Editor

public struct BrowseFilesView: View {
    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var currentAccount: CurrentAccount
    @StateObject private var routerPath: RouterPath = RouterPath()
    @StateObject private var viewModel = BrowseFilesViewModel()

    @State private var files: [File]
    private let gist: Gist
    private let completion: ((File) -> Void)?

    public init(
        files: [File],
        gist: Gist,
        completion: ((File) -> Void)? = nil
    ) {
        _files = State(initialValue: files)
        self.gist = gist
        self.completion = completion
    }

    public var body: some View {
        NavigationStack(path: $routerPath.path) {
            List {
                switch viewModel.contentState {
                case .loading:
                    ForEach(File.placeholders) { file in
                        fileView(file: file)
                            .redacted(reason: .placeholder)
                    }
                case let .content(files):
                    ForEach(files) { file in
                        fileView(file: file)
                    }
                }
            }
            .listStyle(.grouped)
            .searchable(text: $viewModel.searchText, prompt: Text("Search files..."))
            .onChange(of: viewModel.searchText) { _ in viewModel.search() }
            .animation(.default, value: viewModel.searchText)
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
        }
        .enableInjection()
    }

    @ViewBuilder
    private func fileView(file: File) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(file.filename ?? "")
                    .bold()
                    .foregroundColor(Colors.fileNameForeground.color)
                Text(file.content ?? "")
                    .font(.callout)
                    .lineLimit(1)
                    .foregroundColor(Colors.neutralEmphasis.color)
            }
            Spacer()
            RightChevronRowImage()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            completion?(file)
            dismiss()
        }
    }
}

@MainActor
private final class BrowseFilesViewModel: ObservableObject {
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
