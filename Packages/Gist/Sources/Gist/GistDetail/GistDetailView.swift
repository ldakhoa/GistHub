//
//  GistDetailView.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import DesignSystem
import Models
import Editor
import Comment
import Environment

public struct GistDetailView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var routerPath: RouterPath

    @StateObject private var viewModel = GistDetailViewModel()
    @StateObject private var commentViewModel = CommentViewModel()

    @State private var scrollOffset: CGPoint = .zero
    @State private var floatingButtonSize: CGSize = .zero

    @State private var showToastAlert = false
    @State private var showDeleteAlert = false

    @EnvironmentObject private var currentAccount: CurrentAccount

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
            case .error:
                ErrorView(
                    title: "Cannot Connect",
                    message: "Something went wrong. Please try again."
                ) {
                    fetchMetaData()
                }
            case let .content(gist):
                ZStack {
                    ScrollViewReader { scrollViewProxy in
                        ScrollView(showsIndicators: true) {
                            VStack(alignment: .leading, spacing: 10) {
                                titleView(gist: gist)

                                if let description = gist.description, !description.isEmpty {
                                    Text(description)
                                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                                        .font(.subheadline)
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

                                if let fork = gist.fork, let stargazerCount = gist.stargazerCount {
                                    HStack(spacing: 10) {
                                        HStack(spacing: 4) {
                                            let stargazerCountText = stargazerCount > 1 ? "stars" : "star"
                                            Image("star")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 16, height: 16)
                                            Text("\(stargazerCount) \(stargazerCountText)")
                                                .font(.subheadline)
                                        }
                                        .foregroundColor(Colors.neutralEmphasisPlus.color)

                                        HStack(spacing: 4) {
                                            let forkCountText = fork.totalCount > 1 ? "forks" : "fork"
                                            Image("fork")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 16, height: 16)
                                            Text("\(fork.totalCount) \(forkCountText)")
                                                .font(.subheadline)
                                        }
                                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                                    }
                                }

                                switch viewModel.starButtonState {
                                case .loading:
                                    ProgressView()
                                case .starred:
                                    starButton(isStarred: true)
                                case .unstarred:
                                    starButton(isStarred: false)
                                }
                            }
                            .padding(16)
                            .readingScrollView(from: "scroll", into: $scrollOffset)
                            .background(Colors.itemBackground)

                            Spacer(minLength: 16)

                            GistDetailCodeSectionView(
                                gist: gist,
                                routerPath: routerPath,
                                currentAccount: currentAccount,
                                viewModel: viewModel
                            )

                            Spacer(minLength: 16)

                            // padding bottom of the Button is 16,
                            // and we want the space between list and Comment button is 8
                            let listPaddingBottom: CGFloat = floatingButtonSize.height + 16 + 8
                            GistDetailCommentSectionView(
                                commentViewModel: commentViewModel,
                                gistId: gistId,
                                currentAccount: currentAccount
                            )
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

                    floatingCommentButton
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchMetaData()
        }
        .refreshable {
            fetchMetaData()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                leadingToolbarItem
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
                trailingToolbarItem
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
        .toastSuccess(isPresenting: $showToastAlert, title: "Deleted Gist", duration: 1.0) {
            shouldReloadGistListsView?()
            presentationMode.wrappedValue.dismiss()
        }
        .toastError(isPresenting: $commentViewModel.showErrorToast, error: commentViewModel.errorToastTitle)
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

                if let files = gist.files, let fileName = files.keys.first {
                    Text(gist.owner?.login ?? "")
                        .bold()
                    +
                    Text(" / ")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                    +
                    Text(fileName)
                        .bold()
                }
            }
            .onTapGesture {
                routerPath.navigateToUserProfileView(with: viewModel.gist.owner?.login ?? "")
            }

            if !(gist.public ?? true) {
                Image(systemName: "lock")
                    .font(.subheadline)
                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                    .padding(.leading, 2)
            }
        }
    }

    @ViewBuilder
    private var menuView: some View {
        Menu {
            // ShareLink in Menu currently works on iOS 16.1
            if let htmlURL = viewModel.gist.htmlURL,
               let shareUrl = URL(string: htmlURL) {
                ShareLinkView(item: shareUrl)
                Divider()
            }

            if currentAccount.user?.login == viewModel.gist.owner?.login {
                makeMenuButton(title: "Edit Gist", systemImage: "pencil") {
                    routerPath.presentedSheet = .editGist(viewModel.gist) { newGist in
                        Task {
                            await viewModel.gist(gistID: newGist.id)
                        }
                        viewModel.gist = newGist
                    }
                }
            }

            if let htmlUrl = viewModel.gist.htmlURL,
               let url = URL(string: htmlUrl) {
                Link(destination: url) {
                    Label("Open In Browser", systemImage: "globe")
                }
            }

            Divider()

            if currentAccount.user?.login == viewModel.gist.owner?.login {
                makeMenuButton(title: "Delete", systemImage: "trash", role: .destructive) {
                    showDeleteAlert.toggle()
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .foregroundColor(Colors.accent.color)
        }
    }

    private func fileName() -> String {
        if let files = viewModel.gist.files, let fileName = files.keys.first {
            return fileName
        }
        return ""
    }

    @ViewBuilder
    private var floatingCommentButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                GistHubButton(
                    imageName: "bubble.left",
                    title: "Write Comment",
                    foregroundColor: Colors.Palette.White.white0.dynamicColor.color,
                    background: Colors.commentButton.color,
                    padding: 12.0,
                    radius: 8.0
                ) {
                    routerPath.presentedSheet = .markdownTextEditor(style: .writeComment(content: "")) { content in
                        Task {
                            await commentViewModel.createComment(
                                gistID: gistId,
                                body: content
                            )
                        }
                    }
                }
                .readSize { buttonSize in
                    self.floatingButtonSize = buttonSize
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }

    @ViewBuilder
    private var leadingToolbarItem: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .foregroundColor(Colors.accent.color)
        })
    }

    @ViewBuilder
    private var trailingToolbarItem: some View {
        if viewModel.isFetchingGist {
            ProgressView()
        } else {
            menuView
        }
    }

    @ViewBuilder
    private func starButton(isStarred: Bool) -> some View {
        Button {
            Task {
                HapticManager.shared.fireHaptic(of: .buttonPress)
                if isStarred {
                    await viewModel.unstarGist()
                } else {
                    await viewModel.starGist()
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

    private func fetchMetaData(refresh: Bool = false) {
        Task {
            await viewModel.isStarred(gistID: gistId)
            await viewModel.gist(gistID: gistId)

            if refresh {
                await commentViewModel.refreshComments(from: gistId)
            } else {
                await commentViewModel.fetchComments(gistID: gistId)
            }
        }
    }
}

public extension GistDetailView {
    @ViewBuilder
    static func contextMenuPreview(
        gist: Gist,
        currentAccount: CurrentAccount,
        routerPath: RouterPath
    ) -> some View {
        // Put in NavigationStack to solve size issues
        NavigationStack {
            GistDetailView(gistId: gist.id)
                .environmentObject(currentAccount)
                .environmentObject(routerPath)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(UIColor.secondarySystemGroupedBackground.color, for: .navigationBar)
                .navigationTitle("\(gist.owner?.login ?? "") / \(gist.files?.fileName ?? "")")
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
