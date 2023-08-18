import SwiftUI
import Models
import DesignSystem
import OrderedCollections
import Environment
import Utilities

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
                        .font(.callout)
                    }
                }

//                if let description = recentComment.gist.description {
//                    Text(description)
//                        .foregroundColor(Colors.neutralEmphasisPlus.color)
//                }

                Text("\"\(recentComment.body)\"")
                    .foregroundColor(Colors.neutralEmphasisPlus.color)
                    .font(.callout)
                    .truncationMode(.tail)
                    .lineLimit(2)

                if let updatedAt = recentComment.updatedAt,
                   let createdAt = recentComment.createdAt {
                    let date = updatedAt == createdAt ? createdAt : updatedAt
                    Text("You commented \(date.agoString(style: .spellOut))")
                        .foregroundColor(Colors.neutralEmphasis.color)
                        .font(.subheadline)
                }

            }
            .contentShape(Rectangle())
            .onTapGesture {
                routerPath.navigateToGistDetail(with: recentComment.gist.id)
            }
        }
    }
}
