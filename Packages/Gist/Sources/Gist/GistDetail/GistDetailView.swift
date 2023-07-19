//
//  GistDetailView.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import AlertToast
import SwiftUI
import Inject
import DesignSystem
import Common
import Models
import Editor
import Comment
import Environment

public struct GistDetailView: View {
    @ObserveInjection private var inject
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = GistDetailViewModel()
    @StateObject private var commentViewModel = CommentViewModel()

    @State private var scrollOffset: CGPoint = .zero
    @State private var floatingButtonSize: CGSize = .zero

    @State private var showToastAlert = false
    @State private var showCommentTextEditor = false
    @State private var showDeleteAlert = false
    @State private var showToastError = false
    @State private var gistDescription = ""
    @State private var showBrowseFiles = false
    @State private var showEditGist = false

    @EnvironmentObject public var currentAccount: CurrentAccount

    private let gistId: String
    private let shouldReloadGistListsView: (() -> Void)?

    public init(
        gistId: String,
        shouldReloadGistListsView: (() -> Void)? = nil
    ) {
        self.gistId = gistId
        self.shouldReloadGistListsView = shouldReloadGistListsView
    }

    public var body: some View {
        ZStack {
            switch viewModel.contentState {
            case .loading:
                ProgressView()
            case let .error(error):
                Text(error)
                    .foregroundColor(Colors.danger.color)
            case let .content(gist):
                ZStack {
                    ScrollViewReader { scrollViewProxy in
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading, spacing: 8) {
                                titleView(gist: gist)

                                if let description = gist.description, !description.isEmpty {
                                    Text(description)
                                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                if let createdAt = gist.createdAt,
                                   let updatedAt = gist.updatedAt {
                                    if createdAt == updatedAt {
                                        Text("Created \(createdAt.agoString())")
                                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                                            .font(.subheadline)
                                    } else {
                                        Text("Last active \(createdAt.agoString())")
                                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                                            .font(.subheadline)
                                    }
                                }

                                switch viewModel.starButtonState {
                                case .idling:
                                    EmptyView()
                                case .starred:
                                    buildStarButton(isStarred: true)
                                case .unstarred:
                                    buildStarButton(isStarred: false)
                                }
                            }
                            .padding(16)
                            .readingScrollView(from: "scroll", into: $scrollOffset)
                            .background(Colors.itemBackground)

                            Spacer(minLength: 16)

                            buildCodeSection(gist: gist)

                            Spacer(minLength: 16)

                            // padding bottom of the Button is 16,
                            // and we want the space between list and Comment button is 8
                            let listPaddingBottom: CGFloat = floatingButtonSize.height + 16 + 8
                            buildCommentSection()
                                .padding(.bottom, listPaddingBottom)
                        }
                        .onChange(of: commentViewModel.comments) { _ in
                            if commentViewModel.shouldScrollToComment {
                                withAnimation {
                                    scrollViewProxy.scrollTo(commentViewModel.comments.last?.id, anchor: .center)
                                }
                            }
                        }
                        .coordinateSpace(name: "scroll")
                        .background(Colors.scrollViewBackground)
                        .animation(.spring(), value: commentViewModel.comments)
                    }

                    buildFloatingCommentButton()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.isStarred(gistID: gistId)
            }
        }
        .onLoad {
            Task {
                await commentViewModel.fetchComments(gistID: gistId)
                await viewModel.gist(gistID: gistId)
            }
        }
        .refreshable {
            Task {
                await viewModel.gist(gistID: gistId)
                await commentViewModel.fetchComments(gistID: gistId)
                await viewModel.isStarred(gistID: gistId)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                makeLeadingToolbarButton()
            }
            if scrollOffset.y >= 15 {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .center) {
                        Text(viewModel.gist.owner?.login ?? "")
                        Text("\(fileName())")
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    .font(.subheadline)
                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                    .opacity(scrollOffset.y / 45.0)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isFetchingGist {
                    ProgressView()
                } else {
                    Menu {
                        if currentAccount.user?.id == viewModel.gist.owner?.id {
                            makeMenuButton(title: "Edit Gist", systemImage: "pencil") {
                                showEditGist.toggle()
                            }
                        }

                        if let htmlUrl = viewModel.gist.htmlURL,
                           let url = URL(string: htmlUrl) {
                            Link(destination: url) {
                                Label("Open In Browser", systemImage: "globe")
                            }
                        }

                        // ShareLink in Menu currently works on iOS 16.1
                        if #available(iOS 16.1, *) {
                            let titlePreview = "\(viewModel.gist.owner?.login ?? "")/\(viewModel.gist.files?.fileName ?? "")"
                            makeShareLink(itemString: viewModel.gist.htmlURL ?? "", previewTitle: titlePreview, label: "Share")
                        }

                        Divider()

                        if currentAccount.user?.id == viewModel.gist.owner?.id {
                            makeMenuButton(title: "Delete", systemImage: "trash", role: .destructive) {
                                showDeleteAlert.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Colors.accent.color)
                    }
                }
            }
        }
        .confirmationDialog("Delete Gist?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteGist(gistID: viewModel.gist.id)
                }
                showToastAlert.toggle()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you positive you want to delete this Gist?")
        }
        .sheet(isPresented: $showCommentTextEditor) {
            MarkdownTextEditorView(
                style: .writeComment,
                gistID: gistId,
                navigationTitle: "Write Comment",
                placeholder: "Write a comment...",
                commentViewModel: self.commentViewModel
            )
        }
        .toastSuccess(isPresenting: $showToastAlert, title: "Deleted Gist", duration: 1.0) {
            shouldReloadGistListsView?()
            self.dismiss()
        }
        .sheet(isPresented: $showEditGist) {
            EmptyView()
            ComposeGistView(style: .update(gist: viewModel.gist)) { gist in
                viewModel.gist = gist
            }
        }
        .enableInjection()
    }

    @ViewBuilder
    private func titleView(gist: Gist) -> some View {
        HStack(alignment: .center, spacing: 4) {
            HStack(spacing: 6) {
                if
                    let avatarURLString = gist.owner?.avatarURL,
                    let url = URL(string: avatarURLString)
                {
                    GistHubImage(url: url)
                }
                Text(gist.owner?.login ?? "")
                    .bold()
            }
            if let files = gist.files, let fileName = files.keys.first {
                Text("/")
                    .foregroundColor(Colors.neutralEmphasisPlus.color)

                Text(fileName)
                    .bold()
            }
            if !(gist.public ?? true) {
                Image(systemName: "lock")
                    .font(.subheadline)
                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                    .padding(.leading, 2)
            }
        }
    }

    private func fileName() -> String {
        if let files = viewModel.gist.files, let fileName = files.keys.first {
            return fileName
        }
        return ""
    }

    private func buildFloatingCommentButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showCommentTextEditor.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                        Text("Write Comment")
                    }
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(12)
                    .background(Colors.commentButton.color)
                    .foregroundColor(Colors.Palette.White.white0.dynamicColor.color)
                    .cornerRadius(8)
                    .shadow(
                        color: Colors.Palette.Black.black0.dynamicColor.color.opacity(0.4),
                        radius: 8
                    )
                }
                .readSize { buttonSize in
                    self.floatingButtonSize = buttonSize
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }

    private func buildStarButton(isStarred: Bool) -> some View {
        Button {
            Task {
                if isStarred {
                    await viewModel.unstarGist(gistID: gistId)
                } else {
                    await viewModel.starGist(gistID: gistId)
                }
            }
        } label: {
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Image(isStarred ? "star-fill" : "star")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                    Text(isStarred ? "Unstar" : "Star")
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding(12)
            .background(Colors.buttonBackground.color)
            .foregroundColor(Colors.buttonForeground.color)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Colors.buttonBorder.color)
            )
        }
    }

    private func makeMenuButton(
        title: String,
        systemImage: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(role: role ?? .none, action: action) {
            Label(title, systemImage: systemImage)
        }
    }

    private func makeLeadingToolbarButton() -> some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundColor(Colors.accent.color)
        })
    }

    private func buildCommentSection() -> some View {
        ZStack {
            switch commentViewModel.contentState {
            case .loading:
                ProgressView()
            case let .error(error):
                Text(error).foregroundColor(Colors.danger.color)
            case .showContent:
                let comments = commentViewModel.comments
                VStack(alignment: .leading) {
                    let commentTitle = comments.count > 1 ? "Comments" : "Comment"
                    Text(comments.isEmpty ? "" : commentTitle)
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .padding(.horizontal, 16)
                    LazyVStack(alignment: .leading) {
                        ForEach(comments, id: \.id) { comment in
                            CommentView(comment: comment, gistID: gistId, viewModel: commentViewModel)
                                .id(comment.id)
//                                .environmentObject(userStore)
                            if !isLastObject(objects: comments, object: comment) {
                                Divider()
                                    .overlay(Colors.neutralEmphasis.color)
                            }
                        }
                    }
                    .padding(.vertical, comments.isEmpty ? 0 : 4)
                    .background(Colors.itemBackground)
                }
            }
        }
    }

    private func buildCodeSection(gist: Gist) -> some View {
        let fileNames = gist.files?.keys.map { String($0) } ?? []
        return VStack(alignment: .leading) {
            HStack {
                Text(fileNames.count > 1 ? "Files" : "File")
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                Spacer()

                Button("Browse files") {
                    showBrowseFiles.toggle()
                }
                .font(.callout)
                .foregroundColor(Colors.accent.color)
                .sheet(isPresented: $showBrowseFiles) {
                    let files = gist.files?.values.map { $0 } ?? []
                    BrowseFilesView(files: files, gist: gist) {
                        Task {
                            await viewModel.gist(gistID: gist.id)
                        }
                    }
                    .environmentObject(currentAccount)
                }
            }
            .padding(.horizontal, 16)

            LazyVStack(alignment: .leading) {
                ForEach(fileNames, id: \.hashValue) { fileName in
                    buildFileNameView(gist: gist, fileName: fileName)
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

    private func makeShareLink(itemString: String, previewTitle: String, label: String) -> some View {
        ShareLink(
            item: itemString,
            preview: SharePreview(previewTitle, image: Image("default"))
        ) {
            Label(label, systemImage: "square.and.arrow.up")
        }
    }

    private func buildFileNameView(gist: Gist, fileName: String) -> some View {
        let file = gist.files?[fileName]
        let content = file?.content ?? ""
        let language = file?.language ?? .unknown
        return NavigationLink {
            EditorDisplayView(
                content: content,
                fileName: fileName,
                gist: gist,
                language: language
            ) {
                Task {
                    await viewModel.gist(gistID: gist.id)
                }
            }
            .environmentObject(currentAccount)
        } label: {
            VStack(alignment: .leading) {
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
            }
        }
        .contextMenu {
            let titlePreview = "\(gist.owner?.login ?? "")/\(gist.files?.fileName ?? "")"
            makeShareLink(itemString: gist.htmlURL ?? "", previewTitle: titlePreview, label: "Share via...")
        } preview: {
            NavigationStack {
                EditorDisplayView(
                    content: content,
                    fileName: fileName,
                    gist: gist,
                    language: language
                ) {}
                .environmentObject(currentAccount)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

// MARK: - Enable swipe back to pop screen

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    // To make it works also with ScrollView
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

// MARK: - Color for GistDetailView

fileprivate extension Colors {
    static let scrollViewBackground = UIColor.systemGroupedBackground.color
    static let itemBackground = UIColor.secondarySystemGroupedBackground.color
    static let commentButton = UIColor(light: Colors.Palette.Black.black0.light, dark: Palette.Gray.gray7.dark)
    static let fileNameForeground = UIColor(light: Colors.Palette.Black.black0.light, dark: .white)
}
