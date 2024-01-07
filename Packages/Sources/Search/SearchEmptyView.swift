import SwiftUI
import DesignSystem

struct SearchEmptyView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    Text("Search GistHub")
                        .font(.title3)
                        .padding(.top, 16)
                    Text("Search all of GistHub for Gists and People.\nRecent searches are saved.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Colors.neutralEmphasis.color)
                }
                Spacer()
            }
        }
    }
}

struct SearchEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        SearchEmptyView()
    }
}
