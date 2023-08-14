import SwiftUI
import Models
import DesignSystem

struct SearchGistLanguagesView: View {
    @Environment(\.dismiss) private var dismiss

    let searchResultLanguages: [GistSearchResultLanguage]
    let completion: ((String) -> Void)?

    var body: some View {
        ZStack {
            Colors.scrollViewBackground.color
            List {
                Section {
                    ForEach(searchResultLanguages, id: \.language) { searchResultLanguage in
                        Button {
                            completion?(searchResultLanguage.language)
                            dismiss()
                        } label: {
                            HStack {
                                Text(searchResultLanguage.language)
                                    .foregroundColor(Colors.foreground.color)
                                Spacer()
                                Text("\(searchResultLanguage.count)")
                                    .foregroundColor(Colors.neutralEmphasis.color)
                                RightChevronRowImage()
                            }
                        }
                    }
                } header: {
                    Spacer(minLength: 0)
                }
            }
            .padding(.top, -28)
            .listStyle(.grouped)
        }
        .navigationTitle("Languages")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .accentColor(Colors.accent.color)
            }
        }
    }
}

fileprivate extension Colors {
    static let foreground = UIColor(light: .black, dark: .white)
}
