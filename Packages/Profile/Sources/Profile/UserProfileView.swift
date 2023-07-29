import SwiftUI
import Models
import Environment
import DesignSystem
import Inject
import AppAccount
import Utilities

public struct UserProfileView: View {
    @ObserveInjection private var inject
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
        .navigationBarTitleDisplayMode(.inline)
        .enableInjection()
    }

    @ViewBuilder
    private func content(from user: User) -> some View {
        VStack {
            ProfileMainView(user: user)

            VStack(spacing: 0) {
                makeButton(
                    title: "Gists",
                    systemImageName: "doc.text",
                    backgroundImage: Colors.buttonForeground.color
                ) {
                    routerPath.navigate(to: .gistLists(mode: .userGists(userName: userName)))
                }

                Divider()
                    .overlay(Colors.neutralEmphasis.color)
                    .padding(.leading, 54)

                makeButton(
                    title: "Starred",
                    systemImageName: "star",
                    backgroundImage: Colors.Palette.Yellow.yellow2.dynamicColor.color
                ) {
                    // implement
                    routerPath.navigate(to: .gistLists(mode: .currentUserStarredGists))
                }
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

    private func makeButton(
        title: LocalizedStringKey,
        systemImageName: String,
        backgroundImage: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action, label: {
            HStack(alignment: .center) {
                HStack {
                    Image(systemName: systemImageName)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                        .background(backgroundImage)
                        .cornerRadius(6.0)

                    Text(title)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }
                Spacer()
                RightChevronRowImage()
            }
        })
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

public struct ProfileMainView: View {
    private let user: User

    public init(user: User) {
        self.user = user
    }

    public var body: some View {
        mainView
    }

    @ViewBuilder
    private var mainView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                if let avatarURLString = user.avatarURL, let url = URL(string: avatarURLString) {
                    GistHubImage(url: url, width: 70, height: 70, cornerRadius: 35)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(user.name ?? "")
                        .font(.title2)
                        .bold()
                    Text("@\(user.login!)")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }
            }

            HStack(alignment: .center) {
                if let company = user.company {
                    imageText(imageName: "organization", title: company)
                }

                if let location = user.location {
                    imageText(imageName: "location", title: location)
                }

                if let email = user.email {
                    imageText(imageName: "at", title: email)
                }
            }

            HStack(spacing: 4) {
                Image("person")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 16, height: 16)
                    .foregroundColor(Colors.neutralEmphasisPlus.color)

                let followerText = user.followers ?? 0 > 1 ? "followers" : "follower"
                Text("\(user.followers ?? 0) ") +
                Text(followerText).foregroundColor(Colors.neutralEmphasisPlus.color)

                Text(" · ")

                let followingText = user.followers ?? 0 > 1 ? "followings" : "following"
                Text("\(user.following ?? 0) ") +
                Text(followingText).foregroundColor(Colors.neutralEmphasisPlus.color)
            }

            if let htmlURL = user.htmlURL,
               let url = URL(string: htmlURL) {
                Link(destination: url) {
                    HStack {
                        Spacer()
                        Text("View GitHub Profile")
                            .font(.callout)
                            .fontWeight(.semibold)
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
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(24)
    }

    private func imageText(imageName: String, title: String) -> some View {
        HStack(spacing: 4) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Colors.neutralEmphasisPlus.color)
                .frame(width: 16, height: 16)
            Text(title)
                .font(.subheadline)
                .foregroundColor(Colors.neutralEmphasisPlus.color)
        }
    }
}
