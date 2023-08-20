import SwiftUI
import Models
import DesignSystem

public struct UserListRowView: View {
    private let user: User
    private let action: () -> Void

    public init(user: User, action: @escaping () -> Void) {
        self.user = user
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(alignment: .top) {
                if let avatarUrlString = user.avatarURL, let url = URL(string: avatarUrlString) {
                    GistHubImage(url: url, width: 48, height: 48, cornerRadius: 24)
                }
                VStack(alignment: .leading) {
                    Text(user.name ?? "")
                        .foregroundColor(UIColor.label.color)
                        .fontWeight(.semibold)

                    Text(user.login ?? "ghost")
                        .font(.callout)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)

                    if let bio = user.bio, !bio.isEmpty {
                        Text(bio)
                            .font(.callout)
                            .foregroundColor(UIColor.label.color)
                    }
                }
                Spacer()
                RightChevronRowImage()
            }
        }
    }
}
