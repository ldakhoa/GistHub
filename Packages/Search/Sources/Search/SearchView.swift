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
                    .onDelete { indexSet in
                        for index in indexSet {
                            let keyword = userDefaultsStore.recentSearchKeywords[index]
                            userDefaultsStore.recentSearchKeywords.remove(keyword)
                        }
                    }
                } header: {
                    HStack {
                        Text("Recent searches")
                        Spacer()
                        Button("Clear") {
                            userDefaultsStore.recentSearchKeywords.removeAll()
                        }
                    }
                    .headerProminence(.increased)
                }
            } else if !viewModel.query.isEmpty {
                Section {
                    searchButtonRow(title: "Gists", image: "doc.text.magnifyingglass") {
                        routerPath.navigate(to: .searchGists(query: viewModel.query))
                    }
                    searchButtonRow(title: "File name", image: "doc.on.doc") {
                        let fileNameQuery: String = "filename:\(viewModel.query)"
                        routerPath.navigate(to: .searchGists(query: fileNameQuery))
                    }
                    searchButtonRow(title: "Language", image: "globe") {
                        let languageQuery: String = "language:\(viewModel.query)"
                        routerPath.navigate(to: .searchGists(query: languageQuery))
                    }
                    searchButtonRow(title: "Extension", image: "puzzlepiece.extension") {
                        let extensionQuery: String = "extension:\(viewModel.query)"
                        routerPath.navigate(to: .searchGists(query: extensionQuery))
                    }
                    searchButtonRow(title: "People", image: "person") {
                        routerPath.navigate(to: .searchUsers(query: viewModel.query))
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
            userDefaultsStore.recentSearchKeywords.insert(viewModel.query)
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
