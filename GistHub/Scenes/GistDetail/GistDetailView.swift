//
//  GistDetailView.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import AlertToast
import SwiftUI
import Inject
import Kingfisher

struct GistDetailView: View {
    @ObserveInjection private var inject
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = GistDetailViewModel()
    @State private var scrollOffset: CGPoint = .zero
    @State private var floatingButtonSize: CGSize = .zero

    @State private var showToastAlert = false
    @State private var showDeleteAlert = false

    @EnvironmentObject var userStore: UserStore

    let gist: Gist
    let shouldReloadGistListsView: () -> Void

    var body: some View {
        ZStack {
            switch viewModel.contentState {
            case .loading:
                ProgressView()
            case let .error(error):
                Text(error)
                    .foregroundColor(Colors.danger.color)
            case let .content(gist):
                ZStack {
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 8) {
                            buildTitleView()

                            if let description = gist.description, !description.isEmpty {
                                Text(description)
                                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                                    .lineLimit(2)
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
                    .coordinateSpace(name: "scroll")
                    .background(Colors.scrollViewBackground)

                    buildFloatingCommentButton()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.isStarred(gistID: gist.id)
            }
        }
        .onLoad {
            Task {
                await viewModel.comments(gistID: gist.id)
                await viewModel.gist(gistID: gist.id)
            }
        }
        .refreshable {
            Task {
                await viewModel.gist(gistID: gist.id)
                await viewModel.comments(gistID: gist.id)
                await viewModel.isStarred(gistID: gist.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                makeLeadingToolbarButton()
            }
            if scrollOffset.y >= 15 {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .center) {
                        Text(gist.owner?.login ?? "")
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
                Menu {
                    if userStore.user.id == gist.owner?.id {
                        makeMenuButton(title: "Make public", systemImage: "lock.open") {}
                    }

                    makeMenuButton(title: "Shared", systemImage: "square.and.arrow.up") {}

                    if userStore.user.id == gist.owner?.id {
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
        .confirmationDialog("Delete Gist?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteGist(gistID: gist.id)
                }
                showToastAlert.toggle()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you positive you want to delete this Gist?")
        }
        .toast(
            isPresenting: $showToastAlert,
            duration: 1.0,
            alert: {
                AlertToast(
                    displayMode: .banner(.pop),
                    type: .complete(Colors.success.color),
                    title: "Deleted Gist",
                    style: .style(backgroundColor: Colors.toastBackground.color, titleColor: nil)
                )
            }, completion: {
                shouldReloadGistListsView()
                self.dismiss()
            }
        )
        .enableInjection()
    }

    private func buildTitleView() -> some View {
        HStack(alignment: .center, spacing: 4) {
            HStack(spacing: 6) {
                if
                    let avatarURLString = gist.owner?.avatarURL,
                    let url = URL(string: avatarURLString)
                {
                    KFImage
                        .url(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 24, height: 24)
                        .cornerRadius(12)
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
        if let files = gist.files, let fileName = files.keys.first {
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

                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                        Text("Write Comment")
                    }
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding()
                    .background(Colors.commentButton.color)
                    .foregroundColor(Colors.Palette.White.white0.dynamicColor.color)
                    .cornerRadius(12)
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
                    await viewModel.unstarGist(gistID: gist.id)
                } else {
                    await viewModel.starGist(gistID: gist.id)
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
        Button(action: { dismiss() }, label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundColor(Colors.accent.color)
        })
    }

    private func buildCommentSection() -> some View {
        ZStack {
            switch viewModel.commentContentState {
            case .loading:
                ProgressView()
            case let .error(error):
                Text(error).foregroundColor(Colors.danger.color)
            case let .content(comments):
                VStack(alignment: .leading) {
                    let commentTitle = comments.count > 1 ? "Comments" : "Comment"
                    Text(comments.isEmpty ? "" : commentTitle)
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .padding(.horizontal, 16)
                    LazyVStack(alignment: .leading) {
                        ForEach(comments, id: \.id) { comment in
                            CommentView(comment: comment)
                            Divider()
                                .overlay(Colors.neutralEmphasis.color)
                        }
                    }
                    .background(Colors.itemBackground)
                }
            }
        }
    }

    private func buildCodeSection(gist: Gist) -> some View {
        let fileNames = gist.files?.keys.map { String($0) } ?? []
        return VStack(alignment: .leading) {
            Text(fileNames.count > 1 ? "Files" : "File")
                .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                .foregroundColor(Colors.neutralEmphasisPlus.color)
                .padding(.horizontal, 16)
            LazyVStack(alignment: .leading) {
                ForEach(fileNames, id: \.hashValue) { fileName in
                    buildFileNameView(gist: gist, fileName: fileName)
                    if !isLastFileName(fileNames: fileNames, fileName) {
                        Divider()
                            .overlay(Colors.neutralEmphasis.color)
                            .padding(.leading, 42)
                    }
                }
            }
            .padding(.vertical, 4)
            .background(Colors.itemBackground)
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
            .environmentObject(userStore)
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
            ShareLink(
                item: gist.htmlURL ?? "",
                preview: SharePreview(titlePreview, image: Image(systemName: "home"))
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
            }
        }
    }

    private func isLastFileName(fileNames: [String], _ fileName: String) -> Bool {
        let fileNamesCount = fileNames.count
        if let index = fileNames.firstIndex(of: fileName) {
            if index + 1 != fileNamesCount {
                return false
            }
        }
        return true
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
