import SwiftUI

public struct ShareLinkView: View {
    private let item: URL
    private let labelTitle: String

    public init(
        item: URL,
        labelTitle: String = "Share via..."
    ) {
        self.item = item
        self.labelTitle = labelTitle
    }

    public var body: some View {
        ShareLink(item: item) {
            Label(labelTitle, systemImage: "square.and.arrow.up")
        }
    }
}
