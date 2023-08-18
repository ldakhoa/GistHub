import SwiftUI
import Models
import DesignSystem
import OrderedCollections
import Environment

struct RecentActivitiesSectionView: View {
    @EnvironmentObject private var routerPath: RouterPath
    let recentComments: OrderedSet<RecentComment>

    var body: some View {
        ForEach(recentComments) { recentComment in
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center, spacing: 6) {
                    if
                        let avatarURLString = recentComment.gist.owner?.avatarURL,
                        let url = URL(string: avatarURLString)
                    {
                        GistHubImage(url: url)
                    }

                    if let files = recentComment.gist.files,
                       let fileName = files.keys.first,
                       let login = recentComment.gist.owner?.login {
                        Group {
                            Text(login)
                                .bold()
                            +
                            Text(" / ")
                                .foregroundColor(Colors.neutralEmphasis.color)
                            +
                            Text(fileName)
                                .bold()
                        }
                    }

                    Spacer()

                    Text("11d")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }

                if let description = recentComment.gist.description {
                    Text(description)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }

                Text("You commented")
                    .foregroundColor(Colors.neutralEmphasisPlus.color)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                routerPath.navigateToGistDetail(with: recentComment.gist.id)
            }
        }
    }
}
