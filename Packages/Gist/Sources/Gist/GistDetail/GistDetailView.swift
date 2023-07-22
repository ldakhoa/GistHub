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

    @ViewBuilder
    private var menuView: some View {
        Menu {
            if currentAccount.user?.id == viewModel.gist.owner?.id {
                makeMenuButton(title: "Edit Gist", systemImage: "pencil") {
                    routerPath.presentedSheet = .editGist(viewModel.gist) { newGist in
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

            // ShareLink in Menu currently works on iOS 16.1
            if #available(iOS 16.1, *) {
                let titlePreview = "\(viewModel.gist.owner?.login ?? "")/\(viewModel.gist.files?.fileName ?? "")"
                ShareLinkView(
                    itemString: viewModel.gist.htmlURL ?? "",
                    previewTitle: titlePreview,
                    labelTitle: "Share"
                )
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
                Button {
                    routerPath.presentedSheet = .commentTextEditor(
                        gistId: gistId,
                        navigationTitle: "Write Comment",
                        placeholder: "Write a comment...",
                        commentViewModel: self.commentViewModel
                    )
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
