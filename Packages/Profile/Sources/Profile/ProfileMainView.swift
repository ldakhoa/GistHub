import SwiftUI
import Models
import DesignSystem
import Environment

struct ProfileMainView: View {
    @EnvironmentObject private var routerPath: RouterPath

    private let user: User

    init(user: User) {
        self.user = user
    }

    var body: some View {
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
                Group {
                    Text("\(user.followers ?? 0) ")
                        .bold()
                    +
                    Text(followerText)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    routerPath.navigate(to: .userFollows(login: user.login ?? "ghost", type: .follower))
                }

                Text(" · ")

                let followingText = user.followers ?? 0 > 1 ? "followings" : "following"
                Group {
                    Text("\(user.following ?? 0) ")
                        .bold()
                    +
                    Text(followingText)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    routerPath.navigate(to: .userFollows(login: user.login ?? "ghost", type: .following))
                }
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
