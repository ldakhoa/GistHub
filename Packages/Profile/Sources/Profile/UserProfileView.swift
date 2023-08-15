import SwiftUI
import Models
import Environment
import DesignSystem
import AppAccount
import Utilities

public struct UserProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var scrollOffset: CGPoint = .zero

    // MARK: - Dependencies

    private let userName: String
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var appAccountsManager: AppAccountsManager
    @EnvironmentObject private var routerPath: RouterPath

    // MARK: - Initialiser

    public init(userName: String) {
        self.userName = userName
    }

    // MARK: - Views

    public var body: some View {
        ScrollView(showsIndicators: false) {
            switch viewModel.contentState {
            case .loading:
                content(from: .stubbed)
                    .redacted(reason: .placeholder)
            case let .content(user):
                content(from: user)
                    .readingScrollView(from: "scrollOffSet", into: $scrollOffset)
            case .error:
                ErrorView(
                    title: "Cannot Connect",
                    message: "Something went wrong. Please try again."
                ) {
                    fetchUser()
                }
            }
        }
        .background(Colors.scrollViewBackground.color)
        .onAppear {
            fetchUser()
        }
        .refreshable {
            fetchUser()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if currentAccount.user?.login == viewModel.user.login {
                    authenticatedToolbar
                }
            }

            if scrollOffset.y >= -11 {
                ToolbarItem(placement: .principal) {
                    Text(userName)
                        .fontWeight(.medium)
                }
            }
        }
    }

    @ViewBuilder
    private func content(from user: User) -> some View {
        VStack {
            ProfileMainView(user: user)

            VStack(spacing: 0) {
                makeButton(
                    title: "Gists",
                    image: "doc.text.magnifyingglass",
                    backgroundImage: Colors.buttonForeground.color
                ) {
                    routerPath.navigate(to: .gistLists(mode: .userGists(userName: userName)))
                }

                divider

                makeButton(
                    title: "Starred",
                    image: "star",
                    backgroundImage: Colors.Palette.Yellow.yellow2.dynamicColor.color
                ) {
                    routerPath.navigate(to: .gistLists(mode: .userStarredGists(userName: userName)))
                }
                divider

                forkButtonRowView
            }
            .background(Colors.listBackground.color)
        }
    }

    @ViewBuilder
    private var authenticatedToolbar: some View {
        HStack(spacing: 0) {
            Button {
                routerPath.navigate(to: .settings)
            } label: {
                Image(systemName: "gear")
                    .foregroundColor(Colors.accent.color)
            }

            let titlePreview = "\(currentAccount.user?.login ?? "") - Overview"
            ShareLink(
                item: currentAccount.user?.htmlURL ?? "",
                preview: SharePreview(titlePreview, image: Image("default"))
            ) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Colors.accent.color)
            }
        }
    }

    @ViewBuilder
    private var divider: some View {
        Divider()
            .overlay(Colors.neutralEmphasis.color)
            .padding(.leading, 56)
    }

    @ViewBuilder
    private var forkButtonRowView: some View {
        Button(action: {}, label: {
            HStack(alignment: .center) {
                Label {
                    Text("Forked")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                } icon: {
                    Image(uiImage: UIImage(named: "fork")!)
                        .renderingMode(.template)
                        .frame(width: 9, height: 9)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Colors.Palette.Purple.purple3.dynamicColor.color)
                        .cornerRadius(6.0)
                }
                Spacer()
                RightChevronRowImage()
            }
        })
        .frame(height: 37)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    private func makeButton(
        title: LocalizedStringKey,
        image: String,
        backgroundImage: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action, label: {
            HStack(alignment: .center) {
                Label {
                    Text(title)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                } icon: {
                    Image(systemName: image)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                        .background(backgroundImage)
                        .cornerRadius(6.0)
                }
                Spacer()
                RightChevronRowImage()
            }
        })
        .frame(height: 37)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }

    // MARK: - Side Effects

    private func fetchUser() {
        Task {
            await viewModel.fetchUser(fromUserName: userName)
        }
    }
}
