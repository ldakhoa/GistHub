import SwiftUI
import Models
import Environment
import DesignSystem
import Editor

struct GistDetailCodeSectionView: View {
    let gist: Gist
    let routerPath: RouterPath
    let currentAccount: CurrentAccount
    @ObservedObject var viewModel: GistDetailViewModel

    var body: some View {
        let fileNames = gist.files?.keys.map { String($0) } ?? []
        VStack(alignment: .leading) {
            HStack {
                Text(fileNames.count > 1 ? "Files" : "File")
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                Spacer()

                Button("Browse files") {
                    let files = gist.files?.values.map { $0 } ?? []
                    routerPath.presentedSheet = .browseFiles(files: files, gist: gist) { file in
                        navigateToEditorDisplay(with: file)
                    }
                }
                .font(.callout)
                .foregroundColor(Colors.accent.color)
            }
            .padding(.horizontal, 16)

            LazyVStack(alignment: .leading) {
                ForEach(fileNames, id: \.hashValue) { fileName in
                    fileView(fileName: fileName)
                    if !isLastObject(objects: fileNames, object: fileName) {
                        Divider()
                            .overlay(Colors.neutralEmphasis.color)
                            .padding(.leading, 42)
                    }
                }
            }
            .padding(.vertical, fileNames.isEmpty ? 0 : 4)
            .background(Colors.itemBackground)
        }
    }

    @ViewBuilder
    @MainActor
    private func fileView(fileName: String) -> some View {
        let file = gist.files?[fileName]
        let content = file?.content ?? ""
        let language = file?.language ?? .unknown

        HStack(alignment: .center) {
            Image(systemName: "doc")
            Text(fileName)
            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16))
                .foregroundColor(Colors.neutralEmphasis.color)
        }
        .foregroundColor(Colors.fileNameForeground.color)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            navigateToEditorDisplay(with: file)
        }
        .contextMenu {
            if let url = gist.url, let shareUrl = URL(string: "\(url)#\(fileName)") {
                ShareLinkView(item: shareUrl)
            }
        } preview: {
            contextMenuPreview(content: content, fileName: fileName, language: language)
        }
    }

    @ViewBuilder
    private func contextMenuPreview(
        content: String,
        fileName: String,
        language: File.Language
    ) -> some View {
        NavigationStack {
            EditorDisplayView(
                content: content,
                fileName: fileName,
                gist: gist,
                language: language
            )
            .environmentObject(currentAccount)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func navigateToEditorDisplay(with file: File?) {
        let content = file?.content ?? ""
        let language = file?.language ?? .unknown
        let fileName = file?.filename ?? ""

        routerPath.navigate(to: .editorDisplay(
            content: content,
            fileName: fileName,
            gist: gist,
            language: language)
        )
    }
}

fileprivate extension Colors {
    static let itemBackground = UIColor.secondarySystemGroupedBackground.color
    static let fileNameForeground = UIColor(light: Colors.Palette.Black.black0.light, dark: .white)
}
