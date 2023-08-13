import SwiftUI
import DesignSystem
import Environment

public struct HomeView: View {
    @EnvironmentObject private var currentAccount: CurrentAccount
    @EnvironmentObject private var routerPath: RouterPath

    public init() {}

    public var body: some View {
        List {
            Section {
                buttonRowView(
                    title: "Gists",
                    image: "doc.text.magnifyingglass",
                    imageBackground: Colors.buttonForeground.color
                ) {
                    routerPath.navigate(to: .gistLists(mode: .currentUserGists))
                }

                buttonRowView(
                    title: "Starred",
                    image: "star",
                    imageBackground: Colors.Palette.Yellow.yellow2.dynamicColor.color
                ) {
                    routerPath.navigate(to: .gistLists(mode: .userStarredGists(userName: currentAccount.user?.login ?? "ghost")))
                }

                buttonRowView(title: "Draft", image: "doc.text", imageBackground: Colors.Palette.Orange.orange3.dynamicColor.color) {
                    routerPath.navigate(to: .draftGistLists)
                }
            } header: {
                Text("My Gist")
                    .headerProminence(.increased)
            }

            Section {
                VStack(spacing: 12) {
                    Text("Add favorite gists here for quick access anytime, without the need to search")
                        .multilineTextAlignment(.center)

                    Button(action: {
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Add Quick Access")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(12)
                        .foregroundColor(Colors.accent.color)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Colors.buttonBorder.color)
                        )
                    })
                }
                .frame(maxWidth: .infinity)
            } header: {
                Text("Quick Access")
                    .headerProminence(.increased)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private var newGistFloatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                GistHubButton(
                    imageName: "plus",
                    foregroundColor: Color.white,
                    background: Colors.accent.color,
                    padding: 18.0,
                    radius: 36.0
                ) {
                    routerPath.presentedSheet = .newGist { gist in
//                        viewModel.insert(gist)
                        routerPath.navigate(to: .gistDetail(gistId: gist.id))
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
        }
    }

    @ViewBuilder
    private func buttonRowView(
        title: String,
        image: String,
        imageBackground: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action, label: {
            HStack {
                Label {
                    Text(title)
                        .foregroundColor(Colors.neutralEmphasisPlus.color)
                } icon: {
                    Image(systemName: image)
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                        .background(imageBackground)
                        .cornerRadius(6.0)
                }
                Spacer()
                RightChevronRowImage()
            }
        })
        .frame(height: 37)
    }
}
