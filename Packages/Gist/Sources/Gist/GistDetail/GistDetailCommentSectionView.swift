import SwiftUI
import Comment
import Models
import DesignSystem
import Environment

struct GistDetailCommentSectionView: View {
    @ObservedObject var commentViewModel: CommentViewModel
    let gist: Gist
    let currentAccount: CurrentAccount

    @State private var progressViewId = 0

    var body: some View {
        ZStack {
            switch commentViewModel.contentState {
            case .loading:
                ProgressView()
                    .tint(Colors.accent.color)
            case .error:
                ErrorView(title: "Cannot Load Comment") {
                    Task {
                        await commentViewModel.fetchComments(gistID: gist.id)
                    }
                }
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
                            CommentView(comment: comment, gist: gist, viewModel: commentViewModel)
                                .onAppear {
                                    Task {
                                        await commentViewModel.fetchMoreCommentsIfNeeded(
                                            currentCommentID: comment.nodeID,
                                            gistID: gist.id
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
