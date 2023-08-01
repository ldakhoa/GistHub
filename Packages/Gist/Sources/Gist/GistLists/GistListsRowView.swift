import SwiftUI
import Models
import DesignSystem

struct GistListsRowView: View {
    let gist: Gist

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let files = gist.files,
               let fileName: String = files.fileName {
                HStack(alignment: .center, spacing: 6) {
                    if
                        let avatarURLString = gist.owner?.avatarURL,
                        let url = URL(string: avatarURLString)
                    {
                        GistHubImage(url: url)
                    }
                    Text(gist.owner?.login ?? "")
                        .font(.subheadline)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                }

                HStack(alignment: .center, spacing: 2) {
                    Text(fileName)
                        .bold()

                    if !(gist.public ?? true) {
                        Image(systemName: "lock")
                            .font(.subheadline)
                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                            .padding(.leading, 2)
                    }
                }

                if let description = gist.description, !description.isEmpty {
                    Text(description)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .font(.subheadline)
                        .lineLimit(2)
                }

                if let createdAt = gist.createdAt,
                   let updatedAt = gist.updatedAt {
                    if createdAt == updatedAt {
                        Text("Created \(createdAt.agoString())")
                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                            .font(.caption)
                    } else {
                        Text("Last active \(createdAt.agoString())")
                            .foregroundColor(Colors.neutralEmphasisPlus.color)
                            .font(.caption)
                    }
                } else if let updatedAt = gist.updatedAt {
                    // For gisthubapp server case
                    Text("Last active \(updatedAt.agoString())")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .font(.caption)
                }

                HStack(alignment: .center) {
                    let fileTitle = files.keys.count > 1 ? "files" : "file"
                    footerItem(title: "\(files.keys.count) \(fileTitle)", imageName: "file-code")
                    let commentTitle = gist.comments ?? 0 > 1 ? "comments" : "comment"
                    footerItem(title: "\(gist.comments ?? 0) \(commentTitle)", imageName: "comment")
                    let stargazerCountTitle = gist.stargazerCount ?? 0 > 1 ? "stars" : "star"
                    footerItem(title: "\(gist.stargazerCount ?? 0) \(stargazerCountTitle)", imageName: "star")
                }
            }
        }
    }

    private func footerItem(title: String, imageName: String) -> some View {
        HStack(alignment: .center, spacing: 2) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .frame(width: 16, height: 16)
            Text(title)
                .font(.footnote)
        }
        .foregroundColor(Colors.neutralEmphasisPlus.color)
        .padding(.top, 2)
    }
}
