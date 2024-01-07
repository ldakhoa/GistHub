import SwiftUI
import Models
import DesignSystem
import OrderedCollections

public struct GistListsRowView: View {
    let gist: Gist
    let shouldGetFilesCountFromGist: Bool

    public init(gist: Gist, shouldGetFilesCountFromGist: Bool) {
        self.gist = gist
        self.shouldGetFilesCountFromGist = shouldGetFilesCountFromGist
    }

    public var body: some View {
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
                    let prefixContent: String = gist.isUpdated ?? false ? "Last active" : "Created"
                    Text("\(prefixContent) \(updatedAt.agoString())")
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .font(.caption)
                }

                HStack(alignment: .center) {
                    let filesCountPrefix = getFilesCount(from: files)
                    let fileTitle: String = filesCountPrefix > 1 ? "files" : "file"
                    footerItem(title: "\(filesCountPrefix) \(fileTitle)", imageName: "file-code")
                    let forkCountTitle = gist.fork?.totalCount ?? 0 > 1 ? "forks" : "fork"
                    footerItem(title: "\(gist.fork?.totalCount ?? 0) \(forkCountTitle)", imageName: "fork")
                    let commentTitle = gist.comments ?? 0 > 1 ? "comments" : "comment"
                    footerItem(title: "\(gist.comments ?? 0) \(commentTitle)", imageName: "comment")
                    let stargazerCountTitle = gist.stargazerCount ?? 0 > 1 ? "stars" : "star"
                    footerItem(title: "\(gist.stargazerCount ?? 0) \(stargazerCountTitle)", imageName: "star")
                }
            }
        }
    }

    private func getFilesCount(from files: OrderedDictionary<String, File>) -> Int {
        let filesCount: Int
        if shouldGetFilesCountFromGist {
            filesCount = gist.fileTotalCount ?? 1
        } else {
            filesCount = files.keys.count
        }
        return filesCount
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
