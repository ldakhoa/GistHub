import SwiftUI
import DesignSystem
import Environment

public struct SearchView: View {
    @EnvironmentObject private var userDefaultsStore: UserDefaultsStore
    @StateObject private var viewModel: SearchViewModel = SearchViewModel()

    public init() {}

    public var body: some View {
        List {
            if viewModel.query.isEmpty && !userDefaultsStore.recentSearchKeywords.isEmpty {
                Section {
                    ForEach(userDefaultsStore.recentSearchKeywords, id: \.self) { keyword in
                        ButtonRowView(title: "\(keyword)") {
                            viewModel.query = keyword
                        }
                        .frame(height: 38)
                    }
                } header: {
                    HStack {
                        Text("Recent searches")
                        Spacer()
                        Button("Clear") {
                            userDefaultsStore.recentSearchKeywords = []
                        }
                    }
                    .headerProminence(.increased)
                }
            } else if !viewModel.query.isEmpty {
                Section {
                    searchButtonRow(title: "Gists", image: "list.bullet.rectangle.portrait") {
                    }
                    searchButtonRow(title: "File name", image: "puzzlepiece.extension") {
                    }
                    searchButtonRow(title: "Users", image: "person") {
                    }
                    searchButtonRow(title: "Query", image: "point.topleft.down.curvedto.point.bottomright.up") {
                    }

                }
                .foregroundColor(Colors.buttonForeground.color)
            }
        }
        .overlay(Group {
            if viewModel.query.isEmpty && userDefaultsStore.recentSearchKeywords.isEmpty {
                SearchEmptyView()
            }
        })
        .animation(.linear, value: viewModel.query)
        .searchable(text: $viewModel.query, prompt: Text("Search GistHub"))
        .autocorrectionDisabled()
        .autocapitalization(.none)
        .navigationTitle("Search")
    }

    @ViewBuilder
    private func searchButtonRow(
        title: String,
        image: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
        } label: {
            HStack {
                Label("\(title) with \"\(viewModel.query)\"", systemImage: image)
                Spacer()
                RightChevronRowImage()
            }
            .frame(height: 38)
        }

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchView()
                .environmentObject(UserDefaultsStore.shared)
        }
    }
}
