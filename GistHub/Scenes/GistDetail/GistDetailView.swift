//
//  GistDetailView.swift
//  GistHub
//
//  Created by Khoa Le on 10/12/2022.
//

import SwiftUI
import Inject
import Kingfisher

struct GistDetailView: View {
    @ObserveInjection private var inject

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = GistDetailViewModel()
    @State private var scrollOffset: CGPoint = .zero

    let gist: Gist

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
                    ScrollView {
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

                        VStack {
                            Text("Test scroll")
                        }
                    }
                    .coordinateSpace(name: "scroll")

                    buildFloatingCommentButton()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.isStarred(gistID: gist.id)
                await viewModel.gist(gistID: gist.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 18))
                        .foregroundColor(Colors.accent.color)
                })
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
                    makeMenuButton(title: "Edit", systemImage: "pencil") {

                    }

                    makeMenuButton(title: "Shared", systemImage: "square.and.arrow.up") {

                    }

                    makeMenuButton(title: "Delete", systemImage: "trash", role: .destructive) {

                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Colors.accent.color)
                }
            }
        }
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
                    .background(Colors.Palette.Black.black0.dynamicColor.color)
                    .foregroundColor(Colors.Palette.White.white0.dynamicColor.color)
                    .cornerRadius(12)
                    .shadow(
                        color: Colors.Palette.Black.black0.dynamicColor.color.opacity(0.4),
                        radius: 8
                    )
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
}

/// Enable swipe back to pop screen
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
