import SwiftUI
import DesignSystem
import Environment

public struct SearchView: View {
    @EnvironmentObject private var routerPath: RouterPath
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
                    searchButtonRow(title: "Gists", image: "doc.text.magnifyingglass") {
                    }
                    searchButtonRow(title: "File name", image: "puzzlepiece.extension") {
                    }
                    searchButtonRow(title: "Users", image: "person") {
                        routerPath.navigate(to: .searchUsers(query: viewModel.query))
                    }
                    searchButtonRow(title: "Query", image: "point.topleft.down.curvedto.point.bottomright.up") {
                    }
                }
                .foregroundColor(Colors.buttonForeground.color)
            }
        }
        .background(Colors.scrollViewBackground.color)
        .scrollContentBackground(.hidden)
        .overlay(Group {
            if viewModel.query.isEmpty && userDefaultsStore.recentSearchKeywords.isEmpty {
                SearchEmptyView()
            }
        })
        .listStyle(.grouped)
        .animation(.linear, value: viewModel.query.isEmpty)
        .searchable(text: $viewModel.query, prompt: Text("Search GistHub"))
        .autocorrectionDisabled()
        .autocapitalization(.none)
        .navigationTitle("Search")
        .onSubmit(of: .search) {
            print("Should handle search all")
        }
    }

    @ViewBuilder
    private func searchButtonRow(
        title: String,
        image: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
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
