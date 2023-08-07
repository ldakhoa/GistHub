import SwiftUI
import Comment
import Models
import DesignSystem
import Environment

struct GistDetailCommentSectionView: View {
    @ObservedObject var commentViewModel: CommentViewModel
    let gistId: String
    let currentAccount: CurrentAccount

    @State private var progressViewId = 0

    var body: some View {
        ZStack {
            switch commentViewModel.contentState {
            case .loading:
                VStack(alignment: .leading) {
                    ForEach(Comment.placeholders, id: \.id) { comment in
                        CommentView(comment: comment, gistID: gistId, viewModel: commentViewModel)
                            .redacted(reason: .placeholder)
                        Divider()
                            .overlay(Colors.neutralEmphasis.color)
                    }
                }
            case let .error(error):
                Text(error).foregroundColor(Colors.danger.color)
            case .showContent:
                let comments = commentViewModel.comments
                VStack(alignment: .leading) {
                    let commentTitle = comments.count > 1 ? "Comments" : "Comment"
                    Text(comments.isEmpty ? "" : commentTitle)
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 15, weight: .regular)))
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                        .padding(.horizontal, 16)
                    LazyVStack(alignment: .leading) {
                        ForEach(comments, id: \.id) { comment in
                            CommentView(comment: comment, gistID: gistId, viewModel: commentViewModel)
                                .onAppear {
                                    Task {
                                        await commentViewModel.fetchMoreCommentsIfNeeded(
                                            currentCommentID: comment.nodeID,
                                            gistID: gistId
                                        )
                                    }
                                }
                                .id(comment.id)
                                .environmentObject(currentAccount)
                            if !isLastObject(objects: comments, object: comment) {
                                Divider()
                                    .overlay(Colors.neutralEmphasis.color)
                            }
                        }
                    }
                    .padding(.vertical, comments.isEmpty ? 0 : 4)
                    .background(Colors.itemBackground)

                    if commentViewModel.isLoadingMoreComments {
                        HStack {
                            Spacer()
                            ProgressView()
                                .foregroundColor(Colors.accent.color)
                                .id(progressViewId)
                                .onAppear {
                                    progressViewId += 1
                                }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

fileprivate extension Colors {
    static let itemBackground = UIColor.secondarySystemGroupedBackground.color
}
